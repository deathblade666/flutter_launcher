import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class launcher extends StatefulWidget {
  const launcher({super.key});

  @override
  State<StatefulWidget> createState() => _launcherState();
}

  void onClosed(){
  
  }
  
  @override
  void initState(){
    onLoad();
  }

  void onLoad() async {
    List<Application> apps = await DeviceApps.getInstalledApplications();
  }

class _launcherState extends State<launcher>{
  bool enabeBottom = false;
  bool showAppList = false;
  final TextEditingController _searchController = TextEditingController();

  void enableSheet(DragStartDetails) {
    setState(() {
       enabeBottom = !enabeBottom;
    });
  }

// Search function
  void searching(value){
    print(_searchController.text);

  }

  void appList(){
    setState(() {
      showAppList = !showAppList;
      print(showAppList);
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
                //onTap: appList,
                controller: _searchController,
              )
             ],
          ),
       ),
        Visibility(
          visible: showAppList,
          child:
              ListView(
                children: const [
                  //apps
                ],
              )
            
        ), 
         // For Wallpaper
        //Image(image: image),
      ],
    );
  }
}