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
  List<String> _filteredItems = [];

  @override
  void initState(){
    fetchApps();
  }

  void fetchApps() async {
    List<AppInfo> apps = await InstalledApps.getInstalledApps();
    setState(() {
      installedApps = apps.map((app) => app.name).toList();
      _filteredItems = installedApps;
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
      resizeToAvoidBottomInset: true,
      body: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          Padding(padding: EdgeInsets.all(10)),
          Visibility(
            visible: enabeBottom,
            child: BottomSheet(onClosing: onClosed, builder: (BuildContext Context){
              return Text("Widgets will go here");
                  // TODO: Scrollable grid for widget
            }),
          ),
          GestureDetector(
            onVerticalDragUpdate: enableSheet,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.keyboard_arrow_up)
              ],
            )
          ),
          Container( 
            padding: EdgeInsets.only(right: 15, left: 15),
            child: SearchBar(
              elevation: const WidgetStatePropertyAll(0.0),
              leading: GestureDetector(
                onTap: (){
                  InstalledApps.startApp("com.google.android.dialer");
                },
                child: Icon(Icons.call),
              ),
              onChanged: (String value) async {            // TODO: Implement function to filter app list based on user input
                String s = value;
                print(installedApps.contains(s));
                if (installedApps.contains(s)){
                  setState(() {
                    _filteredItems = installedApps.where(
                      (app) => app.toLowerCase().contains(s.toLowerCase()),
                      ).toList();
                  });
                }
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
          Visibility(              // TODO: implement gesture controller to register item press to launch app
            visible: showAppList,
            child: SizedBox(
              height: 300,
              child: ListView.builder( itemCount: _filteredItems.length, itemBuilder: (context, index){
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Text(_filteredItems[index]),
                );
              })
            )
          ) 
        ]
      )
    );
  }
}