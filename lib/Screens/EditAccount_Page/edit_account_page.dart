import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Functions/home_page_functions.dart';
import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:app_1gochat/Screens/EditAccount_Page/Widgets/edit_account_body.dart';
import 'package:app_1gochat/Screens/General/Widgets/custom_alertdialog.dart';
import 'package:app_1gochat/Screens/General/Widgets/custom_material_banner.dart';
import 'package:app_1gochat/Screens/General/chatapp.dart';
import 'package:flutter/material.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({super.key, required this.currUser});

  final List<AuthUserAttribute> currUser;

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  TextEditingController userControl = TextEditingController();
  TextEditingController fnameControl = TextEditingController();
  TextEditingController mnameControl = TextEditingController();
  TextEditingController lnameControl = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {

    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text('Edit User Information', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Form(
          key: formKey,
          child: EditAccountBody(
            userControl: userControl,
            fnameControl: fnameControl,
            mnameControl: mnameControl,
            lnameControl: lnameControl,
            formKey: formKey,
            updateUser: (event) => confirmUpdateDialog(context, event),
          )
        )
      )
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      userControl = TextEditingController(text: widget.currUser[2].value);
      fnameControl = TextEditingController(text: widget.currUser[3].value);
      mnameControl = TextEditingController(text: getMiddleName(widget.currUser));
      lnameControl = TextEditingController(text: checkIfMNameisEmpty(widget.currUser, 5));
    });
  }

  @override
  void dispose(){
    userControl.dispose();
    fnameControl.dispose();
    mnameControl.dispose();
    lnameControl.dispose();
    super.dispose();
  }

  //Confirmation dialog for updating Account's User Information (Username, Given Name, Middle Name, Family Name)

  void confirmUpdateDialog(BuildContext context, VoidCallback loadingEvent) {
    if(context.mounted) {
      FocusScope.of(context).unfocus();
      double width = MediaQuery.of(context).size.width;
      showDialog<bool>(context: context, builder: (dialogContext) => AlertDialogLayout(
        width: width,
        titleName: 'Warning!',
        appContext: context,
        widget: const ConfirmationAlert(
          message:  'Modifying your account information will forcibly sign-out this account after completion. Are you sure you want to continue?'
        )
      )).then((value) {
        if(value == true) {
          updateAccountAttributes(loadingEvent);
        }
        else{
          loadingEvent();
        }
      });
    }
  }

  //Amplify Functionality for updating account's user information, depending on the input - Ignores the attribute if the user information is the same

  Future<void> updateAccountAttributes(VoidCallback loadingEvent) async {
    String trimmedUser = userControl.text.trim();
    String trimmedFName = fnameControl.text.trim();
    String trimmedMName = mnameControl.text.trim();
    String trimmedLName = lnameControl.text.trim();

    final attributes = [
      if(trimmedUser != widget.currUser[2].value) AuthUserAttribute(userAttributeKey: AuthUserAttributeKey.preferredUsername, value: trimmedUser),
      if(trimmedFName != widget.currUser[3].value) AuthUserAttribute(userAttributeKey: AuthUserAttributeKey.givenName, value: trimmedFName),
      if(trimmedMName != getMiddleName(widget.currUser)) AuthUserAttribute(userAttributeKey: AuthUserAttributeKey.middleName, value: trimmedMName),
      if(trimmedLName != checkIfMNameisEmpty(widget.currUser, 5)) AuthUserAttribute(userAttributeKey: AuthUserAttributeKey.familyName, value: trimmedLName),
    ];
    try {
      if(attributes.isNotEmpty) {
        final result = await Amplify.Auth.updateUserAttributes(attributes: attributes);
        final lastKey = result.keys.toList().last;
        handleUpdateUserAttributesResult(attributes, result, lastKey);
      }
      else {
        loadingEvent();
        displayCustomAuthMessage(true, 'User account is not updated.');
      }
    } on AuthException catch (e) {
      loadingEvent();
      displayCustomAuthMessage(true, e.message);
    }
  }

  void handleUpdateUserAttributesResult(List<AuthUserAttribute> attributes, Map<AuthUserAttributeKey, UpdateUserAttributeResult> result, AuthUserAttributeKey lastKey) {
    result.forEach((key, value) async {
      switch (value.nextStep.updateAttributeStep) {
        case AuthUpdateAttributeStep.confirmAttributeWithCode:
          final destination = value.nextStep.codeDeliveryDetails?.destination;
          safePrint('Confirmation code sent to $destination for $key.');
          if(key == lastKey) {
            safePrint('All Confirmation Codes are sent');
          }
        case AuthUpdateAttributeStep.done:
          safePrint('Update completed for $key');
          if(key == lastKey) {
            safePrint('All updates are completed');
            await changeUserRecord(attributes);
            signOutCurrentUser();
          }
      }
    });
  }

  //Amplify Datastore update functionality - Updates the Database record contents in accordance to the newly updated account information

  Future<void> changeUserRecord(List<AuthUserAttribute> authItems) async {
    try {
      String? username;
      String? givenName;
      String? middleName;
      String? familyName;
  
      for (var item in authItems) {
        switch (item.userAttributeKey) {
          case AuthUserAttributeKey.preferredUsername:
            username = item.value;
            break;
          case AuthUserAttributeKey.givenName:
            givenName = item.value;
            break;
          case AuthUserAttributeKey.middleName:
            middleName = item.value;
            break;
          case AuthUserAttributeKey.familyName:
            familyName = item.value;
            break;
        }
      }

      final currRecord = await Amplify.DataStore.query(User.classType, where: User.ID.eq(widget.currUser[0].value));
      if(currRecord.isNotEmpty && currRecord.length == 1) {
        final loneRecord = currRecord.first;

        final newRecord = User(
          id: loneRecord.id,
          email: loneRecord.email,
          username: (username != null && username.isNotEmpty) ? username : loneRecord.username,
          given_name: (givenName != null && givenName.isNotEmpty) ? givenName : loneRecord.given_name,
          middle_name: (middleName != null) ? middleName : loneRecord.middle_name,
          family_name: (familyName != null && familyName.isNotEmpty) ? familyName : loneRecord.family_name,
          profile_image: loneRecord.profile_image,
          account_status: loneRecord.account_status,
          principal_id: loneRecord.principal_id,
          principal_name: loneRecord.principal_name
        );
        await Amplify.DataStore.save(newRecord);
      }
    } on AuthException catch(a) {
      safePrint(a.message);
    } on DataStoreException catch(e) {
      safePrint(e.message);
    }
  }

  //Amplify Functionality for Signing Out Current User - Occurs after successful update process of account information
  
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

  //Displays Material Banner with the corresponding error message during the Amplify account information update process 

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