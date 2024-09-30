import 'package:flutter/material.dart';
import 'package:flutter_launcher/widgets/calendar.dart';
import 'package:flutter_launcher/widgets/notes.dart';
import 'package:flutter_launcher/widgets/tasks.dart';
import 'package:flutter_launcher/widgets/utils/widget_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Widgetoptions extends StatefulWidget {
  Widgetoptions(
    this.prefs,
    
    {
      required this.onorderChange,
      /*required this.onEnableTaskWidget,
    required this.onEnableCalendarWidget,
    required this.onEnableNotesWidget,
    */super.key});
    
    /*final Function(bool value) onEnableTaskWidget;
    final Function(bool value) onEnableCalendarWidget;
    final Function(bool value) onEnableNotesWidget;
    */SharedPreferences prefs;
    final Function(List<Widget> items) onorderChange;

  /*List<Widget> getWidgets() {
    return [
      Tasks(prefs, key: const ValueKey('tasks')),
      Calendar(prefs,key: const ValueKey('calendar')),
      Notes(prefs, key: const ValueKey('notes'))
    ];
  }*/

  @override
  State<Widgetoptions> createState() => _WidgetoptionsState();
}

class _WidgetoptionsState extends State<Widgetoptions> {
  List<Widget> items = [];
  List<bool> switchValues = [false, false, false];
  bool enableCalendar=false;
  bool enableTasks=false;
  bool enableNotes=false;
    
  @override
  void initState() {
    loadPrefs();
    items = WidgetList(widgets: items, prefs: widget.prefs).getWidgets();
    //widget.onorderChange(items);
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
          SizedBox(
            height: 400,
            width: 400,
            child: StatefulBuilder(builder: (BuildContext context, StateSetter setState){ 
              return 
             ReorderableListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index,) {
                  return SwitchListTile(
                    key: ValueKey(items[index]),
                    title: Text('${items[index]}'.split('-')[0]),
                    value: switchValues[index],
                    onChanged: (bool value) {
                      setState(() {
                        switchValues[index] = value;
                      });
                      widget.onorderChange(items);
                    },
                    enableFeedback: true,
                  );
                },
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final Widget item = items.removeAt(oldIndex);
                    final bool switchValue = switchValues.removeAt(oldIndex);
                    items.insert(newIndex, item);
                    switchValues.insert(newIndex, switchValue);
                    print('Items List: $items');
                    
                    
                  });
                  widget.onorderChange(items);
                },
              );
            }),
          ),
          const Text("TEst"),
          const Padding(padding: EdgeInsets.only(bottom: 15))
        ],
      )
    );
  }
}