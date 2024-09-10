

import 'package:flutter/material.dart';

class launcher extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _launcherState();
}


 void onClosed(){
  
 }

class _launcherState extends State<launcher>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: BottomSheet(
        onClosing: onClosed, 
        builder: (BuildContext context) {
        return Text("data");
      })
    );
  }
}