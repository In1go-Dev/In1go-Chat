import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:receive_intent/receive_intent.dart' as receive;

class AuthLabel extends StatelessWidget {
  const AuthLabel({super.key, required this.currentState, this.intent});
  
  final AuthenticatorState currentState;
  final receive.Intent? intent;

  @override
  Widget build(BuildContext context) {
    switch (currentState.currentStep) {
      case AuthenticatorStep.signIn:
        return const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
          child: Text('Sign In', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        );
      case AuthenticatorStep.signUp:
        if(intent == null) {
           return const Padding(
             padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
             child: Text('Sign Up', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
           );
        }
        return const SizedBox();
      default:
      return const SizedBox();
    }
  }
}