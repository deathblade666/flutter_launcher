import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:flutter/services.dart';
import 'package:one_clock/one_clock.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';




class launcher extends StatefulWidget {
  const launcher({super.key});
  

  @override
  State<StatefulWidget> createState() => _launcherState();
}

  void onClosed(){
  
  }
  


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
  static const widgetplatform = MethodChannel('widget_channel');
  String weekDay = formatDate(DateTime.now(),[DD,]);
  String monthDay = formatDate(DateTime.now(),[MM, ' ', d]);
  

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
    super.initState();
    fetchApps();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    focusOnSearch.addListener(focusListener);
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

  @override
  void dispose() {
    focusOnSearch.dispose();
    focusOnSearch.removeListener(focusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      bottomSheet: BottomSheet(
        onClosing: onClosed, 
        builder: (BuildContext context){
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.keyboard_arrow_up, size: 30,)
              ],
            ),
            onVerticalDragStart: (details) {
              showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
                return SizedBox.expand(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector.new(
                        child:Text("Click here to add your widgets"),
                        onTap: () async {
                          //await widgetplatform.invokeMethod('addWidgetToHomeScreen');
                          showDialog(context: context, builder: (BuildContext context){
                            return const AlertDialog(
                              title: Text("To be Implemented"),
                            );
                          });
                        },
                        
                        ),
                    ],
                  )  
                );
              });
            },
          );
        }
      ),
      body: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          const Padding(padding: EdgeInsets.only(bottom: 38)),
         // Visibility(            // TODO: Scrollable grid for widget
         //   visible: enabeBottom,
         //   child: BottomSheet( elevation: 50 ,backgroundColor: Theme.of(context).colorScheme.surface,onClosing: onClosed, builder: (BuildContext Context){
         //     return GestureDetector(
         //       behavior: HitTestBehavior.opaque,
         //       onVerticalDragEnd: enableSheet,
         //       child: const Padding(
         //         padding: EdgeInsets.only(top: 5, bottom: 5),
         //         child: Column(
         //           mainAxisAlignment: MainAxisAlignment.center,
         //           children: [
         //             Row(
         //               mainAxisAlignment: MainAxisAlignment.center,
         //               children: [
         //               Icon(Icons.keyboard_arrow_up),
         //             ],)
                      
                      //Text("Clich here to add a widget"),
                      
         //           ],
         //         )
         //       ) 
         //     );
         //   }),
         // ),
          
          Container( 
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: SearchBar(
              focusNode: focusOnSearch,
              constraints: const BoxConstraints(
                maxHeight: 40,
                minHeight: 40
              ),
              elevation: const WidgetStatePropertyAll(0.0),
              leading: GestureDetector(
                onTap: (){
                  InstalledApps.startApp("com.google.android.dialer");
                },
                child: Icon(Icons.call, size: 25, color: Theme.of(context).colorScheme.primary,),
              ),
              onChanged: (String value) async {            // TODO: Implement function to filter app list based on user input
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
              onSubmitted: (String value) async {          //TODO: Implement non app related text functions (ie. Web searches, contact search, etc)
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
                } else {  //TODO: make user configurable search engine
                  String Search = "$userInput";
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
                setState(() {
                  showAppList = !showAppList;
                  if (showAppList == true){
                    hideDate = false;
                    hideMainGesture = false;
                  } else {
                    hideDate = true;
                    hideMainGesture = true;
                  }
                });
              },
            )
          ),
          Visibility(
            visible: showAppList,
            child: Expanded(
              child: ListView.builder( reverse: true, shrinkWrap: true, itemCount: _filteredItems.length, itemBuilder: (context, index){
                AppInfo app = _filteredItems[index];
                return Container(
                  height: 50,
                  child: ListTile(
                    onTap: () {
                      InstalledApps.startApp(app.packageName);
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
                      weekDay + '\n$monthDay',
                      textScaler: MediaQuery.textScalerOf(context),
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20), 
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
                      format: "h:m",
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
                onLongPress: (){
                  showDialog(context: context, builder: (BuildContext context){
                    return const AlertDialog(
                      title: Text("You long pressed!"),
                    );
                  });
                },
                onTap: (){
                  focusOnSearch.unfocus();
                },
                onVerticalDragUpdate: (details) async {
                  int sensitivity = 3;
                  if (details.delta.dy > sensitivity) {
                    // Do a thing on down swipe
                    await platform.invokeMethod('openNotificationShade');
                  } else if (details.delta.dy < sensitivity) {
                    // do a thing on up swipe
                    focusOnSearch.requestFocus();
                  }
                },
                onHorizontalDragUpdate: (details) {
                  int sensitivity = 2;
                  if (details.delta.dx > sensitivity){
                     // Do a thing on Right swipe
                    showDialog(context: context, builder: (BuildContext context){
                    return const AlertDialog(
                      title: Text("You swiped Right!"),
                    );
                  });
                  } else if (details.delta.dx < sensitivity) {
                    // do a thing on Left swipe
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
    );
  }
}