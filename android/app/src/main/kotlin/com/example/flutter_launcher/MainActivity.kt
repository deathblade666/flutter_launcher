package com.example.flutter_launcher

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivityLaunchConfigs.BackgroundMode.transparent
import android.content.Context
import android.view.WindowManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example/notification_shade"
    override fun onCreate(savedInstanceState: Bundle?) {
        intent.putExtra("background_mode", transparent.toString())
        super.onCreate(savedInstanceState)
    }

override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "openNotificationShade") {
                openNotificationShade()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun openNotificationShade() {
    try {
        val statusBarService = getSystemService(Context.STATUS_BAR_SERVICE)
        val statusBarManager = Class.forName("android.app.StatusBarManager")
        val expand = statusBarManager.getMethod("expandNotificationsPanel")
        expand.invoke(statusBarService)
    } catch (e: Exception) {
        e.printStackTrace()
    }
}
}

