import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';

//Widget Display for the Custom Sign In for Amplify Authenticator (utilized to implement custom validation conditions)

class CustomSignIn extends StatelessWidget {
  const CustomSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInForm.custom(
      fields: [
        SignInFormField.username(
          validator: validateEmail
        ),

        SignInFormField.password()
      ]
    );
  }

  //Custom Validation Conditions for Email Address Input in the Authenticator Sign In 

  String? validateEmail(UsernameInput? input) {
    if(input != null && input.username.isNotEmpty) {
      final email = input.username.trim();

      if(!RegExp(r"^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]+$").hasMatch(email)) {
        return 'Invalid Email Format';
      }

      else if(!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(email.trim().substring(0, 2))) {
        return 'Email must not start with special characters';
      }

      return null;
    }

    return 'Email field must not be blank.';
  }
}