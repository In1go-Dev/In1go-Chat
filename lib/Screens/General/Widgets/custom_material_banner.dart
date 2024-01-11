import 'package:flutter/material.dart';

class CustomMaterialBannerMessenger extends MaterialBanner {
  final String message;
  final bool isError;
  final ThemeData themeDisplay;
  final VoidCallback dismissMessenger;

  CustomMaterialBannerMessenger({super.key, required this.message, required this.isError, required this.themeDisplay, required this.dismissMessenger}) : super (
    leading: Icon(isError.icon, color: (isError) ? Colors.white : null),
    content: Text(message),
    contentTextStyle: TextStyle(color: (isError) ? Colors.white : Colors.black),
    backgroundColor: (isError) ? themeDisplay.colorScheme.error : null,
    actions: [
      IconButton(onPressed: dismissMessenger, icon: Icon(Icons.close, color: (isError) ? Colors.white : null))
    ]
  );
}

extension on bool {
  IconData get icon {
    switch (this) {
      case true:
        return Icons.error;
      case false:
        return Icons.circle_notifications;
    }
  }
}