import 'package:flutter/material.dart';

class ChatPageBody extends StatelessWidget {
  const ChatPageBody({super.key, required this.chatbodyContents});

  final Widget chatbodyContents;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45)
        )
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45)
        ),
        child: chatbodyContents
      )
    );
  }
}