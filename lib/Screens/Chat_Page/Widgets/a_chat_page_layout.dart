import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:app_1gochat/Screens/Chat_Page/Widgets/Attachment_Widget/attachment_chosen_display.dart';
import 'package:app_1gochat/Screens/Chat_Page/Widgets/b_chat_appbar.dart';
import 'package:app_1gochat/Screens/Chat_Page/Widgets/b_chat_body.dart';
import 'package:app_1gochat/Screens/Chat_Page/Widgets/b_chat_localtime_streambuilder.dart';
import 'package:app_1gochat/Screens/Chat_Page/Widgets/b_chat_textfield.dart';
import 'package:flutter/material.dart';

class ChatPageLayout extends StatelessWidget{
  const ChatPageLayout({super.key, required this.recipient, required this.chatname, required this.currentUserId, 
  required this.username, required this.textController, required this.scrollController, required this.messageSubmit
  });

  final Room recipient;
  final String chatname;
  final String currentUserId;
  final String username;
  final TextEditingController textController;
  final ScrollController scrollController;
  final void Function(String) messageSubmit;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: 150,
              color: Theme.of(context).primaryColor,
            ),
    
            Column(
              children: [
                ChatPageAppBar(
                  user: chatname,
                  voicecall: () {},
                  videocall: () {}
                ),

                Expanded(
                  child: ChatPageBody(
                    chatbodyContents: ChatLocalTimeStreamBuilder(
                      username: username,
                      currentUserId: currentUserId,
                      recipient: recipient.id,
                      scrollController: scrollController,
                    )
                  )
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AttachmentDisplay(),
                    ChatTextField(
                      textController: textController,
                      messageSubmit: messageSubmit
                    )
                  ]
                )
              ]
            )
          ]
        )
      )
    );
  }
}