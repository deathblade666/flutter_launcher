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

  @override
  void initState(){
    fetchApps();
  }

  void fetchApps() async {
    List<AppInfo> apps = await InstalledApps.getInstalledApps();
    setState(() {
      installedApps = apps.map((app) => app.name).toList();
    });
  }

  void enableSheet(DragStartDetails) {
    setState(() {
       enabeBottom = !enabeBottom;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      verticalDirection: VerticalDirection.up,
      children: [
        Visibility(
          visible: enabeBottom,
          child: BottomSheet(onClosing: onClosed, builder: (BuildContext Context){
            return const Column(
              children: [
                // TODO: Scrollable grid for widget
                Text("This is where widgets will live... When i can figure out how")
              ],
            );
          })
        ),
        const Padding(padding: EdgeInsetsDirectional.only(bottom: 10)),
        GestureDetector(
          onVerticalDragStart: enableSheet,
          child: Column(
            children: [
              SearchBar(
                elevation: const WidgetStatePropertyAll(0.0),
                onChanged: (String value) async {            // TODO: Implement function to filter app list based on user input
                  String s = _searchController.text;
                  //if (apps.contains(s)){
                  //}
                },
                onTapOutside: (PointerDownEvent) {
                  setState(() {
                    showAppList = false;
                  });
                },
                onTap: () {
                  setState(() {
                    showAppList = true;
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
             ],
          ),
       ),
        Visibility(              // TODO: implement gesture controller to register item press to launch app
          visible: showAppList,
          child: 
          SizedBox(
            height: 500,
            width: 300,
            child: ListView.builder( itemCount: installedApps.length, itemBuilder: (context, index){
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              //key: ValueKey(apps[index]),
              child: Text(installedApps[index]),
              );
            })
          )
        ), 
      ],
    );
  }
}