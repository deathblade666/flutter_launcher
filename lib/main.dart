// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_launcher/pages/home.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_launcher/widgets/utils/widgetchangenotifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
    ChangeNotifierProvider(
      create: (context) => WidgetVisibilityState(),
      child: search_Launcher(prefs),
    ),
  );
}

final _defaultDarkColorScheme = ColorScheme.fromSwatch(
  primarySwatch: Colors.indigo, brightness: Brightness.dark);
final _defaultLightColorScheme = ColorScheme.fromSwatch(
  primarySwatch: Colors.indigo);

// ignore: must_be_immutable
class search_Launcher extends StatelessWidget {
  search_Launcher(this.prefs, {super.key});
  SharedPreferences prefs;


  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme, ) {
      
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: launcher(prefs),
        theme: ThemeData(
          colorScheme: lightColorScheme ?? _defaultLightColorScheme,
          useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
            useMaterial3: true,
          ),
        themeMode: ThemeMode.system,
        );
    });
  }
}