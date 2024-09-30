import 'package:flutter/material.dart';
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

  @override
  State<Widgetoptions> createState() => _WidgetoptionsState();
}

class _WidgetoptionsState extends State<Widgetoptions> {
  List<Widget> items = [];
  List<bool> switchValues = [false, false, false];
  bool enableCalendar=true;
  bool enableTasks=false;
  bool enableNotes=false;
    
  @override
  void initState() {
    loadPrefs();
    items = WidgetList(widgets: items, prefs: widget.prefs).getWidgets();
    super.initState();
  }

  void loadPrefs() async {
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

    WidgetList widgets = WidgetList(widgets: [], prefs: widget.prefs);
    await widgets.loadWidgets();
    setState(() {
       items = widgets.widgets;
    });
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
            //TODO: Setup new toggles for widget
            child: StatefulBuilder(builder: (BuildContext context, StateSetter setState){
              return ReorderableListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index,) {
                  return SwitchListTile(
                    key: ValueKey(items[index]),
                    title: Text('${items[index]}'.split("'")[1].split('-')[0]),
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
                    WidgetList(prefs: widget.prefs,widgets: items).saveWidgets();
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