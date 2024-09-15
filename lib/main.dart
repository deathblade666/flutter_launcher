import 'package:flutter/material.dart';
import 'package:flutter_launcher/pages/home.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const search_Launcher());
}

final _defaultDarkColorScheme = ColorScheme.fromSwatch(
  primarySwatch: Colors.indigo, brightness: Brightness.dark);
final _defaultLightColorScheme = ColorScheme.fromSwatch(
  primarySwatch: Colors.indigo);

class search_Launcher extends StatelessWidget {
  const search_Launcher({super.key});

  @override
  Widget build(BuildContext context) {
    
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme, ) {
      
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: launcher(),
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