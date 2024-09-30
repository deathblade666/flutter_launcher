// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher/pages/settings.dart';
import 'package:flutter_launcher/widgets/calendar.dart';
import 'package:flutter_launcher/widgets/notes.dart';
import 'package:flutter_launcher/widgets/tasks.dart';
import 'package:flutter_launcher/widgets/utils/widget_utils.dart';
import 'package:flutter_launcher/widgets/widget_options.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:flutter/services.dart';
import 'package:one_clock/one_clock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';




// ignore: must_be_immutable, camel_case_types
class launcher extends StatefulWidget {
  launcher(this.prefs,{super.key});
  SharedPreferences prefs;
  

  @override
  State<StatefulWidget> createState() => _launcherState();
}

  void onClosed(){
  
  }
  


// ignore: camel_case_types
class _launcherState extends State<launcher>{
  bool enabeBottom = true;
  bool showAppList = false;
  final TextEditingController _searchController = TextEditingController();
  List<String> installedApps = [];
  List<AppInfo> _filteredItems = [];
  List<AppInfo> _app = [];
  bool hideDateTime = true;
  FocusNode focusOnSearch = FocusNode();
  String date = "";
  bool handle = true;
  bool hideDate = true;
  bool hideMainGesture = true;
  static const platform = MethodChannel('notification_shade');
  String weekDay = formatDate(DateTime.now(),[DD,]);
  String monthDay = formatDate(DateTime.now(),[MM, ' ', d]);
  String engine = "";
  // ignore: prefer_typing_uninitialized_variables
  var _tapPosition;
  bool widgetVis = true;
  String pinnedAppInfo = "";
  String pinnedAppInfo2 = "";
  String pinnedAppInfo3 = "";
  String pinnedAppInfo4 = "";
  // ignore: prefer_typing_uninitialized_variables
  var appIconrestored;
  // ignore: prefer_typing_uninitialized_variables
  var appIcon;
  // ignore: prefer_typing_uninitialized_variables
  var appIcon2;
  // ignore: prefer_typing_uninitialized_variables
  var appIcon3;
  // ignore: prefer_typing_uninitialized_variables
  var appIcon4;
  bool noAppPinned = false;
  double searchHieght = 40;
  // ignore: prefer_typing_uninitialized_variables
  var appNumber;
  String appName ="";
  bool hideIcon1 = false;
  bool hideIcon2 = false;
  bool hideIcon3 = false;
  bool hideIcon4 = false;
  bool enableTasks = false;
  bool showAddWidgettext = true;
  bool enableCalendar = false;
  bool enableNotes = false;
  final PageController _pageController = PageController(initialPage: 1, keepPage: false); 
  List<Widget> initialItems = [];
  var widgetProvider;

 focusListener(){
    if (focusOnSearch.hasFocus){
      setState(() {
        handle = false;
      });
    } else if (!focusOnSearch.hasFocus){
      setState(() {
        handle = true;
      });
    }
  }

  @override
  void initState(){
    _tapPosition = const Offset(0.0, 0.0);
    super.initState();
    fetchApps();
    loadPrefs();
    widgetProvider = WidgetList(widgets: [], prefs: widget.prefs);
    initialItems = widgetProvider.getWidgets();
    focusOnSearch.addListener(focusListener);
  }

