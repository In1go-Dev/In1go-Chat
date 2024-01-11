import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Screens/General/Widgets/custom_textformfield.dart';
import 'package:app_1gochat/Screens/General/Widgets/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AutoRegistrationInput extends StatefulWidget {
  const AutoRegistrationInput({
    super.key, 
    required this.autoRegistrationState, 
    required this.intentEmail, 
    required this.intentPassword,
    required this.autoRegistrationConfirmControl, 
    required this.autoRegistrationPassControl, 
    required this.scaffoldMessengerKey,
    required this.resetDefaultValue, 
    required this.displayAuthMessage, 
    required this.signinUserForAuto,
    required this.confirmationFunction});

  final String autoRegistrationState;
  final String intentEmail;
  final String intentPassword;
  final TextEditingController autoRegistrationConfirmControl;
  final TextEditingController autoRegistrationPassControl;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final VoidCallback? resetDefaultValue;
  final void Function(GlobalKey<ScaffoldMessengerState>, BuildContext, bool, String) displayAuthMessage;
  final Future<void> Function({required String email, required String password, required VoidCallback loadingEvent}) signinUserForAuto;
  final Future<void> Function({required String username, required String password, required String confirmationCode, required VoidCallback loadingEvent}) confirmationFunction;

  @override
  State<AutoRegistrationInput> createState() => _AutoRegistrationInputState();
}

class _AutoRegistrationInputState extends State<AutoRegistrationInput> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final int maxCodesize = 6;
  bool passState = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: displayWidget(),
      )
    );
  }

  Widget displayWidget() {
    switch (widget.autoRegistrationState) {
      case "Successfully Registered - Confirmation":
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            CustomTextField(
              control: widget.autoRegistrationConfirmControl,
              keyboard: TextInputType.number,
              obscureState: false,
              isReadOnly: false,
              maxInput: [LengthLimitingTextInputFormatter(maxCodesize)],
              labelTxt: 'Verification Code',
              hintTxt: 'Enter your verification code',
              counterDisplay: '${widget.autoRegistrationConfirmControl.text.length.toString()}/6',
              changeEvent: (value) => setState(() {}),
              validateInput: validateVerification
            ),
    
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Lost your code?'),
                TextButton(
                  onPressed: () => resendConfirmCode(widget.intentEmail),
                  child: const Text('Send Code')
                )
              ]
            ),
  
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: LoadingButton(
                label: 'Confirm Account',
                formKey: formKey,
                width: MediaQuery.of(context).size.width,
                authEvent: (event) {
                  FocusScope.of(context).unfocus();
                  widget.confirmationFunction(
                    confirmationCode: widget.autoRegistrationConfirmControl.text,
                    username: widget.intentEmail,
                    password: widget.intentPassword,
                    loadingEvent: event
                  );
                }
              )
            )
          ]
        );
      case "Successfully Registered - Done":
        return LoadingButton(
          label: 'Continue to Account',
          formKey: formKey,
          width: MediaQuery.of(context).size.width,
          authEvent: (event) {
            FocusScope.of(context).unfocus();
            widget.signinUserForAuto(
              email: widget.intentEmail,
              password: widget.intentPassword,
              loadingEvent: event,
            );
            //signinUser(
            //  username: widget.intentEmail,
            //  password: widget.intentPassword,
            //  loadingEvent: event
            //);
          }
        );
      case "Already Registered":
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: CustomTextField(
                control: widget.autoRegistrationPassControl,
                labelTxt: 'Password',
                hintTxt: 'Enter your password',
                obscureState: passState,
                suffixPic: Icon((passState == true) ? Icons.visibility : Icons.visibility_off),
                suffixEvent: () => setState(() =>  passState = !passState),
                validateInput: validatePassword
              ),
            ),
            
            LoadingButton(
              label: 'Continue to this Account',
              formKey: formKey,
              width: MediaQuery.of(context).size.width,
              authEvent: (event) {
                FocusScope.of(context).unfocus();
                widget.signinUserForAuto(
                  email: widget.intentEmail,
                  password: widget.intentPassword,
                  loadingEvent: event,
                );
              }
            )
          ]
        );
      default:
        return const SizedBox();
    }
  }

  //Amplify Functionality for Sign In

  Future<void> signinUser({required String username, required String password, required VoidCallback loadingEvent}) async {
    try {
      await Amplify.Auth.signIn(username: username, password: password).then((value) {
        widget.resetDefaultValue!();
      });
    } on AuthException catch (e) {
      loadingEvent();
      if(context.mounted) widget.displayAuthMessage(widget.scaffoldMessengerKey, context, true, e.message);
      safePrint('Error signing in user: ${e.message}');
    }
  }

  //Validation Condition for Password Input

  String? validatePassword(String fieldName, String? input) {
    if(input == null || input.isEmpty) {
      return 'Please enter your password.';
    }
    return null;
  }

  //Validation Condition for Amplify Verification Code

  String? validateVerification(String fieldName, String? input) {
    if(input == null || input.isEmpty) {
      return '$fieldName field must not be blank.';
    }
    else if(widget.autoRegistrationConfirmControl.text.length < maxCodesize || !RegExp(r"^[0-9]+$").hasMatch(input)){
      return 'Invalid verification code format';
    }
    return null;
  }

  //Amplify Functionality for Resending Verification Code

  Future<void> resendConfirmCode(String username) async {
    try{
      final result = await Amplify.Auth.resendSignUpCode(username: username);
      if(context.mounted) {
        widget.displayAuthMessage(widget.scaffoldMessengerKey, context, false, result.codeDeliveryDetails.toString());
      }
    } on AuthException catch(e) {
      if(context.mounted) {
        widget.displayAuthMessage(widget.scaffoldMessengerKey, context, true, e.message);
      }
    }
  }
}