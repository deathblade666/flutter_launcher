import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher/pages/home.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';

class settingeMenu extends StatefulWidget {
  settingeMenu(this.prefs, this._app,{required this.ontogglePinApp,required this.onPinnedApp ,required this.enableWidgets, required this.onStatusBarToggle,required this.onProviderSet,super.key});
  final void Function(String provider) onProviderSet;
  final void Function(bool toggleStats) onStatusBarToggle;
  final void Function(bool widgetsEnabled) enableWidgets;
  final void Function(String appName) onPinnedApp;
  final void Function(bool togglePinApp) ontogglePinApp;
  SharedPreferences prefs;
  List<AppInfo> _app;
  


  @override
  State<settingeMenu> createState() => _settingeMenuState();
}

class _settingeMenuState extends State<settingeMenu> {
  TextEditingController searchProvider = TextEditingController();
  bool statusBarToggle = false;
  bool widgetsEnabled = true;
  bool pinApp = false;
  @override
  initState(){
    onLoad();
    super.initState();
  }

  void onLoad() {
    widget.prefs.reload();
    bool? toggelStatslast = widget.prefs.getBool("StatusBar");
    bool? widgetsEnabledlast = widget.prefs.getBool("EnableWidgets");
    bool? pinApprestore = widget.prefs.getBool("togglePin");
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
    if (pinApprestore != null){
      setState(() {
        pinApp = pinApprestore;
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
            SwitchListTile(
              title: Text("Toggle Favorites"),
              value: pinApp, 
              onChanged: (value){
                bool togglePinApp = value;
                setState(() {
                  pinApp = !pinApp;
                });
                widget.ontogglePinApp(togglePinApp);
                widget.prefs.setBool("togglePin", value);
              }
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
            Visibility(
              visible: pinApp,
              child: const Divider(),),
            Visibility(
              visible: pinApp,
              child: const Text("Favorites"),
            ),
            Visibility(
              visible: pinApp,
              child:  Row(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft, 
                    child: Padding(
                      padding: EdgeInsets.only(left: 13),
                      child: Text("Select a Quick Access App"),
                      ) 
                    
                  ),
                  const Expanded(child: Padding(padding: EdgeInsets.only(right: 1))),
                  GestureDetector(
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface
                    )
                  ),
                ),
                onTap: (){
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
                        ),
                      ],
                    ); 
                  });
                },
              ),
              const Padding(padding: EdgeInsets.only(right: 30)),
            ],
          ),
        ),
              
                
                
            Visibility(
              visible: pinApp,
              child: Column(
                children: [
              const Text("Select your Favorite Apps"),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface
                        )
                      ),
                    ),
                    onTap: (){
                      return log("Test");
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(right:20)),
                  GestureDetector(
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface
                        )
                      ),
                    ),
                    onTap: (){
                      return log("Test");
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(right:20)),
                  GestureDetector(
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface
                        )
                      ),
                    ),
                    onTap: (){
                      return log("Test");
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(right:20)),
                  GestureDetector(
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface
                        )
                      ),
                    ),
                    onTap: (){
                      return log("Test");
                    },
                  )
                ]
              )
              )
                ]
              )
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