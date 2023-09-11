package com.ch600.sms.model

enum class SMSType {
    SEND, RECEIVE
}

fun SMSType.string(): String {
    return when (this){
        SMSType.SEND -> "SEND"
        SMSType.RECEIVE -> "RECEIVE"
    }
}