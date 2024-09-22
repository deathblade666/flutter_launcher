
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
  List<bool> selectedTask = [];
  List<String> restoreCheckboxes = [];
  final TextEditingController _taskController = TextEditingController();
  FocusNode taskInputField = FocusNode();


 @override
 void initState(){
    super.initState();
  RestoreTasks();

 }

 void RestoreTasks (){
  widget.prefs.reload();
  List<String>? restoredTasks = widget.prefs.getStringList("Tasks");
  List<String>? restoreCheckboxesOnLoad = widget.prefs.getStringList("Restore Checkbox");
  if (restoredTasks != null) {
    setState(() {
      tasks = restoredTasks;
    });  
  }
  if (restoreCheckboxesOnLoad != null) {
    setState(() {
      restoreCheckboxesOnLoad.forEach((item) => item == "true" ? selectedTask.add(true) : selectedTask.add(false));
      restoreCheckboxes = restoreCheckboxesOnLoad;
    });
    
  }
 }

@override
  void dispose() {
    taskInputField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      //width: 400,
      child:Column(
        children: [
          //const Text("Tasks", textScaler: TextScaler.linear(1.5),),
          SizedBox(
            height: 400,
            //width: 400,
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
                          restoreCheckboxes.remove(restoreCheckboxes[index]);
                        }
                      });
                      widget.prefs.setStringList("Tasks", tasks);
                      widget.prefs.setStringList("Restore Checkbox", restoreCheckboxes);
                    },
                  )
                );
              }),
          ),
          Padding(padding: const EdgeInsets.only(bottom: 1, top: 15, left: 15, right: 15), 
          child:
          TextField(
            decoration: const InputDecoration(
                labelText: 'Enter a task',
                border: OutlineInputBorder(),
            ),
            controller: _taskController,
            focusNode: taskInputField,
            onTapOutside: (PointerDownEvent){
              taskInputField.unfocus();
            },
            onSubmitted: (value) {
              setState(() {
                if (_taskController.text.isNotEmpty) {
                  taskInputField.requestFocus();
                 tasks.add(_taskController.text);
                 selectedTask.add(false);
                 restoreCheckboxes.add("false");
                 _taskController.clear();

                }
              });
              widget.prefs.setStringList("Tasks", tasks);
              widget.prefs.setStringList("Restore Checkbox", restoreCheckboxes);
            },
          ),
          ),
        ],
      )
    );
  }
}