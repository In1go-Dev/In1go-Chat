import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Functions/auth_page_functions.dart';
import 'package:app_1gochat/Providers/homepagesettings.dart';
import 'package:app_1gochat/Screens/Authenticator_Page/Widgets/auth_footer.dart';
import 'package:app_1gochat/Screens/Authenticator_Page/Widgets/auth_label.dart';
import 'package:app_1gochat/Screens/Authenticator_Page/Widgets/auto_registration_step.dart';
import 'package:app_1gochat/Screens/Authenticator_Page/Widgets/basic_registration_step.dart';
import 'package:app_1gochat/Screens/Authenticator_Page/Widgets/confirm_signup_step.dart';
import 'package:app_1gochat/Screens/Authenticator_Page/Widgets/custom_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_intent/receive_intent.dart' as receive;

class CustomAWSAuthenticator extends ConsumerStatefulWidget {
  const CustomAWSAuthenticator({
    super.key,
    this.state,
    this.resetDefaultValue,
    this.intent,
    this.registerEmail,
    this.scaffoldMessengerKey,
    this.setAccountData,
    //this.displayCustomAuthErrorMessage
  });

  final AuthenticatorState? state;
  final receive.Intent? intent;
  final String? registerEmail;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final VoidCallback? resetDefaultValue;
  final Future<void> Function(String?, String?)? setAccountData;
  //final Function(bool isError, String message)? displayCustomAuthErrorMessage;

  @override
  ConsumerState<CustomAWSAuthenticator> createState() => _CustomAWSAuthenticatorState();
}

class _CustomAWSAuthenticatorState extends ConsumerState<CustomAWSAuthenticator> {
  TextEditingController passControl = TextEditingController();
  String passwordKey = "password";
  
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: widget.scaffoldMessengerKey,
      child: Scaffold(
        body: (widget.state != null) ? Center(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
        
                    Visibility(
                      visible: (widget.state!.currentStep == AuthenticatorStep.signUp && widget.intent != null) ? false : true,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 75, bottom: 30),
                        child: Center(
                          child: Image.asset(
                            'assets/images/splash.png',
                            height: 150,
                            width: 150
                          )
                        )
                      )
                    ),
                    //Text(intent.toString()),
  
                    Visibility(
                      visible: (widget.state!.currentStep == AuthenticatorStep.signUp && widget.intent != null) ? false : true,
                      child: AuthLabel(
                        currentState: widget.state!,
                        intent: widget.intent,
                      )
                    ),
                    
                    Container(
                      //constraints: const BoxConstraints(maxWidth: 600),
                      child: setBody(widget.state!)
                    ),
  
