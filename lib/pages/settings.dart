// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher/utils/utils.dart';
import 'package:flutter_launcher/widgets/widget_options.dart';
import 'package:installed_apps/app_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

//TODO: Fix all the functions!!

// ignore: must_be_immutable, camel_case_types
class settingeMenu extends StatefulWidget {
  settingeMenu(
    this.prefs, this._app,{
      required this.Toggles,
      super.key
    }
  );
  SharedPreferences prefs;
  final HomeToggles Toggles;
  final List<AppInfo> _app;
  


  @override
  State<settingeMenu> createState() => _settingeMenuState();
}

// ignore: camel_case_types
class _settingeMenuState extends State<settingeMenu> {
  TextEditingController searchProvider = TextEditingController();
  bool statusBarToggle = false;
  bool widgetsEnabled = true;
  bool pinApp = false;
  var applicationIcon;
  var applicationIcon2;
  var applicationIcon3;
  var applicationIcon4;
  var appIconrestored;
  ExpansionTileController widgetTileController = ExpansionTileController();

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
    String? settingAppIcon1 = widget.prefs.getString("appIcon1");
    String? settingAppIcon2 = widget.prefs.getString("appIcon2");
    String? settingAppIcon3 = widget.prefs.getString("appIcon3");
    String? settingAppIcon4 = widget.prefs.getString("appIcon4");

    if (settingAppIcon1 != null){
      appIconrestored = base64Decode(settingAppIcon1);
      var iconAsList1 = Uint8List.fromList(appIconrestored);
      setState(() {
        applicationIcon = iconAsList1;
      });
    }
    if (settingAppIcon2 != null){
      appIconrestored = base64Decode(settingAppIcon2);
      var iconAsList2 = Uint8List.fromList(appIconrestored);
      setState(() {
        applicationIcon2 = iconAsList2;
      });
    }
    if (settingAppIcon3 != null){
      appIconrestored = base64Decode(settingAppIcon3);
      var iconAsList3 = Uint8List.fromList(appIconrestored);
      setState(() {
        applicationIcon3 = iconAsList3;
      });
    }
    if (settingAppIcon4 != null){
      appIconrestored = base64Decode(settingAppIcon4);
      var iconAsList4 = Uint8List.fromList(appIconrestored);
      setState(() {
        applicationIcon4 = iconAsList4;
      });
    }
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

