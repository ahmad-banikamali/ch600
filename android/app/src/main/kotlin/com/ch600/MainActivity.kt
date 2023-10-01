package com.ch600


import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.os.Process
import java.io.IOException
import java.lang.reflect.InvocationTargetException
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
                    ifHuaweiAlert()
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


    private fun ifHuaweiAlert() {
        val settings: SharedPreferences = getSharedPreferences("ProtectedApps",
            Context.MODE_PRIVATE
        )
        val saveIfSkip = "skipProtectedAppsMessage"
        val skipMessage = settings.getBoolean(saveIfSkip, false)
        if (!skipMessage) {
            val editor = settings.edit()
            val intent = Intent()

            intent.setClassName(
                "com.huawei.systemmanager",
                "com.huawei.systemmanager.optimize.process.ProtectActivity"
            )

            if (isCallable(intent)) {
                AlertDialog.Builder(this)
                    .setIcon(R.mipmap.launcher_icon)
                    .setMessage(
                        "این برنامه برای عملکرد درست خود باید از لیست برنامه های محافظت شده حذف شود"
                    )
                    .setPositiveButton("ورود به صفحه برنامه های محافظت شده") { _, _ -> huaweiProtectedApps() }
                    .setCancelable(false)
                    .show()
            } else {
                editor.putBoolean(saveIfSkip, true)
                editor.apply()
            }
        }
    }

    private fun isCallable(intent: Intent): Boolean {
        val list = packageManager.queryIntentActivities(
            intent,
            PackageManager.MATCH_DEFAULT_ONLY
        )
        return list.size > 0
    }

    private fun huaweiProtectedApps() {
        try {
            var cmd = "am start -n com.huawei.systemmanager/.optimize.process.ProtectActivity"
            cmd += " --user " + getUserSerial()
            Runtime.getRuntime().exec(cmd)
        } catch (ignored: IOException) {
        }
    }


    private fun getUserSerial(): String {
        val userManager = getSystemService("user") ?: return ""
        try {
            val myUserHandleMethod =
                Process::class.java.getMethod("myUserHandle", null)
            val myUserHandle = myUserHandleMethod.invoke(Process::class.java, null)
            val getSerialNumberForUser =
                userManager.javaClass.getMethod("getSerialNumberForUser", myUserHandle.javaClass)
            val userSerial = getSerialNumberForUser.invoke(userManager, myUserHandle) as Long
            return userSerial.toString() ?: ""
        } catch (ignored: NoSuchMethodException) {
        } catch (ignored: IllegalArgumentException) {
        } catch (ignored: InvocationTargetException) {
        } catch (ignored: IllegalAccessException) {
        }
        return ""
    }
}
