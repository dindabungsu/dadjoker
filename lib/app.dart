import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/utils/color.dart';
import 'router/app_routes.dart';


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(goRouterProvider);
    final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp.router(
        scaffoldMessengerKey: scaffoldKey,
        debugShowCheckedModeBanner: false,
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        theme: _appTheme,
      ),
    );
  }
}

final _appTheme = ThemeData(
  // Define the default brightness and colors.
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.white,
    brightness: Brightness.dark,
    primary: lighterBlue,
  ),

  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.black87),
    hintStyle: TextStyle(color: Colors.black38),
    hintFadeDuration: Duration(milliseconds: 500),
    focusColor: Colors.black,
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 2),
    ),
    border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: babyOrange,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    ),
  ),
);
