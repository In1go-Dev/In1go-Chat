import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Functions/auth_page_functions.dart';
import 'package:app_1gochat/Screens/Authenticator_Page/Widgets/auto_registration_result.dart';
import 'package:app_1gochat/Screens/Authenticator_Page/Widgets/failed_auto_registration.dart';
import 'package:flutter/material.dart';
import 'package:receive_intent/receive_intent.dart' as receive;

class AutoRegistrationStep extends StatelessWidget {
  const AutoRegistrationStep({
    super.key, 
    required this.authState, 
    required this.intent, 
    required this.scaffoldMessengerKey, 
    required this.exitRegistration, 
    required this.resetDefaultValue, 
    required this.signinUserForAuto,
    required this.confirmationFunction, 
    required this.displayCustomAuthErrorMessage
  });

  final AuthenticatorState? authState;
  final receive.Intent intent;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final VoidCallback exitRegistration;
  final VoidCallback? resetDefaultValue;
  final Future<void> Function({required String email, required String password, required VoidCallback loadingEvent}) signinUserForAuto;
  final Future<void> Function({required String username, required String password, required String confirmationCode, required VoidCallback loadingEvent}) confirmationFunction;
  final void Function(GlobalKey<ScaffoldMessengerState>, BuildContext, bool, String) displayCustomAuthErrorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: autoRegistrationForIntent(intent: intent),
        builder:(context, result) {
          if(result.connectionState == ConnectionState.done && result.hasData && result.data!.isNotEmpty) {
            String autoRegistrationState = result.data!;
  
            if(autoRegistrationState == "Successfully Registered - Confirmation" || autoRegistrationState == "Successfully Registered - Done" ||
              autoRegistrationState == "Already Registered") {
  
              final intentMap = intent.extra!;
              List<MapEntry<String, String>> userData = {
                "Email": intentMap["email"].toString(),
                "UserName": '${intentMap["fname"].toString()} ${intentMap["lname"].toString()}',//intentMap["username"].toString(),
                "Full Name": displayFullName(
                  intentMap["fname"].toString(),
                  intentMap["mname"].toString(),
                  intentMap["lname"].toString()
                ),
                "Password": getIntentPassword(intentMap)
              }.entries.toList();
  
              return AutoRegistrationLayout(
                scaffoldMessengerKey: scaffoldMessengerKey,
                userData: userData,
                changeState: () {
                  if(authState != null) authState!.changeStep(AuthenticatorStep.signIn);
                },
                autoRegisterResult: autoRegistrationState,
                exitRegistration: exitRegistration,
                resetDefaultValue: resetDefaultValue,
                signinUserForAuto: signinUserForAuto,
                confirmationFunction: confirmationFunction,
                displayCustomAuthErrorMessage: displayCustomAuthErrorMessage,
              );
            }
  
            else {
              return FailedAutoRegistrationStep(
                errorMessage: autoRegistrationState,
                changeState: exitRegistration
              );
            }
          }
  
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }

  Future<String?> autoRegistrationForIntent({required receive.Intent intent}) async {
    try{
      final intentMap = intent.extra;
      final intentEmail = (intentMap != null && intentMap.containsKey("email")) ? intentMap["email"].toString().toLowerCase().trim() : '';
      final intentPassword = getIntentPassword(intentMap);
      final intentUser = getIntentUsername(intentMap);
      final intentFName = (intentMap != null && intentMap.containsKey("fname")) ? intentMap["fname"].toString().trim() : '';
      final intentMName = (intentMap != null && intentMap.containsKey("mname")) ? intentMap["mname"].toString().trim() : '';
      final intentLName = (intentMap != null && intentMap.containsKey("lname")) ? intentMap["lname"].toString().trim() : '';


      //Checks if the Intent values exists before implementing auto-registration
      if(intentEmail.isNotEmpty && intentPassword.isNotEmpty && intentUser.isNotEmpty && intentFName.isNotEmpty && intentLName.isNotEmpty) {

        //Validates the content and format of the Intent values before implementing auto-registration
        if(validateIntentAccountInformation(intentEmail, intentPassword, intentUser, intentFName, intentLName) == false) return "Invalid Account Information";

        safePrint("Amplify Registration Passed Here");

        //Amplify Functionality for Account Sign Up
        final registerResult = await Amplify.Auth.signUp(
          username: intentEmail,
          password: intentPassword,
          options: SignUpOptions(
            userAttributes: {
              AuthUserAttributeKey.preferredUsername: intentUser,
              AuthUserAttributeKey.givenName: intentFName,
              AuthUserAttributeKey.middleName: intentMName,
              AuthUserAttributeKey.familyName: intentLName,
            }
          )
        );

        //If Registration is successful, check if the account is confirmed or not
        switch (registerResult.nextStep.signUpStep) {
          case AuthSignUpStep.confirmSignUp:
          return "Successfully Registered - Confirmation";
          case AuthSignUpStep.done:
          return "Successfully Registered - Done";
        }
      }

      else {
        return "Incomplete Account Information";
      }
    } on AuthException catch (e) {
      if(e.message == "An account with the given email already exists.") {
        return "Already Registered";
      }
      safePrint('Error signing up user: ${e.message}');
      if(e.recoverySuggestion != null && e.recoverySuggestion!.isNotEmpty) {   //Returns a formatted error message based on the Exception's message and recovery suggesstion
        String message = (e.message.endsWith(".")) ? e.message : "${e.message}.";
        String recovery = (e.recoverySuggestion!.endsWith(".")) ? e.recoverySuggestion! : "${e.recoverySuggestion}.";
        return "$message $recovery";
      }
      else {
        return e.message;
      }
    }
  }

  //Retrieves the Username based from the Intent's Given and Family Name values

  String getIntentUsername(Map<String, dynamic>? intentMap) {
    if(intentMap != null && intentMap.containsKey("fname") && intentMap.containsKey("lname")) {
      final fname = intentMap["fname"].toString().trim().toLowerCase();
      final lname = intentMap["lname"].toString().trim().toLowerCase();
      if(fname.isNotEmpty && lname.isNotEmpty) {
        return "${intentMap["fname"].toString()} ${intentMap["lname"].toString()}";
      }
      return '';
    }
    return '';
  }

  //Retrieves the Password Value from the Intent

  String getIntentPassword(Map<String, dynamic>? intentMap) {
    if(intentMap != null && intentMap.containsKey("fname") && intentMap.containsKey("lname")) {
      final fname = intentMap["fname"].toString().trim().toLowerCase();
      final lname = intentMap["lname"].toString().trim().toLowerCase();
      if(fname.isNotEmpty && lname.isNotEmpty) {
        return "${fname[0]}${lname[0]}NAI123!";
      }
      return '';
    }
    return '';
  }

  //Validates if the following values from Intent exists or not

  bool validateIntentAccountInformation(String email, String password, String userName, String firstName, String familyName) {
    final emailResult = validateEmail("Email", email);
    final passwordResult = validatePassword("Password", password);
    final userResult = validateUser("Preferred Username", userName);
    final firstResult = validateUser("Given Name", firstName);
    final familyResult = validateUser("Family Name", familyName);

    if(emailResult != null || passwordResult != null || userResult != null || firstResult != null || familyResult != null) {
      return false;
    }

    else {
      return true;
    }
  }
}