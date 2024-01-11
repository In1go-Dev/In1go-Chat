import 'dart:io';

import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:app_1gochat/Functions/auth_page_functions.dart';
import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:app_1gochat/Screens/General/chatapp.dart';
import 'package:app_1gochat/Screens/General/failed_chatapp.dart';
import 'package:app_1gochat/amplifyconfiguration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:receive_intent/receive_intent.dart' as receive;
import 'package:timezone/timezone.dart';

//04-2023: GEU - Runs the Application whilst also setting up splash screens, platform checking, Amplify configurations, etc.

void main() async {

  //Necessary due to certain Flutter packages with platform limitations
  if(Platform.isAndroid) {

    //Necessary for Splash Screen Initialization
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    //Receives the Intent whenever Chat App is opened through the Merchandising App...
    final receivedIntent = await receive.ReceiveIntent.getInitialIntent();

    try {
      tz.initializeTimeZones();
      await configureAmplify();
      runApp(ProviderScope(child: ChatApp(receivedIntent: receivedIntent)));

    } on AmplifyAlreadyConfiguredException {

      safePrint("Tried to reconfigure Amplify; this can occur when your app restarts on OS.");
      runApp(ProviderScope(child: ChatApp(receivedIntent: receivedIntent)));

    } on AmplifyException catch (e) {

      safePrint('An error occurred configuring Amplify: $e');
      String message = (e.message.endsWith(".")) ? e.message : "${e.message}.";
      String? recovery = getRecoveryMessage(e.recoverySuggestion);

      runApp(FailedChatApp(errorMessage: "$message $recovery"));

    } on TimeZoneInitException catch(e) {

      safePrint('An error occurred configuring Timeout Initialization: $e');
      runApp(const FailedChatApp(errorMessage: 'Something went wrong while the app was loading.'));

    }

    FlutterNativeSplash.remove();
  }
  
  else {
    runApp(
      const FailedChatApp(
        errorMessage: 'Something went wrong. Make sure you\'re using the correct platform.'
      )
    );
  }
}

//04-26-2023: GEU - App Configuration for the Amplify

Future<void> configureAmplify() async {
  if(Amplify.isConfigured == false) {
    final datastorePlugin = AmplifyDataStore(modelProvider: ModelProvider.instance);
    final apiPlugin = AmplifyAPI(modelProvider: ModelProvider.instance);
    final authPlugin = AmplifyAuthCognito();
    final storagePlugin = AmplifyStorageS3();
    final analyticsPlugin = AmplifyAnalyticsPinpoint();
    
    await Amplify.addPlugins([datastorePlugin, apiPlugin, authPlugin, storagePlugin, analyticsPlugin]);
    await Amplify.configure(amplifyconfig);
  }
}
