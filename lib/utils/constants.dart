var currentLang = "fa";

class DbConstants {
  static const String deviceDB = "deviceBox.db";
  static const String alarmDB = "alarmBox.db";
  static const String etcDB = "etc";


  static const String keyShowLockOnAdvanceScreen = "keyShowLockOnAdvanceScreen";
  static const String keyShowLockOnHomeScreen = "keyShowLockOnHomeScreen";
  static const String keyPassword = "keyPassword";

}

String get appName {
  return "CH600";
}

String get activate {
  if (currentLang == "fa") {
    return "فعال";
  }
  return "activate";
}

String get deactivate {
  if (currentLang == "fa") {
    return "غیر فعال";
  }
  return "deactivate";
}

String get setting {
  if (currentLang == "fa") {
    return "تنظیمات";
  } else {
    return "settings";
  }
}

String get advance {
  if (currentLang == "fa") {
    return "پیشرفته";
  } else {
    return "advance";
  }
}

String get exitFromApp {
  if (currentLang == "fa") {
    return "خروج";
  } else {
    return "exit";
  }
}

String get guide {
  if (currentLang == "fa") {
    return "راهنما";
  } else {
    return "guide";
  }
}

String get devices {
  if (currentLang == "fa") {
    return "دستگاه ها";
  } else {
    return "devices";
  }
}

String get addNewDevice {
  if (currentLang == "fa") {
    return "افزودن دستگاه جدید";
  } else {
    return "Add New Device";
  }
}

String get deviceName {
  if (currentLang == "fa") {
    return "نام دستگاه";
  } else {
    return "Device Name";
  }
}

String get devicePhone {
  if (currentLang == "fa") {
    return "شماره سیم کارت دستگاه";
  } else {
    return "Device Phone";
  }
}

String get changePassword {
  if (currentLang == "fa") {
    return "تغییر رمز دستگاه";
  } else {
    return "Change device password";
  }
}

String get chooseSimCard {
  if (currentLang == "fa") {
    return "انتخاب سیم کارت";
  } else {
    return "Choose SimCard";
  }
}

String get accept {
  if (currentLang == "fa") {
    return "تایید";
  } else {
    return "Accept";
  }
}
String get cancel {
  if (currentLang == "fa") {
    return "لغو";
  } else {
    return "Cancel";
  }
}

String get activateWithSound {
  if (currentLang == "fa") {
    return "فعال با صدا";
  } else {
    return "Activate With Sound";
  }
}

String get deactivateWithSound {
  if (currentLang == "fa") {
    return "غیر فعال با صدا";
  } else {
    return "Deactivate With Sound";
  }
}

String get report {
  if (currentLang == "fa") {
    return "گزارش";
  } else {
    return "Report";
  }
}

String get semiActive {
  if (currentLang == "fa") {
    return "نیمه فعال";
  } else {
    return "Semi Active";
  }
}

String get activateRemote {
  if (currentLang == "fa") {
    return "ریموت فعال";
  } else {
    return "Activate Remote";
  }
}

String get deactivateRemote {
  if (currentLang == "fa") {
    return "ریموت غیر فعال";
  } else {
    return "Deactivate Remote";
  }
}

String get activateKeypad {
  if (currentLang == "fa") {
    return "کی پد فعال";
  } else {
    return "Activate Keypad";
  }
}

String get deactivateKeypad {
  if (currentLang == "fa") {
    return "کی پد غیر فعال";
  } else {
    return "Deactivate Keypad";
  }
}

String get activateConnection {
  if (currentLang == "fa") {
    return "فعال کردن ارتباط";
  } else {
    return "Activate Connection";
  }
}

String get deactivateConnection {
  if (currentLang == "fa") {
    return "غیر فعال کردن ارتباط";
  } else {
    return "Deactivate Connection";
  }
}

String get timers {
  if (currentLang == "fa") {
    return "تایمرها";
  } else {
    return "Timers";
  }
}

String get emergency {
  if (currentLang == "fa") {
    return "آژیر اضطراری";
  } else {
    return "Emergency";
  }
}

String get messagesInbox {
  if (currentLang == "fa") {
    return "صندوق پیام ها";
  } else {
    return "Messages Inbox";
  }
}


class WeekDay {

  static String get saturday {
    if (currentLang == "fa") {
      return "شنبه";
    } else {
      return "saturday";
    }
  }

  static String get sunday {
    if (currentLang == "fa") {
      return "یکشنبه";
    } else {
      return "sunday";
    }
  }

  static String get monday {
    if (currentLang == "fa") {
      return "دوشنبه";
    } else {
      return "monday";
    }
  }

  static String get tuesday {
    if (currentLang == "fa") {
      return "سه شنبه";
    } else {
      return "tuesday";
    }
  }

  static String get wednesday {
    if (currentLang == "fa") {
      return "چهارشنبه";
    } else {
      return "wednesday";
    }
  }

  static String get thursday {
    if (currentLang == "fa") {
      return "پنجشنبه";
    } else {
      return "thursday";
    }
  }

  static String get friday {
    if (currentLang == "fa") {
      return "جمعه";
    } else {
      return "friday";
    }
  }

  static String get everyday {
    if (currentLang == "fa") {
      return "هرروز";
    } else {
      return "everyday";
    }
  }

  static String get error {
    if (currentLang == "fa") {
      return "خطا: روز هفته نمی باشد";
    } else {
      return "not a week day";
    }
  }


}