package com.example.pickup_code_front

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger

class MainActivity : FlutterActivity() {
  companion object {
    @Volatile
    var smsMessenger: BinaryMessenger? = null
      private set
  }

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    smsMessenger = flutterEngine.dartExecutor.binaryMessenger
  }

  override fun onDestroy() {
    smsMessenger = null
    super.onDestroy()
  }
}
