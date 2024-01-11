import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Functions/auth_page_functions.dart';
import 'package:app_1gochat/Functions/home_page_functions.dart';
import 'package:app_1gochat/Screens/AccountMenu_Page/Widgets/account_info.dart';
import 'package:app_1gochat/Screens/AccountMenu_Page/Widgets/options.dart';
import 'package:flutter/material.dart';

class AccountPageScreen extends StatelessWidget {
  const AccountPageScreen({super.key, required this.currUser, required this.userState, required this.navigateChoices});

  final List<AuthUserAttribute> currUser;
  final bool userState;
  final void Function(List<AuthUserAttribute>, int) navigateChoices;

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
                  username: currUser[2].value,
                  email: checkIfMNameisEmpty(currUser, 6),
                  fullname: displayFullName(currUser[3].value, getMiddleName(currUser), checkIfMNameisEmpty(currUser, 5)),
                ),

                Visibility(
                  visible: userState,
                  child: AccountSettings(
                    currUser: currUser,
                    navigateChoices: navigateChoices,
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}