import 'dart:math';

import 'package:flutter/material.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

 void initState(){

 }

class _TasksState extends State<Tasks> {
  List tasks = ["test","testsegssgsere","tesgsrgwdvsdvwdwdvwdvwdvwdv", "fegegeg","ergergerg","dfwwffr","test","testsegssgsere","tesgsrgwdvsdvwdwdvwdvwdvwdv", "fegegeg","ergergerg","dfwwffr",];
  bool done = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 400,
      child: ListView.builder(itemCount: tasks.length ,itemBuilder: (context, index) {
        var taskAsString = tasks.toString();
          return Container(
            height: 50,
            child: ListTile(
              title: Text(taskAsString),
              leading: Checkbox(
                value: done, 
                onChanged: (value) {
                  setState(() {
                    done = value!;
                  });
                  print(done);
                }),
            
          )
          );
        })
    );
  }
}