  void setfavorites(appNumber){
    showDialog(context: context, builder: (BuildContext context){
      return  AlertDialog(
        title: const Text("Select a favorite app"),
        actions: [
          SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(shrinkWrap: true, itemCount: widget._app.length, itemBuilder: (context, index){
              AppInfo app = widget._app[index];
              return SizedBox(
                height: 50,
                child: ListTile(
                onTap: () {
                  if (appNumber == 1){
                    final String appName = app.packageName;
                    widget.prefs.setString("Pinned App1", appName);
                    widget.Toggles.pinnedApp(appName, appNumber);
                    setState(() {
                      applicationIcon = app.icon;
                    });
                  } else if (appNumber == 2){
                    final String appName = app.packageName;
                    widget.prefs.setString("Pinned App2", appName);
                    widget.Toggles.pinnedApp(appName, appNumber);
                    setState(() {
                      applicationIcon2 = app.icon;
                    });
                  } else if (appNumber == 3){
                    final String appName = app.packageName;
                    widget.prefs.setString("Pinned App3", appName);
                    widget.Toggles.pinnedApp(appName, appNumber);
                    setState(() {
                      applicationIcon3 = app.icon;
                    });
                  }else if (appNumber == 4){
                    final String appName = app.packageName;
                    widget.prefs.setString("Pinned App4", appName);
                    widget.Toggles.pinnedApp(appName, appNumber);
                    setState(() {
                      applicationIcon4 = app.icon;
                    });
                  }
                  
                  if (app.icon != null){
                    var encodedIcon = base64Encode(app.icon!);
                    widget.prefs.setString("appIcon$appNumber", encodedIcon);
                  }
                  Navigator.pop(context);
                },
                leading: app.icon != null
                  ? Image.memory(app.icon!, height: 30,)
                  : const Icon(Icons.add),
                title: Text(app.name),
                )
              );
            })
          ),
          TextButton(
            onPressed: () {
              widget.prefs.remove("appIcon$appNumber");
              widget.prefs.remove("Pinned App$appNumber");
              String appName = "";
              widget.Toggles.pinnedApp(appName, appNumber);
              setState(() {
                if (appNumber == 1){
                applicationIcon = null;
                } else if (appNumber == 2){
                  applicationIcon2 = null;
                }else if (appNumber == 3){
                  applicationIcon3 = null;
                }else if (appNumber == 4){
                  applicationIcon4 = null;
                }
              });
              
              Navigator.pop(context);
            }, 
            child: const Text("Clear"),
          ),
        ],
      ); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: 
      SizedBox(
        height: 700,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Settings", textScaler: TextScaler.linear(1.5)),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text("Search Engine", textScaler: TextScaler.linear(1.2)),
                ),
                const Spacer(),
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
                              Text(
                                "example:""\n$engine", 
                                style: const TextStyle(fontSize: 12), 
                                textAlign: TextAlign.left
                              ),
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
                              const Expanded(
                                child: Padding(padding: EdgeInsets.only(right: 1)
                                )
                              ),
                              TextButton(
                                onPressed: () {
                                  String provider = searchProvider.text;
                                  widget.Toggles.searchProvider(provider);
                                  widget.prefs.setString("provider", provider);
                                  Navigator.pop(context);
                                }, 
                                child: const Text("Save")
                              ),
                            ],
                          ),
                        ]
                      );
                    });
                  }, 
                  child: const Text("Set Search Engine") 
                ),
              ],
            ),
            SwitchListTile(
              value: statusBarToggle, 
              onChanged: (value) {
                bool toggleStats = value;
                setState(() {
                  statusBarToggle = !statusBarToggle;
                });
                widget.Toggles.toggleStatusBar(toggleStats);
                widget.prefs.setBool('StatusBar', value);
              },
              title: const Text("Hide Status Bar"),
            ),
            ExpansionTile(        //TODO: retain expanded state
              title: const Text("Widgets"),
              subtitle: const Text("Press for widget selection"),
              onExpansionChanged: (value){
                widget.prefs.setBool("WidgetExpanded", value);
              },
              controller: widgetTileController,
              trailing: Switch(
                value: widgetsEnabled, 
                onChanged: (value) {
                  setState(() {
                    widgetsEnabled = !widgetsEnabled;
                  });
                  widget.Toggles.widgetToggle(widgetsEnabled);
                  widget.prefs.setBool('EnableWidgets', value);
                },
              ),
              children: [
                Widgetoptions(widget.prefs),
              ],
            ),
            ExpansionTile(        //TODO: retain expanded state
              title: const Text("Favorites"),
              subtitle: const Text("Press to set favorites"),
              trailing: Switch(
                value: pinApp, 
                onChanged: (value){
                  bool togglePinApp = value;
                  setState(() {
                    pinApp = !pinApp;
                  });
                  widget.Toggles.pinAppToggle(togglePinApp);
                  widget.prefs.setBool("togglePin", value);
                }
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: applicationIcon != null
                        ? Image.memory(applicationIcon!, height: 30,)
                        : const Icon(Icons.add),
                      onTap: (){
                        int appNumber = 1;
                        widget.prefs.setInt("App1", 1);
                        setfavorites(appNumber);
                      }
                    ),
                    const Padding(padding: EdgeInsets.only(right:20)),
                    GestureDetector(
                      child: applicationIcon2 != null
                        ? Image.memory(applicationIcon2!, height: 30,)
                        : const Icon(Icons.add),
                      onTap: (){
                        int appNumber = 2;
                        widget.prefs.setInt("App2", 2);
                        setfavorites(appNumber);
                      },
                    ),
                    const Padding(padding: EdgeInsets.only(right:20)),
                    GestureDetector(
                      child: applicationIcon3 != null
                        ? Image.memory(applicationIcon3!, height: 30,)
                        : const Icon(Icons.add),
                      onTap: (){
                        int appNumber = 3;
                        widget.prefs.setInt("App3", 3);
                        setfavorites(appNumber);
                      },
                    ),
                    const Padding(padding: EdgeInsets.only(right:20)),
                    GestureDetector(
                      child: applicationIcon4 != null
                        ? Image.memory(applicationIcon4!, height: 30,)
                        : const Icon(Icons.add),
                      onTap: (){
                        int appNumber = 4;
                        widget.prefs.setInt("App4", 4);
                        setfavorites(appNumber);
                      },
                    ),
                  ]
                ),
                const Padding(padding: EdgeInsets.only(top: 10))
              ]
            ),
            const ExpansionTile(        //TODO: retain expanded state
              title: Text("Gestures"),
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(right: 25)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Swipe Right"),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 1)
                      ),
                    ),
                    Icon(Icons.add),
                    Padding(padding: EdgeInsets.only(right: 25)),
                  ]
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 25)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Swipe Left"),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 1)
                      ),
                    ),
                    Icon(Icons.add),
                    Padding(padding: EdgeInsets.only(right: 25)),
                  ]
                ),
                Padding(padding: EdgeInsets.only(top: 10))
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    showDialog(context: context, builder: (BuildContext context){
                      bool resetFavorites = false;
                      bool resetSearchEngine = false;
                      bool resettasks = false;
                      bool resetEvents = false;
                      bool resetUI = false;
                      bool resetALL = false;
                      bool resetNotes = false;
                      return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                        return AlertDialog.adaptive(
                          title: const Text("Reset Options"),
                          actionsAlignment: MainAxisAlignment.start,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                           /* SwitchListTile(
                                value: resetFavorites, 
                                onChanged: (value){
                                  setState(() {
                                    resetFavorites = value;
                                  });
                                },
                                title: const Text("Favorites"),
                              ),
                              SwitchListTile(
                                value: resetSearchEngine,
                                onChanged: (value){
                                  setState(() {
                                    resetSearchEngine = value;
                                  });
                                },
                                title:  const Text("Search Engine")
                              ),*/
                              CheckboxListTile(
                                value: resettasks, 
                                onChanged: (value){
                                  setState(() {
                                    resettasks = value!;
                                  });
                                },
                                title: const Text("Tasks"),
                              ),
                              CheckboxListTile(
                                value: resetEvents, 
                                onChanged: (value){
                                  setState(() {
                                    resetEvents = value!;
                                  });
                                },
                                title: const Text("Calendar Events"),
                              ),
                              CheckboxListTile(
                                value: resetNotes, 
                                onChanged: (value){
                                  setState(() {
                                    resetNotes = value!;
                                  });
                                },
                                title: const Text("Notes"),
                              ),
                            /*SwitchListTile(
                                value: resetUI, 
                                onChanged: (value){
                                  setState(() {
                                    resetUI = value;
                                  });
                                },
                                title: const Text("UI Customizations"),
                              ), */
                              CheckboxListTile(
                                value: resetALL, 
                                onChanged: (value){
                                  setState(() {
                                    resetALL = value!;
                                    resetUI = value;
                                    resetEvents = value;
                                    resettasks = value;
                                    resetSearchEngine = value;
                                    resetFavorites = value;
                                    resetNotes = value;
                                  });
                                },
                                title: const Text("RESET EVERYTHING"),
                              ),
                            ],
                          ),
                          actions: [
                            Row(
                              children: [
                                TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  }, 
                                  child: const Text("Cancel")
                                ),
                                const Expanded(child: Padding(padding: EdgeInsets.only(right: 1))),
                                TextButton(
                                  onPressed: (){
                                    if (resetFavorites == true){
                                      widget.prefs.remove("appIcon");
                                      widget.prefs.remove("togglePin");
                                      widget.prefs.remove("App1");
                                      widget.prefs.remove("App2");
                                      widget.prefs.remove("App3");
                                      widget.prefs.remove("App4");
                                      widget.prefs.remove("Pinned App1");
                                      widget.prefs.remove("Pinned App2");
                                      widget.prefs.remove("Pinned App3");
                                      widget.prefs.remove("Pinned App4");
                                    } else if (resetSearchEngine == true){
                                      widget.prefs.remove("provider");
                                    } else if (resettasks == true){
                                      widget.prefs.remove("Tasks");
                                      widget.prefs.remove("Restore Checkbox");
                                    } else if (resetUI){
                                      widget.prefs.remove("StatusBar");
                                      widget.prefs.remove("EnableWidgets");
                                      widget.prefs.remove("togglePin");
                                    } else if(resetEvents == true){
                                      widget.prefs.remove("Events");
                                    } else if (resetNotes == true){
                                      widget.prefs.remove("Note");
                                    } else if(resetALL == true){
                                      widget.prefs.clear();
                                    }
                                    Navigator.pop(context);
                                  }, 
                                  child:const Text("RESET")
                                ),
                              ],
                            )
                          ],
                        );
                      });
                    });
                  },
                  child: const Text("Reset"),
                ),
                const Expanded(child: Padding(padding: EdgeInsets.only(left: 1))),
              ],
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)), 
          ],
        )
      )
    );     
  }
}