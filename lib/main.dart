import 'package:flutter/material.dart';
import 'package:flutter_launcher/pages/home.dart';

void main(){
  runApp(search_Launcher());
}

class search_Launcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: launcher(),
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}