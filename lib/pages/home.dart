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
  List<AppInfo> apps = [];

  @override
  void initState(){
  }

  void enableSheet(DragStartDetails) {
    setState(() {
       enabeBottom = !enabeBottom;
    });
  }

// Search function
  void searching(value){
    //onLoad();
    String s = _searchController.text;
    if (apps.contains(s)){
    }

  }

  void appList(){
    setState(() {
      showAppList = !showAppList;
    });
  }

  void launchApp(value) async {
    List<AppInfo> apps = await InstalledApps.getInstalledApps();
    String userInput = _searchController.text.toLowerCase();
    List<AppInfo> matchedApps = apps.where(
      (app) => app.name.toLowerCase().contains(userInput),
    ).toList();

    if (matchedApps.isNotEmpty) {
      InstalledApps.startApp(matchedApps.first.packageName);
    } else {
      print("No App Found!");
    }
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
                onChanged: searching,
                onTap: appList,
                onSubmitted: launchApp,
                controller: _searchController,
              )
             ],
          ),
       ),
        Visibility(
          visible: showAppList,
          child: 
          SizedBox(
            height: 200,
            width: 200,
            child: ListView.builder( itemCount: apps.length, itemBuilder: (context, index){
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              //key: ValueKey(apps[index]),
              child: Text(apps[index].name),
              );
            })
          )
        ), 
         // For Wallpaper
        //Image(image: image),
      ],
    );
  }
}