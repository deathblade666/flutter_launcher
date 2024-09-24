import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notes extends StatefulWidget {
  Notes(this.prefs,{super.key});
  SharedPreferences prefs;

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  TextEditingController notesController = TextEditingController();

  @override
  void initState(){
    loadLastText();
  }

  void loadLastText(){
    String? lastText = widget.prefs.getString("Note");
    if (lastText != null){
      notesController.text = lastText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Expanded(
        child: TextField(
          controller: notesController,
          maxLines: null,
          onChanged: (value){
            widget.prefs.setString("Note", notesController.text);
          },
        )
      ),
    );
  }
}