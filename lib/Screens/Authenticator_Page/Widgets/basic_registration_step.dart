import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:app_1gochat/Functions/auth_page_functions.dart';
import 'package:app_1gochat/Screens/General/Widgets/custom_textformfield.dart';
import 'package:app_1gochat/Screens/General/Widgets/loading_button.dart';
import 'package:flutter/material.dart';

class AWSRegisterStep extends StatefulWidget {
  const AWSRegisterStep({super.key, this.authState, 
  required this.defaultEmail, required this.defaultFName, required this.defaultMName, required this.defaultLName,
  required this.signUpFunction});
  
  final AuthenticatorState? authState;
  final String defaultEmail;
  final String defaultFName;
  final String defaultMName;
  final String defaultLName;
  final Future<void> Function({
    required String username, required String password, required String preferredUsername,
    required String fname, required String mname, required String lname, required VoidCallback loadingEvent
  }) signUpFunction;

  @override
  State<AWSRegisterStep> createState() => _AWSRegisterStepState();
}

class _AWSRegisterStepState extends State<AWSRegisterStep> {
  TextEditingController emailControl = TextEditingController();
  TextEditingController fnameControl = TextEditingController();
  TextEditingController mnameControl = TextEditingController();
  TextEditingController lnameControl = TextEditingController();
  TextEditingController passControl = TextEditingController();
  TextEditingController cPassControl = TextEditingController();
  TextEditingController userControl = TextEditingController();
  bool passState = true;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if(widget.defaultEmail.isNotEmpty) emailControl.text = widget.defaultEmail;
    if(widget.defaultFName.isNotEmpty) fnameControl.text = widget.defaultFName;
    if(widget.defaultMName.isNotEmpty) mnameControl.text = widget.defaultMName;
    if(widget.defaultLName.isNotEmpty) lnameControl.text = widget.defaultLName;

    return Form(
      key: formKey,
      child: Column(
        children: [

          CustomTextField(
            control: emailControl,
            keyboard: TextInputType.emailAddress,
            isReadOnly: (widget.defaultEmail.isNotEmpty) ? true : false,
            labelTxt: 'Email',
            hintTxt: 'Enter your email',
            obscureState: false,
            validateInput: validateEmail
          ),

          CustomTextField(
            control: passControl,
            labelTxt: 'Password',
            hintTxt: 'Enter your password',
            obscureState: passState,
            suffixPic: Icon((passState == true) ? Icons.visibility : Icons.visibility_off),
            suffixEvent: () => setState(() =>  passState = !passState),
            validateInput: validatePassword
          ),

          CustomTextField(
            control: cPassControl,
            labelTxt: 'Confirm Password',
            hintTxt: 'Re-enter your password',
            obscureState: passState,
            suffixPic: Icon((passState == true) ? Icons.visibility : Icons.visibility_off),
            suffixEvent: () => setState(() =>  passState = !passState),
            validateInput: confirmPassword
          ),

          CustomTextField(
            control: userControl,
            labelTxt: 'Preferred Username',
            hintTxt: 'Enter your preferred username',
            obscureState: false,
            validateInput: validateUser
          ),
          
          CustomTextField(
            control: fnameControl,
            keyboard: TextInputType.name,
            isReadOnly: (widget.defaultFName.isNotEmpty) ? true : false,
            labelTxt: 'Given Name',
            hintTxt: 'Enter your given name',
            obscureState: false,
            validateInput: validateUser
          ),

          CustomTextField(
            control: mnameControl,
            keyboard: TextInputType.name,
            isReadOnly: (widget.defaultMName.isNotEmpty) ? true : false,
            labelTxt: 'Middle Name',
            hintTxt: 'Enter your middle name',
            obscureState: false,
            validateInput: validateUser
          ),

          CustomTextField(
            control: lnameControl,
            keyboard: TextInputType.name,
            isReadOnly: (widget.defaultLName.isNotEmpty) ? true : false,
            labelTxt: 'Family Name',
            hintTxt: 'Enter your family name',
            obscureState: false,
            validateInput: validateUser
          ),

          LoadingButton(
            label: 'Create Account',
            formKey: formKey,
            width: MediaQuery.of(context).size.width,
            authEvent: (event) {
              FocusScope.of(context).unfocus();
              widget.signUpFunction(
                username: emailControl.text.trim(),
                password: passControl.text.trim(),
                preferredUsername: userControl.text.trim(),
                fname: fnameControl.text.trim(),
                mname: mnameControl.text.trim(),
                lname: lnameControl.text.trim(),
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
    emailControl.dispose();
    fnameControl.dispose();
    mnameControl.dispose();
    lnameControl.dispose();
    passControl.dispose();
    cPassControl.dispose();
    userControl.dispose();
    super.dispose();
  }

  //Validation Condition for Password Confirmation
  
  String? confirmPassword(String fieldName, String? input) {
    if(input == null || input.isEmpty) {
      return '$fieldName field must not be blank.';
    }
    if(passControl.text != input){
      return 'Passwords do not match';
    }
    return null;
  }
}