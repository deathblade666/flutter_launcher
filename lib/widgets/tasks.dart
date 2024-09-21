
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tasks extends StatefulWidget {
  Tasks(this.prefs,{super.key});
  SharedPreferences prefs;

  @override
  State<Tasks> createState() => _TasksState();
}



class _TasksState extends State<Tasks> {
  List<String> tasks = [];
  List<bool> selectedTask= [];
  final TextEditingController _taskController = TextEditingController();



 void initState(){
  RestoreTasks();

 }

 void RestoreTasks (){
  widget.prefs.reload();
  List<String>? restoredTasks = widget.prefs.getStringList("Tasks");
  if (restoredTasks != null) {
    tasks = restoredTasks;
  }
 }

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
                return 
                SizedBox(
                  height: 50,
                  child: CheckboxListTile(
                    title: Text(tasks[index]),
                    value: selectedTask[index],
                    onChanged: (value) {
                      setState(() {
                        selectedTask[index] = value!;
                        if (value == true){
                          tasks.remove(tasks[index]);
                          selectedTask.remove(selectedTask[index]);
                        }
                      });
                      
                    },
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
                 selectedTask.add(false);
                 _taskController.clear();
                }
              });
              widget.prefs.setStringList("Tasks", tasks);
            },
          ),
        ],
      )
    );
  }
}