package com.example.pickup_code_front

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.provider.Telephony
import android.util.Log
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegisterer
import io.flutter.plugin.common.MethodChannel

private const val smsChannel = "pickup_code_front/sms_background"
private const val smsEntryPoint = "smsBackgroundMain"
private const val smsLibrary = "package:pickup_code_front/background/sms_background.dart"
private const val smsTag = "PickupSms"

class SmsReceiver : BroadcastReceiver() {
  override fun onReceive(context: Context, intent: Intent) {
    if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {
      return
    }
    val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
    if (messages.isNullOrEmpty()) {
      return
    }
    val body = messages.joinToString(separator = "") { it.messageBody ?: "" }
      .trim()
    if (body.isEmpty()) {
      return
    }
    val pendingResult = goAsync()
    SmsBackgroundEngine.enqueue(context, body) {
      pendingResult.finish()
    }
  }
}

private data class PendingSms(
  val message: String,
  val onComplete: () -> Unit,
)

private object SmsBackgroundEngine {
  private val lock = Any()
  private val queue = ArrayDeque<PendingSms>()
  private val mainHandler = Handler(Looper.getMainLooper())
  private var running = false

  fun enqueue(context: Context, message: String, onComplete: () -> Unit) {
    synchronized(lock) {
      queue.addLast(PendingSms(message, onComplete))
      if (running) {
        return
      }
      running = true
    }
    mainHandler.post { processNext(context.applicationContext) }
  }

  private fun processNext(context: Context) {
    val next = synchronized(lock) {
      if (queue.isEmpty()) {
        running = false
        null
      } else {
        queue.removeFirst()
      }
    } ?: return
    startEngine(context, next)
  }

  private fun startEngine(context: Context, sms: PendingSms) {
    try {
      val loader = FlutterInjector.instance().flutterLoader()
      loader.startInitialization(context)
      loader.ensureInitializationComplete(context, null)
      val engine = FlutterEngine(context)
      val entrypoint = DartExecutor.DartEntrypoint(
        loader.findAppBundlePath(),
        smsLibrary,
        smsEntryPoint,
      )
      engine.dartExecutor.executeDartEntrypoint(entrypoint)
      GeneratedPluginRegisterer.registerGeneratedPlugins(engine)

      val channel = MethodChannel(engine.dartExecutor.binaryMessenger, smsChannel)
      var ready = false
      channel.setMethodCallHandler { call, result ->
        if (call.method == "ready") {
          if (!ready) {
            ready = true
            sendMessage(channel, engine, context, sms)
          }
          result.success(null)
        } else {
          result.notImplemented()
        }
      }
    } catch (error: Throwable) {
      Log.e(smsTag, "Failed to start background engine", error)
      complete(context, sms, null)
    }
  }

  private fun sendMessage(
    channel: MethodChannel,
    engine: FlutterEngine,
    context: Context,
    sms: PendingSms,
  ) {
    channel.invokeMethod(
      "onSmsReceived",
      mapOf("message" to sms.message),
      object : MethodChannel.Result {
        override fun success(result: Any?) {
          complete(context, sms, engine)
        }

        override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
          Log.e(smsTag, "Dart error: $errorCode $errorMessage")
          complete(context, sms, engine)
        }

        override fun notImplemented() {
          Log.w(smsTag, "Dart handler not implemented")
          complete(context, sms, engine)
        }
      },
    )
  }

  private fun complete(context: Context, sms: PendingSms, engine: FlutterEngine?) {
    try {
      engine?.destroy()
    } catch (error: Throwable) {
      Log.w(smsTag, "Failed to destroy engine", error)
    } finally {
      sms.onComplete()
    }
    mainHandler.post { processNext(context.applicationContext) }
  }
}
