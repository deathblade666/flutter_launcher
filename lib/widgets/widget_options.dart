import 'package:flutter/material.dart';
import 'package:flutter_launcher/widgets/utils/widget_utils.dart';
import 'package:flutter_launcher/widgets/utils/widgetchangenotifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Widgetoptions extends StatefulWidget {
  Widgetoptions(
    this.prefs,
    
    {
      required this.onorderChange,
      required this. onToggleChange,
      /*required this.onEnableTaskWidget,
    required this.onEnableCalendarWidget,
    required this.onEnableNotesWidget,
    */super.key});
    
    /*final Function(bool value) onEnableTaskWidget;
    final Function(bool value) onEnableCalendarWidget;
    final Function(bool value) onEnableNotesWidget;
    */SharedPreferences prefs;
    final Function(List<Widget> items) onorderChange;
    final Function(int index) onToggleChange;

  @override
  State<Widgetoptions> createState() => _WidgetoptionsState();
}

class _WidgetoptionsState extends State<Widgetoptions> {
  List<Widget> items = [];
  List<bool> switchValues = [true, true, true];
  bool enableCalendar=true;
  bool enableTasks=false;
  bool enableNotes=false;
  late WidgetList widgets = WidgetList(widgets: items, prefs: widget.prefs);
  
    
  @override
  void initState() {
    loadPrefs();
    items = widgets.getWidgets();
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
              final visibilityState = Provider.of<WidgetVisibilityState>(context);
              return ReorderableListView.builder(
      itemCount: visibilityState.order.length,
      itemBuilder: (context, index) {
        int widgetIndex = visibilityState.order[index];
        return SwitchListTile(
          key: ValueKey(widgetIndex),
          title: Text('${widgetIndex +1}'),
          value: visibilityState.visibility[widgetIndex],
          onChanged: (bool value) {
            visibilityState.toggleVisibility(widgetIndex);
          },
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        visibilityState.reorder(oldIndex, newIndex);
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