var currentLang = "fa";

const String deviceDB = "deviceBox.db";

 String get appName{
    return  "CH600";
}

String get activate{
  if(currentLang=="fa") {
    return  "فعال";
  }
 return "activate";
}


String get deactivate{
  if(currentLang=="fa") {
    return  "غیر فعال";
  }
  return "deactivate";
}

String get setting{
  if(currentLang=="fa") {
    return  "تنظیمات";
  } else {
    return "settings";
  }
}

String get advance{
  if(currentLang=="fa") {
    return  "پیشرفته";
  } else {
    return "advance";
  }
}

String get exit{
  if(currentLang=="fa") {
    return  "خروج";
  } else {
    return "exit";
  }
}

String get guide{
  if(currentLang=="fa") {
    return  "راهنما";
  } else {
    return "guide";
  }
}

String get devices{
  if(currentLang=="fa") {
    return  "دستگاه ها";
  } else {
    return "devices";
  }
}

String get addNewDevice{
  if(currentLang=="fa") {
    return  "افزودن دستگاه جدید";
  } else {
    return "Add New Device";
  }
}

String get deviceName{
  if(currentLang=="fa") {
    return  "نام دستگاه";
  } else {
    return "Device Name";
  }
}

String get devicePhone{
  if(currentLang=="fa") {
    return  "شماره سیم کارت دستگاه";
  } else {
    return "Device Phone";
  }
}

String get changePassword{
  if(currentLang=="fa") {
    return  "تغییر رمز دستگاه";
  } else {
    return "Change device password";
  }
}

String get chooseSimCard{
  if(currentLang=="fa") {
    return  "انتخاب سیم کارت";
  } else {
    return "Choose SimCard";
  }
}

String get accept{
  if(currentLang=="fa") {
    return  "تایید";
  } else {
    return "Accept";
  }
}
