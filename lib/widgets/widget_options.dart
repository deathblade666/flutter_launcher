import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Widgetoptions extends StatefulWidget {
  Widgetoptions(
    this.prefs,
    {required this.onEnableTaskWidget,
    required this.onEnableCalendarWidget,
    required this.onEnableNotesWidget,
      super.key});
    
    final Function(bool value) onEnableTaskWidget;
    final Function(bool value) onEnableCalendarWidget;
    final Function(bool value) onEnableNotesWidget;
    SharedPreferences prefs;


  @override
  State<Widgetoptions> createState() => _WidgetoptionsState();
}

class _WidgetoptionsState extends State<Widgetoptions> {
    bool enableCalendar=false;
    bool enableTasks=false;
    bool enableNotes=false;
  @override
  void initState() {
    loadPrefs();
    super.initState();
  }

  void loadPrefs(){
    widget.prefs.reload();
    bool? calendar = widget.prefs.getBool("CalendarToggle");
    bool? tasks = widget.prefs.getBool("TasksToggle");
    bool? notes = widget.prefs.getBool("enableNotes");
    if (calendar != null){
      setState(() {
        enableCalendar = calendar;
    });
    }
    if (tasks != null){
      setState(() {
        enableTasks = tasks;
    });
    }
    if (notes != null){
      setState(() {
        enableNotes = notes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox( 
          height: 500, 
          child: Column(
            children: [
              const Text("Widgets", textScaler: TextScaler.linear(1.5)),
              SwitchListTile(
                title: const Text("Tasks"),
                value: enableTasks, 
                onChanged: (value) {                               
                  setState(() {
                    enableTasks = value;
                  });
                  widget.prefs.setBool("TasksToggle", enableTasks);
                  widget.onEnableTaskWidget(enableTasks);
                }
              ),
              SwitchListTile(
                title: const Text("Calendar"),
                value: enableCalendar, 
                onChanged: (value){
                  setState(() {
                    enableCalendar = value;
                  });
                  widget.prefs.setBool("CalendarToggle", enableCalendar);
                  widget.onEnableCalendarWidget(value);
                }
              ),
              SwitchListTile(
                title: const Text("Notes"),
                value: enableNotes, 
                onChanged: (value){
                  setState(() {
                    enableNotes = value;
                  });
                  widget.prefs.setBool("enableNotes", enableNotes);
                  widget.onEnableNotesWidget(value);
                }
              ),
              const Spacer(),
              const Text("Once enabled, simply swipe =>"),
              const Text('Each widget gets its own page'),
              const Padding(padding: EdgeInsets.only(bottom: 15))
            ],
          )
        );
  }
}