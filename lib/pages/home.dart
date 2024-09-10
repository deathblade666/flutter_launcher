import 'package:flutter/material.dart';

class launcher extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _launcherState();
}


 void onClosed(){
  
 }


class _launcherState extends State<launcher>{
  bool enabeBottom = false;


  void enableSheet(DragStartDetails) {
    setState(() {
       enabeBottom = !enabeBottom;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onVerticalDragStart: enableSheet,
          child: SearchBar(),
        ),
        Visibility(
          visible: enabeBottom,
          child: BottomSheet(onClosing: onClosed, builder: (BuildContext Context){
            return Text("test");
          })
        )
      ],
    );
  }
}