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
  List<String> tasks = [];
  bool done = false;
  TextEditingController _taskController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      width: 400,
      child:Column(
        children: [
          const Text("Tasks", textScaler: TextScaler.linear(1.5),),
          SizedBox(
            height: 300,
            width: 400,
            child: ListView.builder(itemCount: tasks.length ,itemBuilder: (context, index) {
                return SizedBox(
                  height: 50,
                  child: ListTile(
                    title: Text(tasks[index]),
                    leading: Checkbox(
                    value: done, 
                    onChanged: (value) {
                      setState(() {
                        done = value!;
                      });
                    }),
                  )
                );
              }),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 15, top: 15)),
          TextField(
            decoration: const InputDecoration(
                labelText: 'Enter a task',
                border: OutlineInputBorder(),
            ),
            controller: _taskController,
            onSubmitted: (value) {
              setState(() {
                if (_taskController.text.isNotEmpty) {
                 tasks.add(_taskController.text);
                 _taskController.clear();
                }
              });
            },
          ),
        ],
      )
      
      
      );
  }
}