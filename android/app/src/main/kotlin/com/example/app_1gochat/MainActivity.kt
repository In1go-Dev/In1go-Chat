package com.app.onegochat

import android.app.Activity
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val appBackgroundChannel = "app_background_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, appBackgroundChannel)
                .setMethodCallHandler { call, result ->
                    if (call.method == "putAppInBackground") {
                        moveTaskToBack(true)
                        result.success(true)
                    } else {
                        result.notImplemented()
                    }
                }
    }
}
