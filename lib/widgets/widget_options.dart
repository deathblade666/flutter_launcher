import 'package:flutter/material.dart';
import 'package:flutter_launcher/widgets/utils/widget_utils.dart';
import 'package:flutter_launcher/widgets/utils/widgetchangenotifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Widgetoptions extends StatefulWidget {
  Widgetoptions(this.prefs,{super.key});
    SharedPreferences prefs;

  @override
  State<Widgetoptions> createState() => _WidgetoptionsState();
}

class _WidgetoptionsState extends State<Widgetoptions> {
  List<Widget> items = [];
  late WidgetList widgets = WidgetList(widgets: items, prefs: widget.prefs);
  
  @override
  void initState() {
    loadPrefs();
    items = widgets.getWidgets();
    super.initState();
  }

  void loadPrefs() async {
    widget.prefs.reload();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox( 
      height: 180, 
      width: 350,
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                final visibilityState = Provider.of<WidgetVisibilityState>(context);
                return ReorderableListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: visibilityState.order.length,
                  itemBuilder: (context, index) {
                    int widgetIndex = visibilityState.order[index];
                    return SwitchListTile(
                      key: ValueKey(widgetIndex),
                      title: Text(visibilityState.names[widgetIndex]),
                      value: visibilityState.visibility[widgetIndex],
                      onChanged: (bool value) {
                        setState(() {
                          visibilityState.toggleVisibility(widgetIndex);
                        });
                      },
                      secondary: const Icon(Icons.menu_outlined),
                    );
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      visibilityState.reorder(oldIndex, newIndex);
                    });
                  },
                );
              }
            )
          ),
        ],
      )
    );
  }
}