import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher/pages/home.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';

class settingeMenu extends StatefulWidget {
  settingeMenu(this.prefs, this._app,{ required this.onPinnedApp ,required this.enableWidgets, required this.onStatusBarToggle,required this.onProviderSet,super.key});
  final void Function(String provider) onProviderSet;
  final void Function(bool toggleStats) onStatusBarToggle;
  final void Function(bool widgetsEnabled) enableWidgets;
  final void Function(String appName) onPinnedApp;
  SharedPreferences prefs;
  List<AppInfo> _app;


  @override
  State<settingeMenu> createState() => _settingeMenuState();
}

class _settingeMenuState extends State<settingeMenu> {
  TextEditingController searchProvider = TextEditingController();
  bool statusBarToggle = false;
  bool widgetsEnabled = true;
  @override
  initState(){
    onLoad();
    super.initState();
  }

  void onLoad() {
    widget.prefs.reload();
    bool? toggelStatslast = widget.prefs.getBool("StatusBar");
    bool? widgetsEnabledlast = widget.prefs.getBool("EnableWidgets");
    if (toggelStatslast != null) {
      setState(() {
        statusBarToggle = toggelStatslast;
      });
    }
    if (widgetsEnabledlast != null){
      setState(() {
        widgetsEnabled = widgetsEnabledlast;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Text("UI Options"),
            SwitchListTile(
              value: widgetsEnabled,
              title: const Text("Enable Widgets"),
              onChanged: (value) {
                setState(() {
                  widgetsEnabled = !widgetsEnabled;
                });
                widget.enableWidgets(widgetsEnabled);
                widget.prefs.setBool('EnableWidgets', value);
              }
            ),
            SwitchListTile(
              value: statusBarToggle, 
              onChanged: (value) {
                bool toggleStats = value;
                setState(() {
                  statusBarToggle = !statusBarToggle;
                });
                widget.onStatusBarToggle(toggleStats);
                widget.prefs.setBool('StatusBar', value);
              },
              title: const Text("Hide Status Bar"),
            ),
            const Divider(),
            const Center(
              child: Text("Search Options"),
            ),
            TextButton(
              onPressed: () {
                widget.prefs.reload();
                String? engine = widget.prefs.getString("provider");
                engine ??= "duckduckgo.com/?q=";
                showDialog(context: context, builder: (BuildContext context){
                  return AlertDialog(
                    title: const Text("Enter Search Provider URL", style: TextStyle(fontSize: 15),),
                    actions: [
                      Row(
                        children: [
                          Text("example:"+"\n$engine", style: const TextStyle(fontSize: 12), textAlign: TextAlign.left,),
                        ],
                      ),
                      TextField(
                        controller: searchProvider,
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            }, 
                            child: const Text("Cancel")
                          ),
                          const Expanded(child: Padding(padding: EdgeInsets.only(right: 1))),
                          TextButton(
                            onPressed: () {
                              String provider = searchProvider.text;
                              widget.onProviderSet(provider);
                              widget.prefs.setString("provider", provider);
                              Navigator.pop(context);
                            }, 
                            child: const Text("Save")
                          ),
                        ],
                      ),
                    ],
                  );
                });
              }, 
              child: const Align(
                alignment: Alignment.centerLeft, 
                child: Text("Set Custom Search Provider")
              )
            ),
            const Divider(),
            const Text("Favorites"),
            Align(
              alignment: Alignment.centerLeft, 
              child: TextButton(
                onPressed: () {
                  showDialog(context: context, builder: (BuildContext context){
                    return  AlertDialog(
                      title: Text("Pin app to Search Bar"),
                      actions: [
                        SizedBox(
                          height: 300,
                          width: 300,
                          child: ListView.builder(shrinkWrap: true, itemCount: widget._app.length, itemBuilder: (context, index){
                          AppInfo app = widget._app[index];
                            return Container(
                              height: 50,
                              child: ListTile(
                                onTap: () {
                                  final String appName = app.packageName;
                                  print(appName);
                                  widget.prefs.setString("Pinned App", appName);
                                  if (app.icon != null){
                                    var encodedIcon = base64Encode(app.icon!);
                                    widget.prefs.setString("appIcon", encodedIcon);
                                  }
                                  widget.onPinnedApp(appName);
                                  Navigator.pop(context);
                                },
                                leading: app.icon != null
                                  ? Image.memory(app.icon!, height: 30,)
                                  : const Icon(Icons.android),
                                  title: Text(app.name),
                              )
                            );
                        })
                      )
                      ],
                    );
                  });
                }, 
                child: Text("Select your pinned app"))
            ),
            const Divider(),

            Row(
              children: [
                TextButton(
                  onPressed: () {
                    widget.prefs.clear();
                  }, 
                  child: const Text("Reset")
                ),
                const Expanded(child: Padding(padding: EdgeInsets.all(1))),
                TextButton(
                  child: Text("Save"),
                  onPressed: () {
                      Navigator.pop(context);
                  },
                ),
              ],
            )      
          ],
        )
      )
    );
  }
}