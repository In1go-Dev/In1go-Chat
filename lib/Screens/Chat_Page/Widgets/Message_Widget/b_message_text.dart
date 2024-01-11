import 'package:flutter/material.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({super.key, required this.maxWidth, required this.isCurrentUser, required this.hasAttachment, required this.text, required this.messageEvent});

  final double maxWidth;
  final bool isCurrentUser;
  final bool hasAttachment;
  final String text;
  final VoidCallback messageEvent;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      margin: const EdgeInsetsDirectional.only(bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: (hasAttachment && !isCurrentUser) ? const Radius.circular(3) : const Radius.circular(10),
          topRight: (hasAttachment && isCurrentUser) ? const Radius.circular(3) : const Radius.circular(10),
          bottomLeft: const Radius.circular(10),
          bottomRight: const Radius.circular(10),
        )
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft:(hasAttachment && !isCurrentUser) ? const Radius.circular(3) : const Radius.circular(10),
          topRight: (hasAttachment && isCurrentUser) ? const Radius.circular(3) : const Radius.circular(10),
          bottomLeft: const Radius.circular(10),
          bottomRight: const Radius.circular(10),
        ),
        child: Material(
          color: (isCurrentUser == true) ? Theme.of(context).primaryColor : Colors.grey[300]!,
          child: InkWell(
            onLongPress: messageEvent,
            splashColor: (isCurrentUser == true) ? Colors.grey : Colors.grey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(text, style: TextStyle(fontSize: 14, color: (isCurrentUser == true) ? Colors.white : null))
            )
          )
        )
      )
    );
  }
}