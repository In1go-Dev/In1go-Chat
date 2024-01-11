import 'package:app_1gochat/Screens/General/Widgets/custom_textformfield.dart';
import 'package:app_1gochat/Screens/General/Widgets/loading_button.dart';
import 'package:flutter/material.dart';

class EditPasswordBody extends StatefulWidget {
  const EditPasswordBody({super.key, 
  required this.oldPassControl, required this.newPassControl, required this.cPassControl, required this.formKey,
  required this.validatePass, required this.validateNewPass, required this.confirmPass, required this.updatePass});

  final TextEditingController oldPassControl;
  final TextEditingController newPassControl;
  final TextEditingController cPassControl;
  final GlobalKey<FormState> formKey;
  final String? Function(String, String?) validatePass;
  final String? Function(String, String?) validateNewPass;
  final String? Function(String, String?) confirmPass;
  final void Function(VoidCallback) updatePass;

  @override
  State<EditPasswordBody> createState() => _EditPasswordBodyState();
}

class _EditPasswordBodyState extends State<EditPasswordBody> {
  bool passState = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
        child: Column(
          children: [
            
            CustomTextField(
              control: widget.oldPassControl,
              labelTxt: 'Old Password',
              hintTxt: 'Enter your old password',
              obscureState: passState,
              suffixPic: Icon((passState == true) ? Icons.visibility : Icons.visibility_off),
              suffixEvent: () => setState(() =>  passState = !passState),
              validateInput: widget.validatePass
            ),
            CustomTextField(
              control: widget.newPassControl,
              labelTxt: 'New Password',
              hintTxt: 'Enter your new password',
              obscureState: passState,
              suffixPic: Icon((passState == true) ? Icons.visibility : Icons.visibility_off),
              suffixEvent: () => setState(() =>  passState = !passState),
              validateInput: widget.validateNewPass
            ),
  
            CustomTextField(
              control: widget.cPassControl,
              labelTxt: 'Confirm Password',
              hintTxt: 'Re-enter your new password',
              obscureState: passState,
              suffixPic: Icon((passState == true) ? Icons.visibility : Icons.visibility_off),
              suffixEvent: () => setState(() =>  passState = !passState),
              validateInput: widget.confirmPass
            ),
            
            LoadingButton(
              label: 'Update Password',
              formKey: widget.formKey,
              width: MediaQuery.of(context).size.width,
              authEvent: (event) {
                FocusScope.of(context).unfocus();
                widget.updatePass(event);
              }
            )
          ]
        )
      )
    );
  }
}