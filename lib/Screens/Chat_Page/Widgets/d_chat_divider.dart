import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatDivider extends StatelessWidget {
  const ChatDivider({super.key, required this.date, required this.top});
  
  final DateTime? date;
  final double top;

  @override
  Widget build(BuildContext context) {
    if(date != null) {
      return Padding(
        padding: EdgeInsets.only(top: top, bottom: 15),
        child: Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[600],)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(displayDate(), style: const TextStyle(fontSize: 12))
              //child: Text(DateFormat("mmmm dd").format(DateTime.now())),
            ),
            Expanded(child: Divider(color: Colors.grey[600]))
          ]
        )
      );
    }
    return const SizedBox();
  }

  String displayDate() {
    DateTime now = DateTime.now();
    
    if(date!.year == now.year && date!.month == now.month && date!.day == now.day) {
      return "Today";
    }

    else {
      return DateFormat('MMMM d').format(date!);
    }
  }
}