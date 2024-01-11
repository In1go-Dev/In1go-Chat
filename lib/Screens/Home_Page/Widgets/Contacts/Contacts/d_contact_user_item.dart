import 'package:flutter/material.dart';

class ContactUserItems extends StatelessWidget {
  const ContactUserItems({super.key, required this.accountName, required this.navigateToChatScreen, required this.navigateToAccountScreen});
  
  final VoidCallback navigateToChatScreen;
  final VoidCallback navigateToAccountScreen;
  final String accountName;

  @override
  Widget build(BuildContext context) {
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
        title: Text(accountName, style: const TextStyle(fontWeight: FontWeight.w500),  overflow: TextOverflow.ellipsis)
      )
    );
  }
}