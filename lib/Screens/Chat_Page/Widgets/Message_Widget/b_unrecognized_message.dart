import 'package:flutter/material.dart';

class UnrecognizedMessage extends StatelessWidget {
  const UnrecognizedMessage({super.key, required this.maxWidth});

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      margin: const EdgeInsets.only(bottom: 5.0),
      decoration: BoxDecoration(
        color: Colors.grey[300]!,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[350]!)
      ),
      child: const Text('This message can\'t be recognized' , style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic))
    );
  }
}