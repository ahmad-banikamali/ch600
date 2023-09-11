package com.ch600.sms.model

data class SMS(
    val content:String,
    val dateTime: Long,
    val type: SMSType
)

fun SMS.toHashmap(): HashMap<String, String> {
    return hashMapOf(
        "content" to content,
        "dateTime" to dateTime.toString(),
        "type" to type.string()
        )
}
