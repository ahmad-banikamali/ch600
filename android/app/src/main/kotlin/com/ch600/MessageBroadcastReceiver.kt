package com.ch600

import android.app.AlarmManager
import android.app.Notification
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.telephony.SmsManager
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall
import java.time.ZoneId
import java.util.Calendar
import java.util.TimeZone

private const val notifyID: Int = 1
private const val importance = NotificationManagerCompat.IMPORTANCE_DEFAULT
private const val channelId = "ch600_channel_01"

private val mChannel = NotificationChannelCompat.Builder(channelId, importance).apply {
    setName("ch600") // Must set! Don't remove
    setDescription("ch600 home security")
}.build()

class MessageBroadcastReceiver : BroadcastReceiver() {




    fun removeAlarm(context: Context, call: MethodCall) {
        val alarmManager =
            context.getSystemService(FlutterFragmentActivity.ALARM_SERVICE) as AlarmManager

        val alarmId = call.argument<Int>("alarmId") ?: 0

        val intent = Intent(context, MessageBroadcastReceiver::class.java)

         val pendingIntent = PendingIntent.getBroadcast(
            context,
            alarmId,
            intent,
            PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_MUTABLE
        )

        alarmManager.cancel(pendingIntent)

    }

    fun setAlarm(context: Context, call: MethodCall) {


        val phone = call.argument<String>("phone")
        val password = call.argument<String>("password")
        val defaultSimCard = call.argument<String>("defaultSimCard")
        val codeToSend = call.argument<String>("codeToSend")
        val codeName = call.argument<String>("codeName")
        val deviceName = call.argument<String>("deviceName")


        val alarmDaySaturdayFirst = call.argument<String>("dayOfWeek")?.toIntOrNull() ?: 0
        val hour = call.argument<String>("hour")?.toIntOrNull() ?: 0
        val minute = call.argument<String>("minute")?.toIntOrNull() ?: 0
        val alarmId = call.argument<Int>("alarmId") ?: 0


        val alarmManager =
            context.getSystemService(FlutterFragmentActivity.ALARM_SERVICE) as AlarmManager

        val intent: Intent = Intent(context, MessageBroadcastReceiver::class.java).apply {
            putExtra("phone", phone)
            putExtra("password", password)
            putExtra("defaultSimCard", defaultSimCard)
            putExtra("codeToSend", codeToSend)
            putExtra("isEveryDay", alarmDaySaturdayFirst == -1)
            putExtra("alarmId", alarmId)
            putExtra("codeName", codeName)
            putExtra("deviceName", deviceName)
        }


        val pendingIntent = PendingIntent.getBroadcast(
            context,
            alarmId,
            intent,
            PendingIntent.FLAG_MUTABLE
        )

        val c = calendar(alarmDaySaturdayFirst, minute, hour)


        try {
            alarmManager.setExact(
                AlarmManager.RTC_WAKEUP,
                c.timeInMillis,
                pendingIntent
            )
        } catch (e: Exception) {
            println(e)
        }


    }


