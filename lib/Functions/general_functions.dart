import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/services.dart';

//Method Channel is used for preserving the App Life Cycle in Background when Device Back Button is pressed while the user is currently signed in
//This ensure the App is not destroyed when the Back key of the Android device is pressed while the project application is active
//Kotlin functionality can be found in the directory - "android\app\src\main\kotlin\com\example\app_1gochat"

const MethodChannel _channel = MethodChannel('app_background_channel');
  
void putAppInBackground() async {
  try {
    await _channel.invokeMethod('putAppInBackground');
  } on PlatformException catch (e) {
    safePrint("Failed to put app in background: '${e.message}'.");
  }
}