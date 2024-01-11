import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:app_1gochat/Providers/homepagesettings.dart';
import 'package:app_1gochat/Screens/Authenticator_Page/auth_page.dart';
import 'package:app_1gochat/Screens/General/Widgets/custom_material_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_intent/receive_intent.dart' as receive;

//Retrieves and formats the Recovery Message in the Exception if there are any.

String? getRecoveryMessage(String? recovery) {
  if(recovery != null && recovery.isNotEmpty) {
    return (recovery.endsWith(".")) ? recovery : "$recovery.";
  }

  else {
    return null;
  }
} 

//Display Material Banners - e.g. Amplify Authetication Error Messages like wrong passwords

void displayCustomAuthErrorMessage(GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey, BuildContext context, bool isError, String message) {
  final scaffoldMessengerState = scaffoldMessengerKey.currentState;
  if(scaffoldMessengerState != null && context.mounted) {
    scaffoldMessengerState
      ..clearMaterialBanners()
      ..showMaterialBanner(CustomMaterialBannerMessenger(
        message: message,
        isError: isError,
        themeDisplay: Theme.of(context), 
        dismissMessenger: scaffoldMessengerState.clearMaterialBanners,
      )
    );
  }
}

//Functionality for the Authentication Sign In Display depending on the Intent content

Widget? checkDefaultStep(receive.Intent? defaultInput, AuthenticatorState state){
  if(defaultInput?.extra != null && state.currentStep == AuthenticatorStep.signIn) {   
    state.changeStep(AuthenticatorStep.signUp);
    return const SizedBox();      //Returns a blank SizedBox widget as a placeholder display while Authenticator navigates to Auto-Registration
  }
  return CustomAWSAuthenticator(state: state);      //If the Chat App has no Intent, displays the regular Sign In display by default
}

//Create a Full Name String with or without a middle name depending on the parameters

String displayFullName(String fname, String? mname, String lname) {
  if(mname != null && mname.isNotEmpty) {
    return "$fname $mname $lname";
  }
  return "$fname $lname";
}

//Writes the password content in the app's secure storage during authentication - e.g. Registration to Confirmation for Auto-Sign In

void writePassword(WidgetRef ref, String? password) async {
  String passwordKey = "password";
  final storage = ref.read(secureStorage);
  if(password != null && password.isNotEmpty) {
    await storage.write(key: passwordKey, value: password);
  }
}

//Clears the password content if the user navigates to a Different Authetication step

void clearPassword(WidgetRef ref) async {
  String passwordKey = "password";
  final storage = ref.read(secureStorage);
  if (await storage.containsKey(key: passwordKey)) {
    // Delete the stored password from FlutterSecureStorage
    await storage.delete(key: passwordKey);
  }
}

//Clears the Material Banners (e.g. Auth Error Messages) when called

void clearMaterialBanners(GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey) {
  if(scaffoldMessengerKey != null) {
    final scaffoldMessengerState = scaffoldMessengerKey.currentState;
    if(scaffoldMessengerState != null) scaffoldMessengerState.clearMaterialBanners();
  }
}

//Validation conditions for User Information (Username, Given Name, Middle Name, Family Name)

String? validateUser(String fieldName, String? input) {
  if(fieldName != 'Middle Name') {
    if(input == null || input.trim().isEmpty) {
      return '$fieldName field must not be blank.';
    }
    else if(!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(input.substring(0, 2))) {
      return '$fieldName must not start with special characters';
    }
    return null;
  }
  return null;
}

//Validation Condition for Email Address

String? validateEmail(String fieldName, String? input) {
  if(input == null || input.isEmpty) {
    return '$fieldName field must not be blank.';
  }
  else if(!RegExp(r"^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$").hasMatch(input)){
    return 'Invalid Email Format';
  }
  else if(!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(input.trim().substring(0, 2))) {
    return '$fieldName must not start with special characters';
  }
  return null;
}

//Validation Condition for Account Password

String? validatePassword(String fieldName, String? input) {
  if((input == null || input.isEmpty)){
    return '$fieldName field must not be blank.';
  }
  else if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(input)) {
    return 'Password must include:'
    '\n*at least 8 characters'
    '\n*at least 1 number character'
    '\n*at least 1 special character'
    '\n*at least 1 uppercase character';
  }
  return null;
}

  //void displayCustomAuthErrorMessage(bool isError, String message) {
  //  final scaffoldMessengerState = scaffoldMessengerKey.currentState;
  //  if(scaffoldMessengerState != null && context.mounted) {
  //    scaffoldMessengerState
  //      ..clearMaterialBanners()
  //      ..showMaterialBanner(CustomMaterialBannerMessenger(
  //        message: message,
  //        isError: isError,
  //        themeDisplay: Theme.of(context), 
  //        dismissMessenger: scaffoldMessengerState.clearMaterialBanners,
  //      )
  //    );
  //  }
  //}
