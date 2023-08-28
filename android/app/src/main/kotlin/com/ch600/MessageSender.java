package com.ch600;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.telephony.SmsManager;
import android.util.Log;

import java.util.Date;
import java.util.Objects;

public class MessageSender extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        Log.d("TAGaaaaaaaaaaaaaa", "alarm received");


        String phone = intent.getStringExtra("phone");
        String password = intent.getStringExtra("password");
        String defaultSimCard = intent.getStringExtra("defaultSimCard");
        String codeToSend = intent.getStringExtra("codeToSend");
        SmsManager sms = SmsManager.getDefault();
//        SmsManager sms = SmsManager.getSmsManagerForSubscriptionId(Integer.parseInt(defaultSimCard != null ? defaultSimCard : "1"));
//        sms.sendTextMessage(phone, null, password + "#" + codeToSend, null, null);
        sms.sendTextMessage("09021014157", null,  "#"  , null, null);
    }
}

