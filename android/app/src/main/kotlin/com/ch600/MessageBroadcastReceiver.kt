package com.ch600

import android.Manifest
import android.app.AlarmManager
import android.app.Notification
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.telephony.SmsManager
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall
import java.text.SimpleDateFormat
import java.time.ZoneId
import java.util.Calendar
import java.util.Date
import java.util.Locale
import java.util.TimeZone

private val notifyID: Int = 1
private val importance = NotificationManagerCompat.IMPORTANCE_DEFAULT
private val channelId = "my_channel_01"

private val mChannel = NotificationChannelCompat.Builder(channelId, importance).apply {
    setName("channel name") // Must set! Don't remove
    setDescription("channel description")
}.build()

class MessageBroadcastReceiver : BroadcastReceiver() {

    private var pendingIntent: PendingIntent? = null


    fun removeAlarm(context: Context, call: MethodCall) {
        val alarmManager =
            context.getSystemService(FlutterFragmentActivity.ALARM_SERVICE) as AlarmManager

        val alarmId = call.argument<Int>("alarmId") ?: 0

        val intent = Intent(context, MessageBroadcastReceiver::class.java)

        pendingIntent = PendingIntent.getBroadcast(
            context,
            alarmId,
            intent,
            PendingIntent.FLAG_MUTABLE
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


        pendingIntent = PendingIntent.getBroadcast(
            context,
            alarmId,
            intent,
            PendingIntent.FLAG_MUTABLE
        )

        val c = calendar(alarmDaySaturdayFirst, minute, hour)

        removeAlarm(context, call)

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
        val c = Calendar.getInstance(TimeZone.getTimeZone(ZoneId.of("Asia/Tehran")))
        val todaySundayFirst = c.get(Calendar.DAY_OF_WEEK)
        val todaySaturdayFirst = if (todaySundayFirst == 7) 0 else todaySundayFirst
        val alarmDaySundayFirst =
            when (alarmDaySaturdayFirst) {
                0 -> 7
                else -> alarmDaySaturdayFirst
            }
        val fridayIndex = 6

        c.set(Calendar.HOUR_OF_DAY, alarmHour)
        c.set(Calendar.MINUTE, alarmMinute)
        c.set(Calendar.SECOND, 0)

        if (alarmDaySaturdayFirst == -1) {

            c.set(Calendar.DAY_OF_WEEK, todaySundayFirst)
            val currentHour = c.get(Calendar.HOUR_OF_DAY)
            val currentMinute = c.get(Calendar.MINUTE)
            if (alarmHour < currentHour || (alarmHour == currentHour && alarmMinute < currentMinute))
                c.add(Calendar.HOUR_OF_DAY, 24)

        } else if (alarmDaySaturdayFirst < todaySaturdayFirst) {

            c.set(Calendar.DAY_OF_WEEK, todaySundayFirst)
            val negativeAlarmDaySaturdayFirst =
                fridayIndex - todaySaturdayFirst + 1 + alarmDaySaturdayFirst
            val negativeAlarmDaySundayFirst =
                if (negativeAlarmDaySaturdayFirst == 0) 7 else negativeAlarmDaySaturdayFirst
            c.add(Calendar.HOUR_OF_DAY, 24 * negativeAlarmDaySundayFirst)

        } else {

            c.set(Calendar.DAY_OF_WEEK, alarmDaySundayFirst)

        }
        return c
    }


    override fun onReceive(context: Context, intent: Intent) {

        //-------------

        val alarmManager =
            context.getSystemService(FlutterFragmentActivity.ALARM_SERVICE) as AlarmManager

        val alarmId = intent.getIntExtra("alarmId", 0)
        val isEveryDay = intent.getBooleanExtra("isEveryDay", false)
        val codeName = intent.getStringExtra("codeName")?:""
        val deviceName = intent.getStringExtra("deviceName")?:""

        pendingIntent = PendingIntent.getBroadcast(
            context,
            alarmId,
            intent,
            PendingIntent.FLAG_MUTABLE
        )

        showNotification(context,codeName,deviceName)
        sendMessage(intent, context)

        val oneDayMilliSeconds = 24 * 60 * 60 * 1000

        try {
            alarmManager.setExact(
                AlarmManager.RTC_WAKEUP,
                Calendar.getInstance().timeInMillis + if (isEveryDay) oneDayMilliSeconds else 7 * oneDayMilliSeconds,
                pendingIntent
            )
        } catch (e: Exception) {
            println(e)
        }


        //--------------

    }

}

fun sendMessage(intent: Intent, context: Context, text: String = "") {
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

    smsManager.sendTextMessage(phone, null, "$codeToSend#$password", null, null)
}

fun showNotification(context: Context,codeName:String,deviceName:String) {
    NotificationManagerCompat.from(context).createNotificationChannel(mChannel)
    val notification: Notification = NotificationCompat.Builder(context, channelId)
        .setSmallIcon(R.mipmap.launcher_icon)
        .setContentText(
            " دستور \"$codeName\" به دستگاه \"$deviceName\" ارسال شد "
        )
        .build()
    if (ActivityCompat.checkSelfPermission(
            context,
            Manifest.permission.POST_NOTIFICATIONS
        ) == PackageManager.PERMISSION_GRANTED
    ) {
        NotificationManagerCompat.from(context).notify(notifyID, notification)
    }
}