import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:receive_intent/receive_intent.dart' as receive;

class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key, this.registerEmail, required this.intent, required this.currentState, required this.resetDefaultValue});

  final String? registerEmail;
  final receive.Intent? intent;
  final AuthenticatorState currentState;
  final VoidCallback? resetDefaultValue;

  @override
  Widget build(BuildContext context) {
    switch(currentState.currentStep) {
      case AuthenticatorStep.signIn:
      return Container(
        margin: const EdgeInsets.only(bottom: 75),
        padding: const EdgeInsets.only(top: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Don\'t have an account?'),
            TextButton(
              onPressed: () => currentState.changeStep(AuthenticatorStep.signUp),
              child: const Text('Sign Up')
            )
          ]
        )
      );
      case AuthenticatorStep.signUp:
      if(intent == null) {
        return Container(
          margin: const EdgeInsets.only(bottom: 75),
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account?'),
              TextButton(
                onPressed: () {
                  resetDefaultValue!();
                  currentState.changeStep(AuthenticatorStep.signIn);
                },
                child: const Text('Sign In')
              )
            ]
          )
        );
      }
      return const SizedBox();
      case AuthenticatorStep.confirmSignUp:
      return (intent != null || (registerEmail != null && registerEmail!.isNotEmpty)) ? Container(
        padding: const EdgeInsets.only(top: 10),
        margin: const EdgeInsets.only(bottom: 75),
        child: Center(
          child: TextButton(
            onPressed: () {
              resetDefaultValue!();
              currentState.changeStep(AuthenticatorStep.signIn);
            },
            child: const Text('Back to Sign In')
          )
        )
      ) : const SizedBox();
      default:
      return const SizedBox();
    }
  }
}