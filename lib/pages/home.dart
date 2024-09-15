import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class launcher extends StatefulWidget {
  const launcher({super.key});

  @override
  State<StatefulWidget> createState() => _launcherState();
}

  void onClosed(){
  
  }
  


class _launcherState extends State<launcher>{
  bool enabeBottom = false;
  bool showAppList = false;
  final TextEditingController _searchController = TextEditingController();
  List<String> installedApps = [];
  List<AppInfo> _filteredItems = [];
  List<AppInfo> _app = [];
  bool hideDateTime = true;
  FocusNode focusOnSearch = FocusNode();


  @override
  void initState(){
    super.initState();
    fetchApps();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          const Padding(padding: EdgeInsets.all(5)),
          Visibility(
            visible: enabeBottom,
            child: BottomSheet(onClosing: onClosed, builder: (BuildContext Context){
              return const Text("Widgets will go here");
                  // TODO: Scrollable grid for widget
            }),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragEnd: enableSheet,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.keyboard_arrow_up),
              ],
            )
          ),
          Container( 
            padding: const EdgeInsets.only(right: 15, left: 15, bottom: 5),
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
                child: Icon(Icons.call, size: 25),
              ),
              onChanged: (String value) async {            // TODO: Implement function to filter app list based on user input
                String s = _searchController.text;
                setState(() {
                  _filteredItems = _app.where(
                    (_app) => _app.name.toLowerCase().contains(s.toLowerCase()),
                    ).toList();
                    if (value.isNotEmpty){
                      showAppList = true;
                    } else {
                      showAppList=false;
                    }
                    
                });
              },
              onSubmitted: (String value) async {          //TODO: Implement non app related text functions (ie. Web searches, contact search, etc)
                List<AppInfo> apps = await InstalledApps.getInstalledApps();
                String userInput = _searchController.text.toLowerCase();
                List<AppInfo> matchedApps = apps.where(
                  (app) => app.name.toLowerCase().contains(userInput),
                  ).toList();

                if (matchedApps.isNotEmpty) {
                  InstalledApps.startApp(matchedApps.first.packageName);
                } else {
                  showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(
                      title: const Text("Error"),
                      content: Text("$userInput was not found!"),
                    );
                  });
                }
                _searchController.clear();
                setState(() {
                  showAppList = false;
                });
              },
              controller: _searchController,
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
          const Padding(padding: EdgeInsets.all(5)),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 15),
                child: const Text("Dynamic Date Widget",),
              ),
              const Expanded(child: Padding(padding: EdgeInsets.all(1))),
              Container(
                padding: const EdgeInsets.only(right: 15),
                child: const Text("Time"),
              ),
            ],
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: (){
                showDialog(context: context, builder: (BuildContext context){
                  return const AlertDialog(
                    title: Text("You Tapped!"),
                  );
                });
              },
              onLongPress: (){
                showDialog(context: context, builder: (BuildContext context){
                  return const AlertDialog(
                    title: Text("You long pressed!"),
                  );
                });
              },
              onVerticalDragUpdate: (details) {
                int sensitivity = 3;
                if (details.delta.dy > sensitivity){
                  // Do a thing on down swipe
                  print("down: $details");
                  showDialog(context: context, builder: (BuildContext context){
                  return const AlertDialog(
                    title: Text("You swiped down!"),
                  );
                });
                } else if (details.delta.dy < sensitivity) {
                  // do a thing on up swipe
                  focusOnSearch.requestFocus();
                }
              },
              onHorizontalDragUpdate: (details) {
                int sensitivity = 3;
                if (details.delta.dx > sensitivity){
                  // Do a thing on Right swipe
                  print("Right: $details");
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
        ]
      )
    );
  }
}