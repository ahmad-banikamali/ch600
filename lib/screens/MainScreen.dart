import 'package:ch600/Utils/constants.dart';
import 'package:ch600/models/main_screen_button.dart';
import 'package:ch600/screens/HomePage.dart';
import 'package:ch600/widgets/Logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/Background.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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


