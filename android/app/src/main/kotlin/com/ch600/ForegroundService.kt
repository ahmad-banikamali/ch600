package com.ch600

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import androidx.core.app.NotificationCompat


class ForegroundService : Service() {

    private lateinit var pm: PowerManager
    private lateinit var wl: PowerManager.WakeLock
    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {

        createNotificationChannel()
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0, notificationIntent,
            PendingIntent.FLAG_MUTABLE
        )
        val notification: Notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("برنامه ch600 در حال اجرا است")
            .setSmallIcon(R.mipmap.launcher_icon)
            .setContentIntent(pendingIntent)
            .build()

        startForeground(2, notification)
        pm = getSystemService(POWER_SERVICE) as PowerManager
        wl = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "a:b")

        if (wl.isHeld)
            wl.release()

        wl.acquire()

        return START_STICKY_COMPATIBILITY
    }

    override fun onDestroy() {

        pm = getSystemService(POWER_SERVICE) as PowerManager
        wl = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "a:b")
        if (wl.isHeld)
        wl.release()
        super.onDestroy()
    }


    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "ch600 foreground service",
                NotificationManager.IMPORTANCE_HIGH
            )
            val manager: NotificationManager = getSystemService(
                NotificationManager::class.java
            )
            manager.createNotificationChannel(serviceChannel)
        }
    }

    companion object {
        const val CHANNEL_ID = "ch600_channel_keep_alive"
    }
}