import 'package:flutter/material.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "راهنما",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/toolbar_logo.png",
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              RichText(
                text: const TextSpan(children: [
                  TextSpan(
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      text:
                          "شرکت الکترونیک شاین شرق با بیش از 25 سال تجربه در زمینه تولید سیستم های حفاظتی با نام تجاری"),
                  TextSpan(
                    text: " CHC ",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  TextSpan(
                    text:
                        "مفتخر است تولیدات خود را با کیفیت و امکانات بالا در اختیار شما عزیزان قرار دهد.",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )
                ]),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "نحوه تنظیم نرم افزار CH600s",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(
                height: 30,
              ),
              RichText(
                text: const TextSpan(children: [
                  TextSpan(
                    text: "تنظیمات:",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                  TextSpan(
                    text: "وارد قسمت تنظیمات شوید و با زدن دکمه ",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextSpan(
                    text: "افزودن دستگاه جدید",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  TextSpan(
                    text:
                        "اطلاعات لازم را به طور کامل وارد نمایید و سیم کارتی را که میخواهید پیام ارسال کند را انتخاب نمایید.(ضمنا پس از انجام تنظیمات، دستگاه های موجود در سربرگ همه صفحات قابل تغییر است.)",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextSpan(text: "\n"),
                  TextSpan(
                    text: "نکته:",
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  TextSpan(
                    text:
                        "برای حفاظت از امکانات نرم افزار می توانید قفل برنامه رافعال یا غیر فعال و امنیت نرم افزارتان را مدیریت نمایید.",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextSpan(text: "\n"),
                  TextSpan(
                    text: "پیشرفته:",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                  TextSpan(
                    text:
                        "این قسمت شامل آپشن های گوناگونی می باشد. از جمله تایمر هوشمند که کارایی دستگاه تان را به طرز چمشگیری افزایش خواهد داد.",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextSpan(text: "\n"),
                  TextSpan(
                    text: "برنامه ریزی تایمر:",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextSpan(text: "\n"),
                  TextSpan(
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      text: '''
            1.  ساعت: ساعت دلخواه را وارد کنید
             2. انتخاب روزهای هفته و یا هرروز
             3. نوع دستور: برای این قسمت باید نوع دستور را تعیین نمایید.
             4. دکمه ثبت را وارد کنید تا اطلاعات ذخیره شود.
                    '''),
                ]),
              ),
              const SizedBox(
                height: 30,
              ),
              RichText(
                text: const TextSpan(children: [
                  TextSpan(
                    text: "موفق باشید  ",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextSpan(
                    text: "CHC ELECTRONIC",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
