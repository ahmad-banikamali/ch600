import 'package:ch600/models/device.dart';
import 'package:ch600/screens/home_screen.dart';
import 'package:ch600/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(DeviceAdapter());
  await Hive.openBox<Device>(deviceDB);
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("fa", "IR"),
      ],
      locale: const Locale("fa", "IR"),
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black)
            .copyWith(
          primary: Colors.green,
        ),
        useMaterial3: true,
      ).copyWith(
          textTheme: const TextTheme().copyWith(
              titleMedium: const TextStyle().copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontFamily: "bYekan",
                  fontSize: 20)),
          appBarTheme: const AppBarTheme().copyWith(
              backgroundColor: Theme.of(context).colorScheme.primary)),
      home: HomePage(title: appName),
    );
  }
}


