import 'package:app_1gochat/Functions/auth_page_functions.dart';
import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:app_1gochat/Screens/AccountMenu_Page/Widgets/account_info.dart';
import 'package:flutter/material.dart';

//Widget for Account Page for User Contacts

class OtherAccountPage extends StatelessWidget {
  const OtherAccountPage({super.key, required this.currentUserId, required this.username, required this.userItem, required this.recipient});

  final String currentUserId;
  final String username;
  final User userItem;
  final Room recipient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Account Information', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Form(
        child: Container(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                
                AccountInformationLayout(
                  username: userItem.username,
                  email:  userItem.email,
                  fullname: displayFullName(userItem.given_name, userItem.middle_name, userItem.family_name),
                ),
              ]
            )
          )
        )
      )
    );
  }
}