  void loadPrefs() {
    widget.prefs.reload();
    String? provider = widget.prefs.getString('provider');
    bool? toggleStats = widget.prefs.getBool('StatusBar');
    bool? widgetsEnabled = widget.prefs.getBool("EnableWidgets");
    String? appIconEncoded = widget.prefs.getString("appIcon");
    bool? togglePinApp = widget.prefs.getBool("togglePin");
    int? appNumber1 = widget.prefs.getInt("App1");
    int? appNumber2 = widget.prefs.getInt("App2");
    int? appNumber3 = widget.prefs.getInt("App3");
    int? appNumber4 = widget.prefs.getInt("App4");
    String? appName1 = widget.prefs.getString("Pinned App1");
    String? appName2 = widget.prefs.getString("Pinned App2");
    String? appName3 = widget.prefs.getString("Pinned App3");
    String? appName4 = widget.prefs.getString("Pinned App4");
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
    
    if (togglePinApp != null){
      pinAppToggle(togglePinApp);
    }
    
    if (provider != null){
      searchProvider(provider);
    } else {
      provider = "duckduckgo.com/?q=";
      searchProvider(provider);
    }
    if (toggleStats != null) {
      toggleStatusBar(toggleStats);
    }
    if (widgetsEnabled != null){
      widgetToggle(widgetsEnabled);
    }
    if (appNumber1 != null && appName1 != null){
      appNumber = appNumber1;
      appName = appName1;
      pinnedApp(appName, appNumber);
      hideIcon1 = true;
    } else {
      hideIcon1 = false;
    }
    if (appNumber2 != null && appName2 != null){
      appNumber = appNumber2;
      appName = appName2;
      pinnedApp(appName, appNumber);
      hideIcon2 = true;
    } else {
      hideIcon2 = false;
    }
    if (appNumber3 != null && appName3 != null){
      appName = appName3;
      appNumber = appNumber3;
      pinnedApp(appName, appNumber);
      hideIcon3 = true;
    } else {
      hideIcon3 = false;
    }
    if (appNumber4 != null && appName4 != null){
      appName = appName4;
      appNumber = appNumber4;
      pinnedApp(appName, appNumber);
      hideIcon4 = true;
    } else {
      hideIcon4 = false;
    }
    if (appIconEncoded != null){
      appIconrestored = base64Decode(appIconEncoded);
      var iconAsList = Uint8List.fromList(appIconrestored);
      restoreAppIcon(iconAsList);
    }
    if (togglePinApp == true && appName4 == null && appName2 == null && appName3 == null && appName1 == null){
      setState(() {
        searchHieght = 40;
      });
      
    }
  }

  void fetchApps() async {
    List<AppInfo> apps = await InstalledApps.getInstalledApps(true,true);
    setState(() {
      installedApps = apps.map((app) => app.name).toList();
      _app = apps;
      _filteredItems = _app;
    });
  }

  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  void enableSheet(DragStartDetails) {
    setState(() {
      enabeBottom = !enabeBottom;
    });
  }

  void pinAppToggle (togglePinApp){
    setState(() {
      noAppPinned = togglePinApp;
      if (noAppPinned == true && hideIcon1 == false && hideIcon2 == false && hideIcon3 == false && hideIcon4 == false){
        searchHieght = 40;
      } else if (noAppPinned == true && widgetVis == false) {
        searchHieght = 57;
      } else if (widgetVis == true && noAppPinned == false) {
        searchHieght = 40;
      } else if (noAppPinned == true && widgetVis == true) {
        searchHieght = 87;
      } else {
        searchHieght = 40;
      }
    });
  }

  @override
  void dispose() {
    focusOnSearch.dispose();
    focusOnSearch.removeListener(focusListener);
    super.dispose();
  }

  void searchProvider(provider){
    setState(() {
      engine = provider;
    });
  }

