import 'package:flutter/material.dart';

class NameDivider extends StatelessWidget {
  const NameDivider({super.key, required this.firstLetter, required this.top});
  
  final String firstLetter;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: 15),
      child: Row(
        children: [
          Expanded(child: Divider(thickness: 1, color: Colors.grey[600])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(firstLetter, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
            //child: Text(DateFormat("mmmm dd").format(DateTime.now())),
          ),
          Expanded(child: Divider(thickness: 1, color: Colors.grey[600]))
        ]
      )
    );
  }
}