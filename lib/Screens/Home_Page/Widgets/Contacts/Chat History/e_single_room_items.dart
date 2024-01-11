
import 'package:app_1gochat/Functions/home_page_functions.dart';
import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/Contacts/Chat%20History/e_currtime_streambuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

class ContactRoomItems extends ConsumerWidget {
  const ContactRoomItems({super.key, required this.currentUserId, required this.accountName, required this.roomData, required this.currentTimeZone,
   required this.navigateToChatScreen, required this.navigateToAccountScreen});

  final String currentUserId;
  final String accountName;
  final Room roomData;
  final String currentTimeZone;
  final VoidCallback navigateToChatScreen;
  final VoidCallback navigateToAccountScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? message = roomData.latest_message;
    String? messageSource = roomData.message_sender;
    String? messageType = roomData.message_type;
    String? messageTime = roomData.message_timestamp;

    return MaterialButton(
      onPressed: navigateToChatScreen,
      onLongPress: navigateToAccountScreen,
      elevation: 0,
      padding: const EdgeInsets.all(0),
      //child: items[index],
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text((accountName.isNotEmpty) ? accountName.substring(0, 2) : '?', style: const TextStyle(color: Colors.white))
        ),
        title: Text(accountName, style: const TextStyle(fontWeight: FontWeight.w500),  overflow: TextOverflow.ellipsis),
        subtitle: setLatestMessage(message, messageSource, messageType),
        trailing: setLatestMessageTimestamp(message, messageSource, messageType, messageTime)
      )
    );
  }


  //Retrieves Widget Display for Latest Message Content - Message depends on text message, attachment (if there are any), and message sender

  Widget setLatestMessage(String? message, String? messageSource, String? messageType) {
    List<String> contentTypes = ["TEXT", "IMAGE", "AUDIO", "VIDEO", "FILE"];
    if(message == null && messageSource == null && messageType == null) {
      return const Text('');
    }

    else {
      if(messageType == contentTypes[0]) {
        final messageDisplay = (message!.isNotEmpty)
         ? Text((messageSource != currentUserId) ? message : "You: $message", overflow: TextOverflow.ellipsis, maxLines: 1)
         : const Text('');
  
        return messageDisplay;
      }
  
      else if(contentTypes.contains(messageType)) {
        final messageDisplay = (message!.isNotEmpty)
         ? Text((messageSource != currentUserId) ? message : "You: $message", overflow: TextOverflow.ellipsis, maxLines: 1)
         : Text(checkAttachmentMessageSource(messageSource!, currentUserId), style: const TextStyle(fontStyle: FontStyle.italic), overflow: TextOverflow.ellipsis, maxLines: 1);
  
        return messageDisplay;
      }
  
      else {
        return const Text('This message can\'t be recognized');
      }
    }
  }

  //Retrieves Widget Display that contains the Latest Message's DateTime, comparing it to device local time

  Widget? setLatestMessageTimestamp(String? message, String? messageSource, String? messageType, String? messageTime) {
    if(((message != null && message.isNotEmpty) || (messageType != null && messageType.isNotEmpty) && 
    (messageSource != null && messageSource.isNotEmpty)) && messageTime != null && messageTime.isNotEmpty) {
      return CurrentTimeStreamBuilder(chatTime: getLocalTime(DateTime.parse(messageTime)));
    }

    else {
      return null;
    }
  }

  DateTime getLocalTime(DateTime time) {
    if(currentTimeZone == "Asia/Singapore") return DateTime.parse(time.toString());
    
    tz.Location defaultZone = tz.getLocation(currentTimeZone);
    tz.TZDateTime phTime = tz.TZDateTime.from(time, defaultZone);
    final result = DateTime(
      phTime.year, phTime.month, phTime.day,
      phTime.hour, phTime.minute, phTime.second, phTime.millisecond, phTime.microsecond
    ).toLocal();
    
    return DateTime.parse(result.toString());
  }
}