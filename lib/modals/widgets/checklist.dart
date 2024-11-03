

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckList extends StatefulWidget {
  CheckList(this.prefs, {Key? key}) : super(key: key);
  SharedPreferences prefs;
  

  @override
  State<CheckList> createState() => _TasksState();
}



class _TasksState extends State<CheckList> {
  List<String> checkItems = [];
  List<bool> selectedItems = [];
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
  List<String>? restoredCheckItems = widget.prefs.getStringList("checkItems");
  List<String>? restoreCheckboxesOnLoad = widget.prefs.getStringList("Restore Checkbox");
  if (restoredCheckItems != null) {
    setState(() {
      checkItems = restoredCheckItems;
    });  
  }
  if (restoreCheckboxesOnLoad != null) {
    setState(() {
      restoreCheckboxesOnLoad.forEach((item) => item == "true" ? selectedItems.add(true) : selectedItems.add(false));
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
      child:Column(
        children: [
          SizedBox(
            height: 400,
            child: ListView.builder(itemCount: checkItems.length ,itemBuilder: (context, index) {
                return SizedBox(
                  height: 50,
                  child: CheckboxListTile(
                    title: Text(checkItems[index]),
                    value: selectedItems[index],
                    onChanged: (value) {
                      setState(() {
                        selectedItems[index] = value!;
                        if (value == true){
                          checkItems.remove(checkItems[index]);
                          selectedItems.remove(selectedItems[index]);
                          restoreCheckboxes.remove(restoreCheckboxes[index]);
                        }
                      });
                      widget.prefs.setStringList("checkItems", checkItems);
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
                labelText: 'Enter an Item',
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
                 checkItems.add(_taskController.text);
                 selectedItems.add(false);
                 restoreCheckboxes.add("false");
                 _taskController.clear();
                }
              });
              widget.prefs.setStringList("checkItems", checkItems);
              widget.prefs.setStringList("Restore Checkbox", restoreCheckboxes);
            },
          ),
          ),
        ],
      )
    );
  }
}