  void toggleStatusBar(toggleStats){
    if (toggleStats == true) {
      setState(() {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
      });
    } else if (toggleStats == false){
      setState(() {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
        SystemUiOverlay.bottom,
        SystemUiOverlay.top
        ]);
      });
    }
  }
  void widgetToggle(widgetsEnabled) {
      setState(() {
        widgetVis = widgetsEnabled;
        if (noAppPinned == true && widgetVis == true) {
          searchHieght = 87;
        } else if (noAppPinned == false && widgetVis == true) {
          searchHieght = 40;
        } else if (widgetVis == false && noAppPinned == true) {
          searchHieght = 57;
        } else {
          searchHieght = 40;
        }
      });
  }

  void pinnedApp(String appName, int appNumber) async {
      if (appNumber == 1 && appName != ""){
        AppInfo app = await InstalledApps.getAppInfo(appName);
        setState(() {
          pinnedAppInfo = appName;
          appIcon = app.icon;
          hideIcon1 = true;
        });
      } else if (appNumber == 2 && appName != "") {
        AppInfo app = await InstalledApps.getAppInfo(appName);
        setState(() {
          pinnedAppInfo2 = appName;
          appIcon2 = app.icon;
          hideIcon2 = true;
        });
      } else if (appNumber == 3 && appName != ""){
        AppInfo app = await InstalledApps.getAppInfo(appName);
        setState(() {
          pinnedAppInfo3 = appName;
          appIcon3 = app.icon;
          hideIcon3 = true;
        });
      } else if (appNumber == 4 && appName != ""){
        AppInfo app = await InstalledApps.getAppInfo(appName);
        setState(() {
          pinnedAppInfo4 = appName;
          appIcon4 = app.icon;
          hideIcon4 = true;
        });
      }else {
        if (appNumber == 1 && appName == ""){
          setState(() {
            appIcon = null;
            hideIcon1 = false;
          });
        } else if (appNumber == 2 && appName == ""){
          setState(() {
            appIcon2 = null;
            hideIcon2 = false;
          });
        } else if (appNumber == 3 && appName == ""){
          setState(() {
            appIcon3 = null;
            hideIcon3 = false;
          });
        } else if (appNumber == 4 && appName == ""){
          setState(() {
            appIcon4 = null;
            hideIcon4 = false;
          });
        }
      }
      if (widgetVis == true && noAppPinned == true){
        setState(() {
          searchHieght = 87;
        }); 
      }else if (noAppPinned == true && widgetVis == false){
        setState(() {
          searchHieght = 57;
        });
      }
      if (noAppPinned == true && hideIcon1 == false && hideIcon2 == false && hideIcon3 == false && hideIcon4 == false){
      setState(() {
        searchHieght = 40;
      });
    }
  }

  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  void restoreAppIcon(Uint8List){
    appIcon = appIconrestored;
  }

  void updatewidgetList (items) {
    setState((){ 
      initialItems=items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        bottomSheet: BottomSheet(
          onClosing: onClosed, 
          builder: (BuildContext context){
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: widgetVis,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [ 
                        Icon(Icons.keyboard_arrow_up, size: 30,),
                      ],
                    ), 
                    //TODO: Allow changing widget order
                    onVerticalDragStart: (details) {
                      showModalBottomSheet<void>(isScrollControlled: true ,showDragHandle: true ,context: context, builder: (BuildContext context) {
                        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) { 
                          void enableCalendarWidget (value){
                            setState(() {
                              enableCalendar = value;     
                            });
                          }
                          void enableTaskWidget (value){
                            setState(() {
                              enableTasks = value;
                            });
                          }
                          void enableNotesWidget (value){
                            setState(() {
                              enableNotes = value;
                            });
                          }
                          return Padding(
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: SizedBox(
                              height: 500,
                              child: PageView(
                                controller: _pageController,
                                children: [
                                  Text('$initialItems'),
                                  Widgetoptions(widget.prefs, onorderChange: updatewidgetList),
                                  ...initialItems,
                                ]
                              )
                            )
                          );
                        });
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: noAppPinned,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: hideIcon1,
                        child: IconButton(
                          onPressed: () {
                            InstalledApps.startApp(pinnedAppInfo);
                          },
                          icon: appIcon != null 
                            ? Image.memory(appIcon, height: 30,)
                            : const Icon(Icons.android),
                        ), 
                      ),
                      Visibility(
                        visible: hideIcon2,
                        child: IconButton(
                          onPressed: () {
                            InstalledApps.startApp(pinnedAppInfo2);
                          },
                          icon: appIcon2 != null 
                            ? Image.memory(appIcon2, height: 30,)
                            : const Icon(Icons.android),
                        ), 
                      ),
                      Visibility(
                        visible: hideIcon3,
                        child: IconButton(
                          onPressed: () {
                            InstalledApps.startApp(pinnedAppInfo3);
                          },
                          icon: appIcon3 != null 
                            ? Image.memory(appIcon3, height: 30,)
                            : const Icon(Icons.android),
                        ),
                      ),
                      Visibility(
                        visible: hideIcon4,
                        child: IconButton(
                          onPressed: () {
                            InstalledApps.startApp(pinnedAppInfo4);
                          },
                          icon: appIcon4 != null 
                            ? Image.memory(appIcon4, height: 30,)
                            : const Icon(Icons.android_outlined),
                        ),
                      ), 
                    ],
                  )
                )
              ]
            );
          }
        ),
        body: Column(
          verticalDirection: VerticalDirection.up,
          children: [
            Padding(padding: EdgeInsets.only(bottom: searchHieght)),
            Container( 
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: SearchBar(
                focusNode: focusOnSearch,
                constraints: const BoxConstraints(
                  maxHeight: 40,
                  minHeight: 40
                ),
                elevation: const WidgetStatePropertyAll(0.0),
                onChanged: (String value) async {
                  String s = _searchController.text;
                  setState(() {
                    _filteredItems = _app.where(
                      (_app) => _app.name.toLowerCase().contains(s.toLowerCase()),
                      ).toList();
                      if (value.isNotEmpty){
                        showAppList = true;
                        hideDate = false;
                        hideMainGesture = false;
                      } else {
                        showAppList=false;
                        hideDate = true;
                      }
                    });
                },
                onTapOutside: (value){
                  focusOnSearch.unfocus();
                },
                onSubmitted: (String value) async {
                  List<AppInfo> apps = await InstalledApps.getInstalledApps();
                  String userInput = _searchController.text.toLowerCase();
                  List<AppInfo> matchedApps = apps.where(
                    (app) => app.name.toLowerCase().contains(userInput),
                    ).toList();

                  if (matchedApps.isNotEmpty) {
                    InstalledApps.startApp(matchedApps.first.packageName);
                  } else if  (userInput.isURL()) {
                    String inputURL = "https://$userInput";
                      final Uri url = Uri.parse(inputURL);
                      await launchUrl(url);
                  } else { 
                    // ignore: non_constant_identifier_names
                    String Search = "https://$engine$userInput";
                    final Uri searchURL = Uri.parse(Search);
                    await launchUrl(searchURL);
                  }
                  _searchController.clear();
                  setState(() {
                    showAppList = false;
                    hideMainGesture = true;
                    hideDate = true;
                  });
                },
                controller: _searchController,
                onTap: () {
                  if (_searchController.text != ""){
                    String s = _searchController.text;
                    setState(() {
                      _filteredItems = _app.where(
                        (_app) => _app.name.toLowerCase().contains(s.toLowerCase()),
                      ).toList();
                        showAppList = true;
                        hideDate = false;
                        hideMainGesture = false;
                    });
                  } else{
                    setState(() {
                      showAppList = !showAppList;
                      hideDate = !hideDate;
                      hideMainGesture = !hideMainGesture;
                    });
                  }
                },
              )
            ),
            Visibility(
              visible: showAppList,
              child: Expanded(
                child: ListView.builder( reverse: true, shrinkWrap: true, itemCount: _filteredItems.length, itemBuilder: (context, index){
                  AppInfo app = _filteredItems[index];
                  return SizedBox(
                    height: 50,
                    child: ListTile(
                      onTap: () {
                        focusOnSearch.unfocus();
                        _searchController.text = "";
                        InstalledApps.startApp(app.packageName);
                        setState(() {
                          showAppList = false;
                        });
                      },
                      leading: app.icon != null
                        ? Image.memory(app.icon!, height: 30,)
                        : const Icon(Icons.android),
                      title: Text(app.name),
                    )
                  );
                })
              )
            ),
            const Padding(padding: EdgeInsets.all(3)),
            Visibility(
              visible: hideDate,
              child: IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        '$weekDay\n$monthDay',
                        textScaler: MediaQuery.textScalerOf(context),
                        style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20), 
                      ),
                    ),
                    const Expanded(child: Padding(padding: EdgeInsets.all(1))),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.primary,
                      thickness: 1.5,
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 2),
                     child: DigitalClock(
                        digitalClockTextColor: Theme.of(context).colorScheme.primary,
                        datetime: DateTime.now(),
                        showSeconds: false,
                        textScaleFactor: 1.8,
                        format: "h:mm",
                      ),
                    ),
                  ],
                ),
              )
            ),
            Visibility(
              visible: hideMainGesture,
              child: Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (TapDownDetails details){
                    setState(() {
                      _tapPosition = details.globalPosition;
                    });
                  },
                  onLongPress: () async {
                    double left = _tapPosition.dx - 110;
                    double top = _tapPosition.dy;
                    double right = _tapPosition.dx;
                    await showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(left, top, right, 0),
                      items: [
                        PopupMenuItem(
                          child: const Text("Settings"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => settingeMenu(onProviderSet: searchProvider, widget.prefs, onStatusBarToggle: toggleStatusBar, enableWidgets: widgetToggle, _app, onPinnedApp: pinnedApp,ontogglePinApp: pinAppToggle,onClear: pinnedApp,)),
                            );
                          },
                        )
                      ]
                    );
                  },
                  onTap: (){
                    focusOnSearch.unfocus();
                  },
                  onVerticalDragUpdate: (details) async {
                    int sensitivity = 3;
                    if (details.delta.dy > sensitivity) {
                      await platform.invokeMethod('openNotificationShade');
                    } else if (details.delta.dy < sensitivity) {
                      focusOnSearch.requestFocus();
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    int sensitivity = 2;
                    if (details.delta.dx > sensitivity){
                      showDialog(context: context, builder: (BuildContext context){
                      return const AlertDialog(
                        title: Text("You swiped Right!"),
                      );
                    });
                    } else if (details.delta.dx < sensitivity) {
                      showDialog(context: context, builder: (BuildContext context){
                        return const AlertDialog(
                          title: Text("You swiped Left!"),
                        );
                      });
                    }
                  },
                )
              )
            )
          ]
        )
      )
    );
  }
}