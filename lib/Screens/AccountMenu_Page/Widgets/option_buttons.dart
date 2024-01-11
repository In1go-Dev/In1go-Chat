import 'package:flutter/material.dart';

class OptionButtons extends StatelessWidget {
  const OptionButtons({super.key, required this.functions, required this.optionIcon, required this.label, this.color});

  final VoidCallback functions;
  final IconData optionIcon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: functions,
      elevation: 0,
      padding: const EdgeInsets.all(0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: Icon(optionIcon),
        ),
        title: Text(label)
      )
    );
  }
}