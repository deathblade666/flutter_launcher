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
  final void Function(String appName, int appNumber) onPinnedApp;
  final void Function(bool togglePinApp) ontogglePinApp;
  SharedPreferences prefs;
  final List<AppInfo> _app;
  


  @override
  State<settingeMenu> createState() => _settingeMenuState();
}

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
              return Container(
                height: 50,
                child: ListTile(
                onTap: () {
                  if (appNumber == 1){
                    final String appName = app.packageName;
                    widget.prefs.setString("Pinned App1", appName);
                    widget.onPinnedApp(appName, appNumber);
                    setState(() {
                      applicationIcon = app.icon;
                    });
                  } else if (appNumber == 2){
                    final String appName = app.packageName;
                    widget.prefs.setString("Pinned App2", appName);
                    widget.onPinnedApp(appName, appNumber);
                    setState(() {
                      applicationIcon2 = app.icon;
                    });
                  } else if (appNumber == 3){
                    final String appName = app.packageName;
                    widget.prefs.setString("Pinned App3", appName);
                    widget.onPinnedApp(appName, appNumber);
                    setState(() {
                      applicationIcon3 = app.icon;
                    });
                  }else if (appNumber == 4){
                    final String appName = app.packageName;
                    widget.prefs.setString("Pinned App4", appName);
                    widget.onPinnedApp(appName, appNumber);
                    setState(() {
                      applicationIcon4 = app.icon;
                    });
                    var encodedIcon = base64Encode(app.icon!);
                    widget.prefs.setString("appIcon4", encodedIcon);
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

                //TODO: Set visbility based on number of favorite set
                //TODO: pass icon of selected app to replace the + sign in settings menu

                )
              );
            })
          ),
        ],
      ); 
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Text("UI Options", textScaler: TextScaler.linear(1.5),),
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
              title: const Text("Toggle Favorites"),
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
            Visibility(
              visible: pinApp,
              child: const Text("Favorites", textScaler: TextScaler.linear(1.5),)
            ),
            Visibility(
              visible: pinApp,
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
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
                        )
                      ]
                    )
                  ),
                ]
              )
            ),
            Visibility(
              visible: pinApp,
              child: const Divider(),),
            const Center(
              child: Text("Search Options", textScaler: TextScaler.linear(1.5),)
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
            const Align(
              alignment: Alignment.center,
              child: Text("Gesture Options", textScaler: TextScaler.linear(1.5),),
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            const Row(
              children: [
                Padding(padding: EdgeInsets.only(right: 25)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Swipe Right"),
                ),
                Expanded(
                  child: Padding(padding: EdgeInsets.only(right: 1)
                  ),
                ),
                Icon(Icons.add),
                Padding(padding: EdgeInsets.only(right: 25)),
              ]
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            const Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 25)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Swipe Left"),
                ),
                Expanded(
                  child: Padding(padding: EdgeInsets.only(right: 1)
                  ),
                ),
                Icon(Icons.add),
                Padding(padding: EdgeInsets.only(right: 25)),
              ]
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
                  child: const Text("Save"),
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
            
            
               //   const Align(
               //     alignment: Alignment.centerLeft, 
               //     child: Padding(
              //        padding: EdgeInsets.only(left: 13),
               //       child: Text("Select a Quick Access App"),
                //      ) 
                    
                //  ),
                //  const Expanded(child: Padding(padding: EdgeInsets.only(right: 1))),
               //   GestureDetector(
               // child: Container(
                //  height: 50,
                //  width: 50,
                //  decoration: BoxDecoration(
                //    border: Border.all(
                //      color: Theme.of(context).colorScheme.onSurface
                 //   )
                 // ),
                //),
                //onTap: (){
                //  showDialog(context: context, builder: (BuildContext context){
                //    return  
                    //AlertDialog(
                    //  title: Text("Pin app to Search Bar"),
                    //  actions: [
                    //    SizedBox(
                    //      height: 300,
                    //      width: 300,
                    //      child: ListView.builder(shrinkWrap: true, itemCount: widget._app.length, itemBuilder: (context, index){
                    //        AppInfo app = widget._app[index];
                    //        return Container(
                    //          height: 50,
                    //          child: ListTile(
                    //            onTap: () {
                    //              final String appName = app.packageName;
                    //              widget.prefs.setString("Pinned App", appName);
                    //              if (app.icon != null){
                    //                var encodedIcon = base64Encode(app.icon!);
                    //                widget.prefs.setString("appIcon", encodedIcon);
                    //              }
                    //              widget.onPinnedApp(appName);
                    //              Navigator.pop(context);
                    //            },
                    //          leading: app.icon != null
                    //            ? Image.memory(app.icon!, height: 30,)
                    //            : const Icon(Icons.android),
                    //          title: Text(app.name),
                    //          )
                    //        );
                    //      })
                    //    ),
                    //  ],
                  //  ); 
                 // });
                //},
             // ),
             // const Padding(padding: EdgeInsets.only(right: 30)),
           // ],
          //),
        //),
              
                
                
            //Visibility(
             // visible: pinApp,
              //child: 
                 // Column(
                   // children: [
                      //const Text("Select your Favorite Apps"),
                      
            
            
              
              
         //   );
              //    }//);),
          