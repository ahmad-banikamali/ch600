package com.ch600


import com.ch600.sms.getSms
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterFragmentActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "ch600.com/channel"
        ).setMethodCallHandler { call, result ->
            val messageBroadcastReceiver = MessageBroadcastReceiver();
            when (call.method) {
                "setAlarm" -> {
                    messageBroadcastReceiver.setAlarm(baseContext, call)
                    result.success("added")
                }

                "removeAlarm" -> {
                    messageBroadcastReceiver.removeAlarm(baseContext, call)
                    result.success("removed")
                }

                "getSms" -> {
                    result.success(getSms(this,call.argument<String>("phone")?:""))
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }


}
