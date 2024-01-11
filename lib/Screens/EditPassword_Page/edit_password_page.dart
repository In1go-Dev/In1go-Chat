import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Screens/EditPassword_Page/Widgets/edit_password_body.dart';
import 'package:app_1gochat/Screens/General/Widgets/custom_alertdialog.dart';
import 'package:app_1gochat/Screens/General/Widgets/custom_material_banner.dart';
import 'package:app_1gochat/Screens/General/chatapp.dart';
import 'package:flutter/material.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key, required this.currUser});

  final List<AuthUserAttribute> currUser;

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  TextEditingController oldPassControl = TextEditingController();
  TextEditingController newPassControl = TextEditingController();
  TextEditingController cPassControl = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text('Edit Account Password', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Form(
          key: formKey,
          child: EditPasswordBody (
            oldPassControl: oldPassControl,
            newPassControl: newPassControl,
            cPassControl: cPassControl,
            formKey: formKey,
            validatePass: validatePassword,
            validateNewPass: validateNewPassword,
            confirmPass: confirmPassword,
            updatePass: (event) => confirmUpdateDialog(context, event)
          )
        )
      )
    );
  }

  @override
  void dispose(){
    oldPassControl.dispose();
    newPassControl.dispose();
    cPassControl.dispose();
    super.dispose();
  }

  //Validation Condition for the old password input

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

  //Validation Condition for the new password input

  String? validateNewPassword(String fieldName, String? input) {
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
    else if(oldPassControl.text == input){
      return 'Please input a new password.';
    }
    return null;
  }

  //Validation Condition for Password Confirmation

  String? confirmPassword(String fieldName, String? input) {
    if(input == null || input.isEmpty) {
      return '$fieldName field must not be blank.';
    }
    else if(oldPassControl.text == input) {
      return 'Please input a new password.';
    }
    else if(newPassControl.text != input) {
      return 'Passwords do not match';
    }
    return null;
  }

  //Confirmation dialog for updating Account Password

  void confirmUpdateDialog(BuildContext context, VoidCallback loadingEvent) {
    if(context.mounted) {
      FocusScope.of(context).unfocus();
      double width = MediaQuery.of(context).size.width;
      showDialog<bool>(context: context, builder: (dialogContext) => AlertDialogLayout(
        width: width,
        titleName: 'Warning!',
        appContext: context,
        widget: const ConfirmationAlert(
          message:  'Modifying your account password will forcibly sign-out this account after completion. Are you sure you want to continue?'
        )
      )).then((value) {
        if(value == true) {
          changeUserPassword(
            oldPassword: oldPassControl.text.trim(),
            newPassword: newPassControl.text.trim(),
            loadingEvent: loadingEvent
          );
        }
        else{
          loadingEvent();
        }
      });
    }
  }

  //Amplify Functionality for updating account password

  Future<void> changeUserPassword({required String oldPassword, required String newPassword, required VoidCallback loadingEvent}) async {
    try {
      await Amplify.Auth.updatePassword(oldPassword: oldPassword, newPassword: newPassword);
      //displayCustomAuthMessage(false, "Password sucessfully changed.");
      signOutCurrentUser();
    } on AuthException catch (e) {
      loadingEvent();
      switch (e.message) {
        case 'Incorrect username or password.':
        displayCustomAuthMessage(true, "Incorrect old password");
        break;

        default:
        displayCustomAuthMessage(true, e.message);
        break;
      }
    }
  }

  //Amplify Functionality for Signing Out Current User - Occurs after successful update process of account password
  
  Future<void> signOutCurrentUser() async {
    final result = await Amplify.Auth.signOut();
    if (result is CognitoCompleteSignOut) {
      if(context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const ChatApp()),
          (Route<dynamic> route) => false
        );
      }
      safePrint('Sign out completed successfully');
    } else if (result is CognitoFailedSignOut) {
      safePrint('Error signing user out: ${result.exception.message}');
    }
  }

  //Displays Material Banner with the corresponding error message during the Amplify password update process 

  void displayCustomAuthMessage(bool isError, String message) {
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
}