    private fun calendar(
        alarmDaySaturdayFirst: Int,
        alarmMinute: Int,
        alarmHour: Int
    ): Calendar {

        val currentInstance = Calendar.getInstance(TimeZone.getTimeZone(ZoneId.of("Asia/Tehran")))
        val alarmInstance = Calendar.getInstance(TimeZone.getTimeZone(ZoneId.of("Asia/Tehran")))

        val todaySundayFirst = currentInstance.get(Calendar.DAY_OF_WEEK)
        val todaySaturdayFirst = if (todaySundayFirst == 7) 0 else todaySundayFirst

        val alarmDaySundayFirst = if (alarmDaySaturdayFirst == 0) 7 else alarmDaySaturdayFirst

        val fridayIndex = 6

        alarmInstance.set(Calendar.HOUR_OF_DAY, alarmHour)
        alarmInstance.set(Calendar.MINUTE, alarmMinute)
        alarmInstance.set(Calendar.SECOND, 0)

        val isAlarmRepeatEveryday = alarmDaySaturdayFirst == -1

        if (isAlarmRepeatEveryday) {

            alarmInstance.set(Calendar.DAY_OF_WEEK, todaySundayFirst)

            val currentHour = currentInstance.get(Calendar.HOUR_OF_DAY)
            val currentMinute = currentInstance.get(Calendar.MINUTE)

            if (alarmHour < currentHour || (alarmHour == currentHour && alarmMinute < currentMinute))
                alarmInstance.add(Calendar.HOUR_OF_DAY, 24)

        } else if (alarmDaySaturdayFirst < todaySaturdayFirst) {
            alarmInstance.set(Calendar.DAY_OF_WEEK, todaySundayFirst)
            val negativeAlarmDaySaturdayFirst =
                fridayIndex - todaySaturdayFirst + 1 + alarmDaySaturdayFirst
            val negativeAlarmDaySundayFirst =
                if (negativeAlarmDaySaturdayFirst == 0) 7 else negativeAlarmDaySaturdayFirst
            alarmInstance.add(Calendar.HOUR_OF_DAY, 24 * negativeAlarmDaySundayFirst)

        } else {
            if (alarmDaySaturdayFirst == todaySaturdayFirst){
                val currentHour = currentInstance.get(Calendar.HOUR_OF_DAY)
                val currentMinute = currentInstance.get(Calendar.MINUTE)
                if (alarmHour < currentHour || (alarmHour == currentHour && alarmMinute < currentMinute))
                    alarmInstance.add(Calendar.HOUR_OF_DAY, 24*7)
            }
            else
                alarmInstance.set(Calendar.DAY_OF_WEEK, alarmDaySundayFirst)
        }
        return alarmInstance
    }


    override fun onReceive(context: Context, intent: Intent) {
//        waitForDebugger()

        val alarmManager =
            context.getSystemService(FlutterFragmentActivity.ALARM_SERVICE) as AlarmManager

        val alarmId = intent.getIntExtra("alarmId", 0)
        val isEveryDay = intent.getBooleanExtra("isEveryDay", false)
        val codeName = intent.getStringExtra("codeName") ?: ""
        val deviceName = intent.getStringExtra("deviceName") ?: ""

        val pendingIntent = PendingIntent.getBroadcast(
            context,
            alarmId,
            intent,
            PendingIntent.FLAG_MUTABLE
        )

        showNotification(context,codeName,deviceName)
        sendMessage(intent, context)
        resetAlarm(isEveryDay, alarmManager,pendingIntent)

    }

    private fun resetAlarm(isEveryDay: Boolean, alarmManager: AlarmManager,pendingIntent:PendingIntent) {
        val oneDayMilliSeconds = 24 * 60 * 60 * 1000

        try {
            val interval = if (isEveryDay) oneDayMilliSeconds else 7 * oneDayMilliSeconds
            alarmManager.setExact(
                AlarmManager.RTC_WAKEUP,
                Calendar.getInstance().timeInMillis + interval,
                pendingIntent
            )
        } catch (e: Exception) {
            println(e)
        }
    }

}

fun sendMessage(intent: Intent, context: Context) {
    val phone = intent.getStringExtra("phone")
    val password = intent.getStringExtra("password")
    val defaultSimCard = intent.getStringExtra("defaultSimCard")
    val codeToSend = intent.getStringExtra("codeToSend")
    val smsManager: SmsManager = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        context.getSystemService(SmsManager::class.java)
            .createForSubscriptionId((defaultSimCard ?: "1").toInt())
    } else {
        SmsManager.getSmsManagerForSubscriptionId((defaultSimCard ?: "1").toInt())
    }

    smsManager.sendTextMessage(phone, null, "$password#$codeToSend", null, null)
}


fun showNotification(context: Context, codeName: String, deviceName: String) {
    NotificationManagerCompat.from(context).createNotificationChannel(mChannel)
    val notification: Notification = NotificationCompat.Builder(context, channelId)
        .setSmallIcon(R.mipmap.launcher_icon)
        .setContentText(
            " دستور \"$codeName\" به دستگاه \"$deviceName\" ارسال شد "
        )
        .build()

    NotificationManagerCompat.from(context).notify(notifyID, notification)

}