import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_launcher/widgets/calendar.dart';
import 'package:flutter_launcher/widgets/notes.dart';
import 'package:flutter_launcher/widgets/tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetList {
 List<Widget> widgets = [];
 SharedPreferences prefs;
 bool showTasks = true;
  bool showCalendar = true;
  bool showNotes = true;

WidgetList({required this.widgets, required this.prefs});

  List<Widget> getWidgets() {
    return [
      Visibility(
        visible: showTasks,
        child: Tasks(prefs, key: const ValueKey('Tasks')),
      ),
      Visibility(
        visible: showCalendar,
        child: Calendar(prefs, key: const ValueKey('Calendar')),
      ),
      Visibility(
        visible: showNotes,
        child: Notes(prefs, key: const ValueKey('Notes')),
      ),
    ];
  }

  void updateVisibility(widgetName, value) {
    if (widgetName == "Tasks") showTasks = value;
    if (widgetName == "Calendar") showCalendar = value;
    if (widgetName == "Notes") showNotes = value;
  }



  Future<void> saveWidgets() async {
    List<String> widgetKeys = widgets.map((widget) => widget.key.toString()).toList();
    String jsonString = jsonEncode(widgetKeys);
    await prefs.setString('widgets', jsonString);
  }

  Future<void> loadWidgets() async {
    String? jsonString = prefs.getString('widgets');
    if (jsonString != null) {
      List<String> widgetKeys = List<String>.from(jsonDecode(jsonString));
      widgets = widgetKeys.map((key) {
        if (key == "[<'Tasks'>]") {
          return Tasks(prefs, key: const ValueKey('Tasks'));
        } else if (key == "[<'Notes'>]") {
          return Notes(prefs, key: const ValueKey('Notes'));
        } else if (key == "[<'Calendar'>]") {
          return Calendar(prefs, key: const ValueKey('Calendar'));
        } else {
          return null;
        }
      }).where((widget) => widget != null).cast<Widget>().toList();
    } else {
      widgets = [
        Tasks(prefs, key: const ValueKey('Tasks')),
        Calendar(prefs, key: const ValueKey('Calendar')),
        Notes(prefs, key: const ValueKey('Notes')),
      ];
    }
  }
}
