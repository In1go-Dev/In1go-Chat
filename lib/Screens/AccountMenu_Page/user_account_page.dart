import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Screens/AccountMenu_Page/Widgets/account_body.dart';
import 'package:app_1gochat/Screens/EditAccount_Page/edit_account_page.dart';
import 'package:app_1gochat/Screens/EditPassword_Page/edit_password_page.dart';
import 'package:app_1gochat/Screens/General/Widgets/custom_alertdialog.dart';
import 'package:app_1gochat/Screens/General/chatapp.dart';
import 'package:flutter/material.dart';

//Widget setup for the Signed In User's Account Page

class AccountDisplayPage extends StatefulWidget {
  const AccountDisplayPage({super.key, required this.currUser, required this.userState});

  final List<AuthUserAttribute> currUser;
  final bool userState;

  @override
  State<AccountDisplayPage> createState() => _AccountDisplayPageState();
}

class _AccountDisplayPageState extends State<AccountDisplayPage> {
  
  void navigateChoices(List<AuthUserAttribute> currUser, int choice) {
    switch (choice) {
      case 0:   //Page Navigation towards Edit Account Page
        if(context.mounted) {
          Navigator.push(context, MaterialPageRoute<void>(
            builder: (BuildContext context) => EditAccountPage(currUser: currUser)
          ));
        }
        break;

      case 1:  //Page Navigation towards Edit Password Page
        if(context.mounted) {
          Navigator.push(context, MaterialPageRoute<void>(
            builder: (BuildContext context) => EditPasswordPage(currUser: currUser)
          ));
        }
        break;
      case 2:  //Functionality for Signing Out Current User with a confirmation dialog
        if(context.mounted) {
          double width = MediaQuery.of(context).size.width;

          showDialog<bool>(context: context, builder: (dialogContext) => AlertDialogLayout(
            width: width,
            titleName: 'Confirm Signout',
            appContext: context,
            widget: const ConfirmationAlert(
              message:  'Are you sure you want to sign out?'
            )
          )).then((value) {

            //Necessary for callbacks such as Confirm (true) and Cancel (false or null)
            if(value == true) signOutCurrentUser();
          });
        }
        break;
    }
  }

  //Functionality for User Sign Out
  
  Future<void> signOutCurrentUser() async {
    final result = await Amplify.Auth.signOut();
    if (result is CognitoCompleteSignOut) {
      if(mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const ChatApp()),
          (Route<dynamic> route) => false
        );
      }
      safePrint('Sign out completed successfully');
    } else if (result is CognitoFailedSignOut) {
      safePrint('Error signing user out: ${result.exception.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AccountPageScreen(
      currUser: widget.currUser,
      userState: widget.userState,
      navigateChoices: navigateChoices,
    );
  }
}