package com.ch600

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Intent
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar
import java.util.Date

class MainActivity : FlutterFragmentActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "ch600.com/channel"
        ).setMethodCallHandler { call, result ->
            if (call.method == "setAlarm") {

                val phone = call.argument<String>("phone")
                val password = call.argument<String>("password")
                val defaultSimCard = call.argument<String>("defaultSimCard")
                val dayOfWeek = call.argument<String>("dayOfWeek")
                val hour = call.argument<String>("hour")
                val minute = call.argument<String>("minute")
                val codeToSend = call.argument<String>("codeToSend")


                val alarmManager =
                    application.getSystemService(ALARM_SERVICE) as AlarmManager
                val intent: Intent = Intent(baseContext, MessageSender::class.java).apply {
                    putExtra("phone",phone)
                    putExtra("password",password)
                    putExtra("defaultSimCard",defaultSimCard)
                    putExtra("codeToSend",codeToSend)
                }

                val randomId = (Date().time / 1000L % Int.MAX_VALUE).toInt()

                val pendingIntent = PendingIntent.getBroadcast(
                    baseContext,
                    randomId,
                    intent,
                    PendingIntent.FLAG_IMMUTABLE
                )


                alarmManager.setExact(
                    AlarmManager.RTC_WAKEUP,
                   Calendar.getInstance().timeInMillis+20000,
                    pendingIntent)
                result.success("added")
            } else {
                result.notImplemented()
            }
        }
    }
}