                    AuthFooter(
                      registerEmail: widget.registerEmail,
                      intent: widget.intent,
                      currentState: widget.state!,
                      resetDefaultValue: widget.resetDefaultValue
                    )
                  ]
                )
              )
            )
          )
        ) : null
      )
    );
  }

  //Custom Widget Display for Authenticator's Body Layout

  Widget? setBody(AuthenticatorState currentState) {
    switch (currentState.currentStep) {
      case AuthenticatorStep.signIn: 
        return const CustomSignIn();
      case AuthenticatorStep.signUp: 
        return returnRegistrationStep();
      case AuthenticatorStep.confirmSignUp: 
        return returnConfirmationDisplay();
      case AuthenticatorStep.resetPassword: 
        return ResetPasswordForm();
      case AuthenticatorStep.confirmResetPassword: 
        return const ConfirmResetPasswordForm();
      default:
        return null;
    }
  }

  //Amplify Functionality for Account Sign In - Customized for Regular Registration

  Future<void> signinUser({required String username, required String password, required VoidCallback loadingEvent}) async {
    try {
      await Amplify.Auth.signIn(username: username, password: password).then((value) {
        widget.resetDefaultValue!();
      });
    } on AuthException catch (e) {
      loadingEvent();
      if(widget.scaffoldMessengerKey != null && context.mounted) displayCustomAuthErrorMessage(widget.scaffoldMessengerKey!, context, true, e.message);
      safePrint('Error signing in user: ${e.message}');
    }
  }


  //Amplify Functionality for Account Sign In - Customized for Auto Registration

  Future<void> signinUserForAuto({required String email, required String password, required VoidCallback loadingEvent}) async {
    try {
      final signInResult = await Amplify.Auth.signIn(username: email, password: password);
      await _handleSignInResult(email, password, signInResult);
    } on AuthException catch (e) {
      loadingEvent();
      if(widget.scaffoldMessengerKey != null && context.mounted) displayCustomAuthErrorMessage(widget.scaffoldMessengerKey!, context, true, e.message);
      safePrint('Error signing in user: ${e.message}');
    }
  }

  Future<void> _handleSignInResult(String email, String password, SignInResult result) async {
    switch (result.nextStep.signInStep) {
      case AuthSignInStep.confirmSignInWithSmsMfaCode:
        safePrint('Need to SMS Mfa Code to Confirm Sign In');
        break;
      case AuthSignInStep.confirmSignInWithNewPassword:
        safePrint("Enter a new password to continue signing in.");
        displayCustomAuthErrorMessage(widget.scaffoldMessengerKey!, context,
          false, "Enter a new password to continue signing in.");
        break;
      case AuthSignInStep.confirmSignInWithCustomChallenge:
        safePrint("Complete Custom Challenge to continue signing in");
        break;
      case AuthSignInStep.resetPassword:
        displayCustomAuthErrorMessage(widget.scaffoldMessengerKey!, context,
          false, "Please reset your password to sign in.");
        break;
      case AuthSignInStep.confirmSignUp:
        final resendResult = await Amplify.Auth.resendSignUpCode(username: email);
        if(widget.scaffoldMessengerKey != null && context.mounted) {
          displayCustomAuthErrorMessage(widget.scaffoldMessengerKey!, context,
            false, "A confirmation code has been sent to ${resendResult.codeDeliveryDetails.destination}."
          );
        }
        await widget.setAccountData!(email, password);
        widget.state!.changeStep(AuthenticatorStep.confirmSignUp);
        break;
      case AuthSignInStep.done:
        if(widget.resetDefaultValue != null) widget.resetDefaultValue!();
        safePrint('Sign in is complete');
        break;
      case AuthSignInStep.continueSignInWithMfaSelection:
        safePrint('Need MFA Selection to continue signing in');
        break;
      case AuthSignInStep.continueSignInWithTotpSetup:
        safePrint('Need Totp Setup to continue signing in');
        break;
      case AuthSignInStep.confirmSignInWithTotpMfaCode:
        safePrint('Need Totp Setup to confirm signing in');
        break;
    }
  }

  //Amplify Functionality for Account Sign Up - Used in Regular Registration

  Future<void> signupUser({required String username, required String password, required String preferredUsername,
    required String fname, required String mname, required String lname, required VoidCallback loadingEvent}) async {
    try{
      final registerResult = await Amplify.Auth.signUp(
        username: username,
        password: password,
        options: SignUpOptions(
          userAttributes: {
            AuthUserAttributeKey.preferredUsername: preferredUsername,
            AuthUserAttributeKey.givenName: fname,
            AuthUserAttributeKey.middleName: mname,
            AuthUserAttributeKey.familyName: lname,
          }
        )
      );
      await _handleSignUpResult(registerResult, username, password, loadingEvent);
    } on AuthException catch (e) {
      loadingEvent();
      if(widget.scaffoldMessengerKey != null && context.mounted) displayCustomAuthErrorMessage(widget.scaffoldMessengerKey!, context, true, e.message);
      safePrint('Error signing up user: ${e.message}');
    }
  }


  //Amplify Functionality for Registered Account Confirmation - Used for Regular Registration

  Future<void> confirmUser({required String username, required String confirmationCode, required VoidCallback loadingEvent}) async {
    try {
      final storage = ref.read(secureStorage);
      final result = await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: confirmationCode
      );
      final storedPassword = await storage.read(key: passwordKey);
      // Check if further confirmations are needed or if
      // the sign up is complete.
      if(widget.state != null) {
         await _handleSignUpResult(result, widget.registerEmail, storedPassword, loadingEvent);
      }
    } on AuthException catch (e) {
      loadingEvent();
      if(widget.scaffoldMessengerKey != null && context.mounted) displayCustomAuthErrorMessage(widget.scaffoldMessengerKey!, context, true, e.message);
      safePrint('Error confirming user: ${e.message}');
    }
  }


  //Amplify Functionality for Registered Account Confirmation - Used for Auto-Registration

  Future<void> confirmUserForAuto({required String username, required String password, required String confirmationCode, required VoidCallback loadingEvent}) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: confirmationCode
      );
      // Check if further confirmations are needed or if
      // the sign up is complete.
      if(widget.state != null) {
         await _handleSignUpResult(result, username, password, loadingEvent);
      }
    } on AuthException catch (e) {
      loadingEvent();
      if(widget.scaffoldMessengerKey != null && context.mounted) displayCustomAuthErrorMessage(widget.scaffoldMessengerKey!, context, true, e.message);
      safePrint('Error confirming user: ${e.message}');
    }
  }

  Future<void> _handleSignUpResult(SignUpResult result, String? email, String? password, VoidCallback loadingEvent) async {
    switch (result.nextStep.signUpStep) {
      case AuthSignUpStep.confirmSignUp:
        if(widget.scaffoldMessengerKey != null && context.mounted) {
          displayCustomAuthErrorMessage(
            widget.scaffoldMessengerKey!,
            context,
            false,
            "A confirmation code has been sent to ${result.nextStep.codeDeliveryDetails?.destination}."
          );
        }
        await widget.setAccountData!(email, password);
        widget.state!.changeStep(AuthenticatorStep.confirmSignUp);
        break;
      case AuthSignUpStep.done:
        if(password != null && password.isNotEmpty) {
          signinUser(
            username: email!,
            password: password,
            loadingEvent: loadingEvent
          );
        }

        else{
          widget.state!.changeStep(AuthenticatorStep.signIn);
          widget.resetDefaultValue!();
        }

        safePrint('Sign up is complete');
        break;
    }
  }

  //Retrives Authenticator's Registration Step Display depending on the Intent Content (Auto-Registration Display if Intent contains values)

  Widget returnRegistrationStep() {
    if(widget.intent != null && widget.scaffoldMessengerKey != null) {
      return AutoRegistrationStep(
        authState: widget.state,
        intent: widget.intent!,
        scaffoldMessengerKey: widget.scaffoldMessengerKey!,
        exitRegistration:  () {
          widget.resetDefaultValue!();
          widget.state!.changeStep(AuthenticatorStep.signIn);
        },
        resetDefaultValue: widget.resetDefaultValue,
        signinUserForAuto: signinUserForAuto,
        confirmationFunction: confirmUserForAuto,
        displayCustomAuthErrorMessage: displayCustomAuthErrorMessage,
      );
    }

    else {
      final intentMap = widget.intent?.extra;
      return AWSRegisterStep(
        authState: widget.state,
        defaultEmail: (widget.intent != null && intentMap != null && intentMap.containsKey("email")) ? intentMap["email"].toString() : '',
        defaultFName: (widget.intent != null && intentMap != null && intentMap.containsKey("fname")) ? intentMap["fname"].toString() : '',
        defaultMName: (widget.intent != null && intentMap != null && intentMap.containsKey("mname")) ? intentMap["mname"].toString() : '',
        defaultLName: (widget.intent != null && intentMap != null && intentMap.containsKey("lname")) ? intentMap["lname"].toString() : '',
        signUpFunction: signupUser
      );
    }
  }

  //Retrives Authenticator's Confirmation Step Display depending on the Intent Content (Auto-Registration's Confirmation Display if Intent contains values)

  Widget returnConfirmationDisplay() {
    if(widget.intent?.extra != null || (widget.registerEmail != null && widget.registerEmail!.isNotEmpty)) {
      return AWSConfirmSignUpStep(
        scaffoldMessengerKey: widget.scaffoldMessengerKey,
        defaultEmail: widget.registerEmail!,
        displayAuthMessage: displayCustomAuthErrorMessage,
        confirmationFunction: confirmUser
      );
    }

    else {
      return ConfirmSignUpForm();
    }
  }

  @override
  void dispose() {
    passControl.dispose();
    super.dispose();
  }
}