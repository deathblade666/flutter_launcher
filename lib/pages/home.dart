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
      showAppList = false;
      enabeBottom = !enabeBottom;
       
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.transparent,
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
                Icon(Icons.keyboard_arrow_up,),
              ],
            )
          ),
          Container( 
            padding: const EdgeInsets.only(right: 15, left: 15, bottom: 5),
            child: SearchBar(
              elevation: const WidgetStatePropertyAll(0.0),
              leading: GestureDetector(
                onTap: (){
                  InstalledApps.startApp("com.google.android.dialer");
                },
                child: Icon(Icons.call),
              ),
              onChanged: (String value) async {            // TODO: Implement function to filter app list based on user input
                String s = _searchController.text;
                setState(() {
                  _filteredItems = _app.where(
                    (_app) => _app.name.toLowerCase().contains(s.toLowerCase()),
                    ).toList();
                });
              },
              onTap: () {
                setState(() {
                  showAppList = !showAppList;
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
              },
              controller: _searchController,
            )
          ),
          Visibility(
            visible: showAppList,
            child: //SizedBox(
              //height: 300,
              //child: 
              ListView.builder( reverse: true, shrinkWrap: true, itemCount: _filteredItems.length, itemBuilder: (context, index){
                AppInfo app = _filteredItems[index];
                return Container(
                  height: 50,
                  child: ListTile(
                    onTap: () {
                      InstalledApps.startApp(app.packageName);
                    },
                    leading: app.icon != null
                      ? Image.memory(app.icon!, height: 30,)
                      : Icon(Icons.android),
                    title: Text(app.name),
                   )
                );
              })
           // )
          ),       
        ]
      )
    );
  }
}