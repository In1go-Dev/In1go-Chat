import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Functions/chat_page_functions.dart';
import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ntp/ntp.dart';
import 'package:timezone/timezone.dart' as tz;

final chatField = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());
final listofChatMessages = StateProvider.autoDispose<List<Message>>((ref) => List.empty());
final chatWidgets = StateProvider.autoDispose<List<Column>>((ref) => List.empty());
final listofPendingMessages = StateProvider.autoDispose<List<VoidCallback>>((ref) => List.empty());

final messageProvider = Provider.autoDispose((ref) => MessageListViewModel());

class MessageListViewModel {     //04-27-2023: GEU - Functionalities for Message Models

  //Sends Chat Message

  Future<void> addMessage({required String content, required String sender, required String senderName, required String receiver, required FilePickerResult? pickedFiles}) async {
  
    try {
      final attachment = (pickedFiles != null && pickedFiles.files.isNotEmpty) ? pickedFiles.files.first : null;
      final currTime = await getServerTime();
  
      final attachmentType = checkFileType(attachment);
  
      Message sentMessage = Message(
        content: content,
        sender_id: sender,
        sender_name: senderName,
        room_id: receiver,
        attachment: (attachment != null && attachmentType != null) ? attachment.name : null,
        message_type: (attachment != null && attachmentType != null) ? attachmentType : 'TEXT',
        isDeleted: false,
        isDelivered: 0,
        timestamp: currTime.toString()
      );
      
      if((attachment != null && attachmentType != null)) {
        displayToast("Sending...");
        final result = await uploadAttachment(attachment, receiver, sentMessage.id);
        if(result.isNotEmpty) await Amplify.DataStore.save(sentMessage);
      }

      else {
        await Amplify.DataStore.save(sentMessage);
      }
      
      await updateLatestMessage(sender, receiver, sentMessage);

    } on NetworkException {
      //displayToast("Pending message...");
      displayToast("Failed to send message");
    } on SocketException {
      //displayToast("Pending message...");
      displayToast("Failed to send message");
    } on DataStoreException {
      displayToast("Failed to send message");
    } on StorageException {
      displayToast("Failed to send message");
    }
  }

  //Retrieves the Current PH DateTime from the Amplify server

  Future<DateTime> getServerTime() async {
    String serverZone = 'Asia/Manila';
    tz.Location timezone = tz.getLocation(serverZone);

    //Retrieves Current DateTime from Amplify server
    DateTime time = await NTP.now(lookUpAddress: 'time.aws.com');
    tz.TZDateTime phTime = tz.TZDateTime.from(time, timezone);
    
    return DateTime(
      phTime.year, phTime.month, phTime.day,
      phTime.hour, phTime.minute, phTime.second, phTime.millisecond, phTime.microsecond
    );
  }

  //Updates the Contact Room's Latest Message content

  Future<void> updateLatestMessage(String sender, String receiver, Message sentMessage) async {
    final getRecipientRoom = await Amplify.DataStore.query(Room.classType, where: Room.ID.eq(receiver));
    final oldRoom = getRecipientRoom.first;

    final updatedRoom = Room(
      id: oldRoom.id,
      room_name: oldRoom.room_name,
      creator_id: oldRoom.creator_id,
      isGroup: oldRoom.isGroup,
      message_sender: sender,
      latest_message: sentMessage.content,
      message_type: sentMessage.message_type,
      message_timestamp: sentMessage.timestamp,
      contents: oldRoom.contents,
      members: oldRoom.members
    );
    
    await Amplify.DataStore.save(updatedRoom);
  }
  
  //Uploads the attachment and returns the file name for success confirmation

  Future<String> uploadAttachment(PlatformFile attachment, String recipient, String messageId) async { 
    final uploadedFile = await Amplify.Storage.uploadFile(
      localFile: AWSFile.fromStream (
        attachment.readStream!,
        size: attachment.size,
      ),
      key: "$recipient/${messageId}_${attachment.name}",
      onProgress: (progress) {
        safePrint('Fraction completed: ${progress.fractionCompleted}');
      }
    ).result;
    log('The Uploaded Attachment is - ${uploadedFile.uploadedItem.key}');
    return uploadedFile.uploadedItem.key;
  }
}