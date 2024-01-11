import 'dart:developer';

import 'package:app_1gochat/Screens/Chat_Page/Widgets/Message_Widget/b_file_type_checker.dart';
import 'package:app_1gochat/Screens/Chat_Page/Widgets/Message_Widget/b_message_text.dart';
import 'package:app_1gochat/Screens/Chat_Page/Widgets/Message_Widget/b_unrecognized_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({super.key, required this.isCurrentUser, required this.roomId, required this.messageId,
  required this.text, required this.attachment, required this.messageType, required this.width, required this.postTime, required this.messageEvent});

  final bool isCurrentUser;
  final String roomId;
  final String messageId;
  final String text;
  final String attachment;
  final String messageType;
  final double width;
  final String postTime;
  final VoidCallback messageEvent;

  @override
  Widget build(BuildContext context) {
    log('It passed before the Message Bubble Message');
    
    return Column (
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: (isCurrentUser == false) ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: chatMessageDisplay()
    );
  }

  List<Widget> chatMessageDisplay() {
    List<String> messageTypeLists = ['TEXT', 'IMAGE', 'AUDIO', 'VIDEO', 'FILE'];
    final checkMessageType = messageTypeLists.where((element) => element == messageType);

    final widgetsToDisplay = <Widget>[];

    //If the chat message has attachments
    if(messageTypeLists.contains(messageType)) {
      widgetsToDisplay.add(
        Visibility(
          visible: (attachment.isNotEmpty) ? true : false,
          child: Container(
            constraints: (messageType != messageTypeLists[1] && messageType != messageTypeLists[3])
             ? BoxConstraints(maxWidth: width * 0.6)
             : BoxConstraints(
              maxWidth: width * 0.45,
              minWidth: width * 0.45,
              maxHeight: width * 0.6,
              minHeight: width * 0.6
            ),
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomLeft: (text.isNotEmpty) ? const Radius.circular(3) : const Radius.circular(10),
                bottomRight: (text.isNotEmpty) ? const Radius.circular(3) : const Radius.circular(10),
              )
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomLeft: (text.isNotEmpty && !isCurrentUser) ? const Radius.circular(3) : const Radius.circular(10),
                bottomRight: (text.isNotEmpty && isCurrentUser) ? const Radius.circular(3) : const Radius.circular(10),
              ),
              child: FileTypeChecker(
                key: Key(messageId),
                roomId: roomId,
                messageId: messageId,
                attachment: attachment,
                attachmentType: messageType,
                width: width,
              )
            )
          )
        )
      );

      //If the chat message has text messages
      if(text.isNotEmpty) {
        widgetsToDisplay.add(
          TextMessage(
            maxWidth: width * 0.6,
            isCurrentUser: isCurrentUser,
            hasAttachment: (attachment.isNotEmpty) ? true : false,
            text: text,
            messageEvent: messageEvent,
          ),
        );
      }
    }

    else{
      widgetsToDisplay.add(
        UnrecognizedMessage(maxWidth: width * 0.6)
      );
    }

    //Display for the Message Timestamp
    widgetsToDisplay.add(
      Visibility(
        visible: (checkMessageType.isEmpty) ? false : true,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Text(displayTime(postTime), style: const TextStyle(fontSize: 12))
        )
      )
    );

    return widgetsToDisplay;
  }
  
  String displayTime(String postTime) => (postTime != 'No Time') ? DateFormat("h:mm a").format(DateTime.parse(postTime)) : 'No Time';
}