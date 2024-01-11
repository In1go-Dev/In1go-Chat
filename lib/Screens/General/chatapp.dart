import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Functions/auth_page_functions.dart';
import 'package:app_1gochat/Functions/home_page_functions.dart';
import 'package:app_1gochat/Providers/homepagesettings.dart';
import 'package:app_1gochat/Screens/Authenticator_Page/auth_page.dart';
import 'package:app_1gochat/Screens/Home_Page/home_page.dart';
import 'package:app_1gochat/Themes/chatapp_theme_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_intent/receive_intent.dart' as receive;


class ChatApp extends ConsumerStatefulWidget {
  const ChatApp({super.key, this.receivedIntent});
  
  final receive.Intent? receivedIntent;

  @override
  ConsumerState<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends ConsumerState<ChatApp> with WidgetsBindingObserver {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  StreamSubscription<receive.Intent?>? backgroundHandleStream;
  receive.Intent? defaultInput;
  String registerEmail = '';
  String initialKey = "email";

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      authenticatorBuilder: (BuildContext context, AuthenticatorState state) => authenticationProcess(context, state),
      exceptionBannerLocation: ExceptionBannerLocation.top,
      child: MaterialApp(
        themeMode: ThemeMode.light,
        theme: ChatAppThemeData().lightTheme,
        darkTheme: ChatAppThemeData().darkTheme,
        builder: Authenticator.builder(),
        home: const HomePageDisplay()
      )
    );
  }

  Widget? authenticationProcess(BuildContext context, AuthenticatorState state) {      //05-24-2023: GEU - Built-In Layout for AWS Authentication Process
    switch (state.currentStep) {
      case AuthenticatorStep.signIn:
        return checkDefaultStep(defaultInput, state);
      case AuthenticatorStep.signUp:
        return CustomAWSAuthenticator(
          state: state,
          scaffoldMessengerKey: scaffoldMessengerKey,
          registerEmail: registerEmail,
          intent: defaultInput,
          resetDefaultValue: resetDefaultInputValue,
          setAccountData: setAccountData,
        );
      case AuthenticatorStep.confirmSignUp:
        return CustomAWSAuthenticator(
          state: state,
          scaffoldMessengerKey: scaffoldMessengerKey,
          registerEmail: registerEmail,
          intent: defaultInput,
          resetDefaultValue: resetDefaultInputValue,
          setAccountData: setAccountData,
        );
      case AuthenticatorStep.resetPassword:
        return CustomAWSAuthenticator(state: state);
      case AuthenticatorStep.confirmResetPassword:
        return CustomAWSAuthenticator(state: state);
      default: return null;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeDefaultAuth();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ref.read(searchField).dispose();
    backgroundHandleStream?.cancel();
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {   //07-25-2023 - Checks the App Life Cycle State
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.paused || state == AppLifecycleState.resumed) {
      final receivedIntent = receive.ReceiveIntent.receivedIntentStream;
      backgroundHandleStream = receivedIntent.listen((result) async {
        try {
          //Checks if intent extra is empty or possess the initial key, which is "email"
          if(result?.extra != null && result!.extra!.containsKey(initialKey)) await checkAuthStateForReload(result);
        } on Exception catch(e) {
          safePrint(e);
        }
      }, onError: (error) {

      });
    }
  }

  Future<void> initializeDefaultAuth() async {
    if(Amplify.isConfigured) {
      try {
        final authStatus = await Amplify.Auth.fetchAuthSession();
  
        if(!authStatus.isSignedIn) { //Check if app has no signed in user
          if(context.mounted) {
            setState(() {
              //Checks if intent extra is empty or possess the initial key, which is "email"
              if(widget.receivedIntent?.extra != null && widget.receivedIntent!.extra!.containsKey(initialKey)) defaultInput = widget.receivedIntent;
            });
          }
        }
  
        else {
          if(widget.receivedIntent != null) await compareLoggedandIntentEmail(widget.receivedIntent!);
        }
      } on AuthException catch (e) {
        safePrint(e.message);
      }
    }
  }

  //If the app finds a signed-in account, this functionality triggers

  Future<void> compareLoggedandIntentEmail(receive.Intent currIntent) async {
    try {
      final userData = await Amplify.Auth.fetchUserAttributes();
      String checkEmail = '';
      Map<String, dynamic>? extras = currIntent.extra;
      if(extras != null) {   //If intent extra is not empty, retrieve the email value if there is any
  
        final intentEntries = extras.entries;
        for(var entries in intentEntries){
          if(entries.key == "email") checkEmail = entries.value.toString();
        }

        //If there is an email value from intent and matches currently sign in user's email, forcibly sign out the account
  
        if(checkEmail.isNotEmpty && checkEmail != checkIfMNameisEmpty(userData, 6)) await signOutCurrentUserAtInitialization(currIntent);

      }
    } on Exception catch(e) {
      safePrint("Error in Retrieving User Account Information - $e");
    }
  }

  //Amplify Functionality for Signin Out Current User

  Future<void> signOutCurrentUserAtInitialization(receive.Intent receivedIntent) async {
    await Amplify.Auth.signOut().then((value) {
      if (value is CognitoCompleteSignOut) {
        safePrint('Sign out completed successfully');
  
        if(context.mounted) {
          setState(() {
            defaultInput = receivedIntent;
          });
        }
      } else if (value is CognitoFailedSignOut) {
        safePrint('Error signing user out: ${value.exception.message}');
      }
    });
  }

  Future<void> checkAuthStateForReload(receive.Intent receivedIntent) async {
    if(Amplify.isConfigured) {
      try {
        final authStatus = await Amplify.Auth.fetchAuthSession();
        
        if(!authStatus.isSignedIn) {
          //Check if the app currently has an existing intent then compare all its values, return false if there are differences
          if(mapEquals(defaultInput?.extra, receivedIntent.extra) == false) {    
            if(context.mounted) {
              setState(() => defaultInput = receivedIntent);  //Change the default Intent with the new Intent
            }
          }
        }
  
        else {
          if(context.mounted) {
            await compareLoggedandIntentEmail(receivedIntent);
          }
        }
      } on AuthException catch (e) {
        safePrint(e.message);
      }
    }
  }

  //After a successful registration, save the email and password value (this is placed in a secured storage) so it can be used for auto-registration if the user continues
  //and completes the account confirmation

  Future<void> setAccountData(String? email, String? password) async {
    if((email != null && email.isNotEmpty) && (password != null && password.isNotEmpty)) {
      setState(() {
        registerEmail = email; 
        writePassword(ref, password);
      });
    }
  }

  //Functionality for Clearing Intent, Email value (after navigating from registration to confirmation), and the secured password value during Authenticator navigation

  void resetDefaultInputValue() {
    if(defaultInput?.extra != null && defaultInput!.extra!.entries.isNotEmpty) {
      if(context.mounted) {
        setState(() {
          defaultInput = null;
          if(registerEmail.isNotEmpty) registerEmail = '';
          clearPassword(ref);
        });
      }
    }
  }
}