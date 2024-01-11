import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Screens/General/Widgets/custom_textformfield.dart';
import 'package:app_1gochat/Screens/General/Widgets/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AWSConfirmSignUpStep extends StatefulWidget {
  const AWSConfirmSignUpStep({super.key, required this.scaffoldMessengerKey, required this.confirmationFunction, required this.defaultEmail, required this.displayAuthMessage});
  
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final String defaultEmail;
  final void Function(GlobalKey<ScaffoldMessengerState>, BuildContext, bool, String)? displayAuthMessage;
  final Future<void> Function({required String username, required String confirmationCode, required VoidCallback loadingEvent}) confirmationFunction;

  @override
  State<AWSConfirmSignUpStep> createState() => _AWSConfirmSignUpStepState();
}

class _AWSConfirmSignUpStepState extends State<AWSConfirmSignUpStep> {
  final TextEditingController codeControl = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final int maxCodesize = 6;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              initialValue: widget.defaultEmail,
              enabled: false,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Email')
            )
          ),

          CustomTextField(
            control: codeControl,
            keyboard: TextInputType.number,
            obscureState: false,
            isReadOnly: false,
            maxInput: [LengthLimitingTextInputFormatter(maxCodesize)],
            labelTxt: 'Verification Code',
            hintTxt: 'Enter your verification code',
            counterDisplay: '${codeControl.text.length.toString()}/6',
            changeEvent: (value) => setState(() {}),
            validateInput: validateVerification
          ),
  
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lost your code?'),
              TextButton(
                onPressed: () => resendConfirmCode(widget.defaultEmail),
                child: const Text('Send Code')
              )
            ]
          ),

          LoadingButton(
            label: 'Confirm',
            formKey: formKey,
            width: MediaQuery.of(context).size.width,
            authEvent: (event) {
              FocusScope.of(context).unfocus();
              widget.confirmationFunction(
                confirmationCode: codeControl.text.trim(),
                username: widget.defaultEmail,
                loadingEvent: event
              );
            }
          )
        ]
      )
    );
  }

  @override
  void dispose(){
    codeControl.dispose();
    super.dispose();
  }


  //Validation Condition for Verification Code

  String? validateVerification(String fieldName, String? input) {
    if(input == null || input.isEmpty) {
      return '$fieldName field must not be blank.';
    }
    else if(codeControl.text.length < maxCodesize || !RegExp(r"^[0-9]+$").hasMatch(input)){
      return 'Invalid verification code format';
    }
    return null;
  }

  //Amplify Functionality for Resending Verification Code

  Future<void> resendConfirmCode(String username) async {
    try{
      final result = await Amplify.Auth.resendSignUpCode(username: username);
      if(widget.displayAuthMessage != null && widget.scaffoldMessengerKey != null && context.mounted) {
        widget.displayAuthMessage!(widget.scaffoldMessengerKey!, context, false, "A confirmation code was sent to ${result.codeDeliveryDetails.destination}");
      }
    } on AuthException catch(e) {
      if(widget.displayAuthMessage != null && widget.scaffoldMessengerKey != null && context.mounted) {
        widget.displayAuthMessage!(widget.scaffoldMessengerKey!, context, true, e.message);
      }
    }
  }
}