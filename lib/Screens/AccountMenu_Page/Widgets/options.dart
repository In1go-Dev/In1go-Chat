import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Screens/AccountMenu_Page/Widgets/option_buttons.dart';
import 'package:flutter/material.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key, required this.currUser, required this.navigateChoices});

  final List<AuthUserAttribute> currUser;
  final void Function(List<AuthUserAttribute>, int) navigateChoices;
  
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 5, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
            ),

            OptionButtons(
              functions: () => navigateChoices(currUser, 0),
              optionIcon: Icons.account_circle,
              label: 'Change User Information'
            ),

            OptionButtons(
              functions: () => navigateChoices(currUser, 1),
              optionIcon: Icons.lock,
              label: 'Change Password'
            ),

            OptionButtons(
              functions: () => navigateChoices(currUser, 2),
              optionIcon: Icons.switch_account_rounded,
              label: 'Switch Account'
            )
          ]
        )
      )
    );
  }
}