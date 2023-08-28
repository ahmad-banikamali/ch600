package com.ch600

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Intent
import android.os.Build
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.time.ZoneId
import java.util.Calendar
import java.util.TimeZone


class MainActivity : FlutterFragmentActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "ch600.com/channel"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "setAlarm" -> {
                    setAlarm(call)
                    result.success("added")
                }

                "removeAlarm" -> {
                    removeAlarm(call)
                    result.success("removed")
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun removeAlarm(call: MethodCall) {
        val alarmId = call.argument<Int>("alarmId") ?: 0

        val alarmManager =
            application.getSystemService(ALARM_SERVICE) as AlarmManager
        val intent = Intent(baseContext, MessageSender::class.java)

        val pendingIntent = PendingIntent.getBroadcast(
            baseContext,
            alarmId,
            intent,
            PendingIntent.FLAG_IMMUTABLE
        )
        alarmManager.cancel(pendingIntent)
    }

    private fun setAlarm(call: MethodCall) {

        val phone = call.argument<String>("phone")
        val password = call.argument<String>("password")
        val defaultSimCard = call.argument<String>("defaultSimCard")
        val alarmDaySaturdayFirst = call.argument<String>("dayOfWeek")?.toIntOrNull() ?: 0
        val hour = call.argument<String>("hour")?.toIntOrNull() ?: 0
        val minute = call.argument<String>("minute")?.toIntOrNull() ?: 0
        val codeToSend = call.argument<String>("codeToSend")
        val alarmId = call.argument<Int>("alarmId") ?: 0


        val alarmManager =
            application.getSystemService(ALARM_SERVICE) as AlarmManager

        val intent: Intent = Intent(this, MessageSender::class.java).apply {
            putExtra("phone", phone)
            putExtra("password", password)
            putExtra("defaultSimCard", defaultSimCard)
            putExtra("codeToSend", codeToSend)
        }


        val pendingIntent = PendingIntent.getBroadcast(
            baseContext,
            alarmId,
            intent,
            PendingIntent.FLAG_MUTABLE
        )

        val oneDayMilliSeconds = 24 * 60 * 60 * 1000
        val interval =
            if (alarmDaySaturdayFirst == 7) oneDayMilliSeconds else 7 * oneDayMilliSeconds


        val c = calendar(alarmDaySaturdayFirst, minute, hour)

        try {
            alarmManager.setRepeating(
                AlarmManager.RTC_WAKEUP,
                c.timeInMillis,
                interval.toLong(),
                pendingIntent
            )
        } catch (e: Exception) {
            println(e)
        }


    }


    private fun calendar(
        alarmDaySaturdayFirst: Int,
        minute: Int,
        hour: Int
    ): Calendar {
        val c = Calendar.getInstance(TimeZone.getTimeZone(ZoneId.of("Asia/Tehran")))
        val todaySundayFirst = c.get(Calendar.DAY_OF_WEEK)
        val todaySaturdayFirst = if (todaySundayFirst == 7) 0 else todaySundayFirst
        val alarmDaySundayFirst = if (alarmDaySaturdayFirst == 0) 7 else alarmDaySaturdayFirst
        val fridayIndex = 6

        c.set(Calendar.MINUTE, minute)
        c.set(Calendar.HOUR_OF_DAY, hour)
        c.set(Calendar.SECOND, 0)

        c.set(Calendar.DAY_OF_WEEK, alarmDaySundayFirst)


        if (alarmDaySaturdayFirst < todaySaturdayFirst) {
            c.set(Calendar.DAY_OF_WEEK, todaySundayFirst)
            val negativeAlarmDaySaturdayFirst =
                fridayIndex - todaySaturdayFirst + 1 + alarmDaySaturdayFirst
            val negativeAlarmDaySundayFirst =
                if (negativeAlarmDaySaturdayFirst == 0) 7 else negativeAlarmDaySaturdayFirst
            c.add(Calendar.HOUR, 24 * negativeAlarmDaySundayFirst)
        } else {
            c.set(Calendar.DAY_OF_WEEK, alarmDaySundayFirst)
        }
        return c
    }
}
