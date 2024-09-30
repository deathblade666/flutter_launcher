import 'package:flutter/material.dart';
import 'package:flutter_launcher/widgets/calendar.dart';
import 'package:flutter_launcher/widgets/notes.dart';
import 'package:flutter_launcher/widgets/tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetList {
 List<Widget> widgets = [];
 SharedPreferences prefs;


WidgetList({required this.widgets, required this.prefs});


  List<Widget> getWidgets() {
    print("get Widgets");
    return [
      Tasks(prefs, key: const ValueKey('tasks')),
      Calendar(prefs,key: const ValueKey('calendar')),
      Notes(prefs, key: const ValueKey('notes'))
    ];
    
  }
}