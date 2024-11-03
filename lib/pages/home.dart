
import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher/modals/applist.dart';
import 'package:flutter_launcher/modals/pageview.dart';
import 'package:flutter_launcher/modals/widgets/utils/favorites.dart';
import 'package:flutter_launcher/utils/bottomsheet.dart';
import 'package:flutter_launcher/utils/ui_toggles.dart';
import 'package:flutter_launcher/modals/widgets/utils/widget_utils.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:flutter/services.dart';
import 'package:one_clock/one_clock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

class launcher extends StatefulWidget {
  launcher(this.prefs,{super.key});
  SharedPreferences prefs;
  

  @override
  State<StatefulWidget> createState() => _launcherState();
}

  void onClosed(){
  
  }

class _launcherState extends State<launcher>{
  //late double searchHeight; 
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
  var _tapPosition;
  bool widgetVis = true;
  String pinnedAppInfo = "";
  String pinnedAppInfo2 = "";
  String pinnedAppInfo3 = "";
  String pinnedAppInfo4 = "";
  var appIconrestored;
  var appIcon;
  var appIcon2;
  var appIcon3;
  var appIcon4;
  bool noAppPinned = false;
  double searchHieght = 0.0;
  var appNumber;
  String appName ="";
  bool hideIcon1 = false;
  bool hideIcon2 = false;
  bool hideIcon3 = false;
  bool hideIcon4 = false;
  List<Widget> initialItems = [];
  late WidgetList widgets = WidgetList(widgets: initialItems, prefs: widget.prefs);
  List<bool> visibilityStates = [true, true, true, true];
  int lastPage = 0;

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
    initialItems = widgets.getWidgets();
    focusOnSearch.addListener(focusListener);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Calculate initial height here instead
    updateSearchHeight();
  }

  void loadPrefs() async {
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
    WidgetList widgets = WidgetList(widgets: [], prefs: widget.prefs);
    await widgets.loadWidgets();
    setState(() {
     initialItems = widgets.widgets;
    });
  }

  void fetchApps() async {
    List<AppInfo> apps = await InstalledApps.getInstalledApps(true,true);
    setState(() {
      installedApps = apps.map((app) => app.name).toList();
      _app = apps;
      _filteredItems = _app;
    });
  }

  void enableSheet(DragStartDetails) {
    setState(() {
      enabeBottom = !enabeBottom;
    });
  }

  void pinAppToggle (togglePinApp){
    setState(() {
      noAppPinned = togglePinApp;
      updateSearchHeight();
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
      updateSearchHeight();
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
    } else {
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
  }
  

  void restoreAppIcon(Uint8List){
    appIcon = appIconrestored;
  }

  void AppTapped (showAppList1, hideDate1, hideMainGesture1) async {
    setState(() {
      showAppList = showAppList1;
      hideDate = hideDate1;
      hideMainGesture = hideMainGesture1;
    });
    await Future.delayed(const Duration(seconds: 3));
    fetchApps();
  }

  void updateSearchHeight() {
    setState(() {
      searchHieght = BottomSheetLayoutHelper.calculateSearchPadding(
        context: context,
        isArrowVisible: widgetVis,
        isFavoritesVisible: noAppPinned,
        hasApps: noAppPinned,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        bottomSheet: LayoutBuilder(
          builder: (context, constraints) {
            final dynamicHeight = BottomSheetLayoutHelper.calculateSearchPadding(
              context: context,
              isArrowVisible: widgetVis,
              isFavoritesVisible: noAppPinned,
              hasApps: noAppPinned,
            );
            searchHieght = dynamicHeight; 
            return BottomSheet(
              onClosing: onClosed,
              builder: (BuildContext context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: widgetVis,
                      maintainSize: false,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [ 
                            Icon(Icons.keyboard_arrow_up, size: 30),
                          ],
                        ),
                        onTap: () { 
                          showModalBottomSheet<void>(
                            isScrollControlled: true,
                            showDragHandle: true,
                            context: context, 
                            builder: (BuildContext context) {
                              return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                return pages(
                                  widget.prefs, 
                                  Toggles: HomeToggles(
                                    pinAppToggle: pinAppToggle, 
                                    pinnedApp: pinnedApp, 
                                    searchProvider: searchProvider, 
                                    toggleStatusBar: toggleStatusBar, 
                                    widgetToggle: widgetToggle,
                                  ),
                                  apps: _app,
                                );
                              });
                            }
                          );
                        },
                        onVerticalDragStart: (details) {
                          showModalBottomSheet<void>(isScrollControlled: true ,showDragHandle: true ,context: context, builder: (BuildContext context) {
                            return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                              return pages(
                                widget.prefs, 
                                Toggles: HomeToggles(
                                  pinAppToggle: pinAppToggle, 
                                  pinnedApp: pinnedApp, 
                                  searchProvider: searchProvider, 
                                  toggleStatusBar: toggleStatusBar, 
                                  widgetToggle: widgetToggle,
                                ),
                                apps: _app,
                              );
                            });
                          });
                        },
                      ),
                    ),
                    Visibility(
                      visible: noAppPinned,
                      maintainSize: false,
                      child: Container(
                        height: 30,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: FavoriteApps(widget.prefs, favoritApps: _app),
                      ),
                    ),
                  ]
                );
              }
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
                  String s = _searchController.text.toLowerCase();
                  RegExp regex = RegExp(s.split('').join('.*'), caseSensitive: false);
                  setState(() {
                    _filteredItems = _app.where((_app) => regex.hasMatch(_app.name.toLowerCase())).toList();
                    if (value.isNotEmpty){
                      showAppList = true;
                      hideDate = false;
                      hideMainGesture = false;
                    } else {
                      showAppList=false;
                      hideDate = true;
                      hideMainGesture = true;
                     }
                  });
                },
                onTapOutside: (value){
                  focusOnSearch.unfocus();
                  if (_filteredItems.isEmpty){
                    setState(() {
                      _searchController.clear();
                      showAppList = !showAppList;
                      if (showAppList == true){
                        hideDate = false;
                        hideMainGesture = false;
                      } else if (showAppList == false){
                      hideDate = true;
                      hideMainGesture = true;
                      }
                    });
                  }
                },
                onSubmitted: (String value) async {
                  List<AppInfo> apps = await InstalledApps.getInstalledApps();
                  String userInput = _searchController.text.toLowerCase();
                  RegExp regex = RegExp(userInput.split('').join('.*'), caseSensitive: false);
                  List<AppInfo> matchedApps = /*apps.where(
                    (app) => app.name.toLowerCase().contains(userInput),
                    ).toList();*/
                    apps.where((app) => regex.hasMatch(app.name.toLowerCase())).toList();

                  if (matchedApps.isNotEmpty) {
                    InstalledApps.startApp(matchedApps.first.packageName);
                  } else if  (userInput.isURL()) {
                    String inputURL = "https://$userInput";
                      final Uri url = Uri.parse(inputURL);
                      await launchUrl(url);
                  } else { 
                    String Search = "https://$engine$userInput";
                    final Uri searchURL = Uri.parse(Search);
                    await launchUrl(searchURL);
                  }
                  setState(() {
                    _searchController.clear();
                    showAppList = false;
                    hideMainGesture = true;
                    hideDate = true;
                  });
                },
                controller: _searchController,
                onTap: () {
                  if (_searchController.text.isNotEmpty){
                    String s = _searchController.text;
                    setState(() {
                      _filteredItems = _app.where(
                        (_app) => _app.name.toLowerCase().contains(s.toLowerCase()),
                      ).toList();
                      showAppList = true;
                      hideDate = false;
                      hideMainGesture = false;
                    });
                  } else {
                    setState(() {
                      _filteredItems = _app;
                      showAppList = !showAppList;
                      if (showAppList == true){
                        hideDate = false;
                        hideMainGesture = false;
                      } else if (showAppList == false){
                      hideDate = true;
                      hideMainGesture = true;
                      }
                    });
                    if (showAppList == true){
                    }
                  }
                },
              )
            ),
            Visibility(
              visible: showAppList,
              child: Expanded(
                child: Applist(
                  _searchController,
                  focusOnSearch, 
                  _filteredItems,
                  widget.prefs,
                  onTap: AppTapped
                )
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
                    if (widgetVis == false){
                    showModalBottomSheet<void>(isScrollControlled: true ,showDragHandle: true ,context: context, builder: (BuildContext context) {
                        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                          return pages(
                            widget.prefs, 
                            Toggles: HomeToggles(
                              pinAppToggle: pinAppToggle, 
                              pinnedApp: pinnedApp, 
                              searchProvider: searchProvider, 
                              toggleStatusBar: toggleStatusBar, 
                              widgetToggle: widgetToggle,
                            ),
                            apps: _app,
                          );
                        });
                      });
                    }
                    /*double left = _tapPosition.dx - 110;
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
                    );*/
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