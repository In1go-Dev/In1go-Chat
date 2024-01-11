import 'package:app_1gochat/Functions/auth_page_functions.dart';
import 'package:app_1gochat/Screens/General/Widgets/custom_textformfield.dart';
import 'package:app_1gochat/Screens/General/Widgets/loading_button.dart';
import 'package:flutter/material.dart';

class EditAccountBody extends StatelessWidget {
  const EditAccountBody({super.key,
  required this.userControl,required this.fnameControl, required this.mnameControl, required this.lnameControl,
  required this.formKey, required this.updateUser});

  final TextEditingController userControl;
  final TextEditingController fnameControl;
  final TextEditingController mnameControl;
  final TextEditingController lnameControl;
  final GlobalKey<FormState> formKey;
  final void Function(VoidCallback) updateUser;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
        child: Column(
          children: [
            
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
              labelTxt: 'Given Name',
              hintTxt: 'Enter your given name',
              obscureState: false,
              validateInput: validateUser
            ),
  
            CustomTextField(
              control: mnameControl,
              keyboard: TextInputType.name,
              labelTxt: 'Middle Name',
              hintTxt: 'Enter your middle name',
              obscureState: false,
              validateInput: validateUser
            ),
  
            CustomTextField(
              control: lnameControl,
              keyboard: TextInputType.name,
              labelTxt: 'Family Name',
              hintTxt: 'Enter your family name',
              obscureState: false,
              validateInput: validateUser
            ),
            
            LoadingButton (
              label: 'Update Account',
              formKey: formKey,
              width: MediaQuery.of(context).size.width,
              authEvent: (event) {
                FocusScope.of(context).unfocus();
                updateUser(event);
              }
            )
          ]
        )
      )
    );
  }
}