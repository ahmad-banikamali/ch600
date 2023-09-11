package com.ch600.sms

import android.content.Context
import android.database.Cursor
import android.net.Uri
import com.ch600.sms.model.SMS
import com.ch600.sms.model.SMSType
import com.ch600.sms.model.toHashmap


fun getSms(context: Context, address: String): List<HashMap<String, String>> {

    val smsList = emptyList<SMS>().toMutableList()

    val contentResolver = context.contentResolver

    val filter = arrayOf("%${address.reversed().substring(0, 10).reversed()}%")

    val inboxCursor: Cursor? =
        contentResolver.query(
            Uri.parse("content://sms/inbox"),
            null,
            "address like ?",
            filter,
            null
        )


    val sentCursor: Cursor? =
        contentResolver.query(
            Uri.parse("content://sms/sent"),
            null,
            "address like ?",
            filter,
            null
        )


    extracted(sentCursor, smsList, SMSType.SEND)
    extracted(inboxCursor, smsList, SMSType.RECEIVE)

    smsList.sortByDescending { x -> x.dateTime }

    inboxCursor?.close()
    sentCursor?.close()

    return smsList.map { it.toHashmap() }
}

private fun extracted(
    cursor: Cursor?,
    smsList: MutableList<SMS>,
    type:SMSType
) {
    if (cursor?.moveToFirst() == true) {
        val indexBody = cursor.getColumnIndex("body")
        val indexDate = cursor.getColumnIndex("date")
        do {
            val body = cursor.getString(indexBody)
            val date = cursor.getString(indexDate)

            smsList.add(SMS(body, date.toLong(), type))

        } while (cursor.moveToNext())
    }

}

