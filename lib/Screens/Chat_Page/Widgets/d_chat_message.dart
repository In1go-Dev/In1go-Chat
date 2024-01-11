import 'dart:developer';

import 'package:app_1gochat/Screens/Chat_Page/Widgets/Message_Widget/a_message_bubble.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {   //02-23: GEU - Chat Message Layout of the User
  const ChatMessage({super.key, required this.text, required this.attachment, required this.account, required this.roomId, required this.messageId,
  required this.postTime, required this.messageType, required this.isCurrentUser, required this.messageEvent});
  
  final String text;
  final String attachment;
  final String messageType;
  final String account;
  final String roomId;
  final String messageId;
  final String postTime;
  final VoidCallback messageEvent;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    log('It passed before the Chat Message');
    
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Row(
        mainAxisAlignment: (isCurrentUser == true) ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: (isCurrentUser == true) ? messageBubble(false, width) : messageBubble(false, width).reversed.toList()
      )
    );
  }

  List<Widget> messageBubble(bool state, double width) {          //04-27-2023: GEU - Functionality for message bubble display
    return <Widget>[
      ChatMessageBubble(
        isCurrentUser: isCurrentUser,
        roomId: roomId,
        messageId: messageId,
        text: text,
        attachment: attachment,
        messageType: messageType,
        width: width,
        postTime: postTime,
        messageEvent: messageEvent,
      ),
      
      Visibility(
        visible: state,
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 5, 10, 0),
          child: CircleAvatar(
          backgroundColor: (account.isNotEmpty) ? Colors.white : Colors.white,
            child: (account.isNotEmpty) ? CircleAvatar(
              foregroundColor: Colors.black,
              backgroundColor: Colors.grey[300],
              child: Text((account.isNotEmpty) ? account.substring(0, 2) : '?', overflow: TextOverflow.ellipsis)
            ) : null
          )
        )
      )
    ];
  }
}