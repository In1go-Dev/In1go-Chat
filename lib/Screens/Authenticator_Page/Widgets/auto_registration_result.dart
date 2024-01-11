import 'package:app_1gochat/Screens/Authenticator_Page/Widgets/auto_registration_input.dart';
import 'package:flutter/material.dart';

class AutoRegistrationLayout extends StatefulWidget {
  const AutoRegistrationLayout({
    super.key, 
    required this.scaffoldMessengerKey, 
    required this.changeState,
    required this.userData, 
    required this.autoRegisterResult, 
    required this.exitRegistration,
    required this.resetDefaultValue, 
    required this.signinUserForAuto, 
    required this.confirmationFunction, 
    required this.displayCustomAuthErrorMessage});

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final VoidCallback changeState;
  final List<MapEntry<String, String>> userData;
  final String autoRegisterResult;
  final VoidCallback exitRegistration;
  final VoidCallback? resetDefaultValue;
  final Future<void> Function({required String email, required String password, required VoidCallback loadingEvent}) signinUserForAuto;
  final Future<void> Function({required String username, required String password, required String confirmationCode, required VoidCallback loadingEvent}) confirmationFunction;
  final void Function(GlobalKey<ScaffoldMessengerState>, BuildContext, bool, String) displayCustomAuthErrorMessage;

  @override
  State<AutoRegistrationLayout> createState() => _AutoRegistrationLayoutState();
}

class _AutoRegistrationLayoutState extends State<AutoRegistrationLayout> {
  TextEditingController autoRegistrationConfirmControl = TextEditingController();
  TextEditingController autoRegistrationPassControl = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Center(
              child: CircleAvatar(
                minRadius: 30,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  widget.userData[1].value.substring(0, 2),
                  style: const TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              )
            )
          ),

          Container(
            margin: const EdgeInsets.only(bottom: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.userData[1].value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.userData[0].value,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            )
          ),
          
          autoRegisterStatus(),
          
          AutoRegistrationInput(
            autoRegistrationState: widget.autoRegisterResult,
            intentEmail: widget.userData[0].value,
            intentPassword: widget.userData[3].value,
            autoRegistrationPassControl: autoRegistrationPassControl,
            autoRegistrationConfirmControl: autoRegistrationConfirmControl,
            scaffoldMessengerKey: widget.scaffoldMessengerKey,
            resetDefaultValue: widget.resetDefaultValue,
            displayAuthMessage: widget.displayCustomAuthErrorMessage,
            signinUserForAuto: widget.signinUserForAuto,
            confirmationFunction: widget.confirmationFunction,
          ),
          
          TextButton(
            onPressed: widget.exitRegistration,
            child: const Text('Back to Sign In')
          )
        ]
      )
    );
  }

  Widget autoRegisterStatus() {
    bool isSuccess = (widget.autoRegisterResult != "Already Registered") ? true : false;
    return Visibility(
      visible: isSuccess,
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Successfully Registered",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500
              )
            ),
    
            Container(
              margin: const EdgeInsets.only(left: 5, bottom: 0),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle
              ),
              child: const Padding(
                padding: EdgeInsets.all(3),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                )
              )
            )
          ]
        )
      )
    );
  }

  Widget autoRegisterResultButton() {
    bool isSuccess = (widget.autoRegisterResult != "Already Registered") ? true : false;
    switch (isSuccess) {
      case true:
      return Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: ElevatedButton(   //Change to Loading Button
          onPressed: () {},
          child: const Text('Confirm Account')
        )
      );

      case false:
      return Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: ElevatedButton(   //Change to Loading Button
          onPressed: () {},
          child: const Text('Continue to this Account')
        )
      );
    }
  }
}