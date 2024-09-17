import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class settingeMenu extends StatefulWidget {
  settingeMenu(this.prefs,{required this.onProviderSet,super.key});
  final void Function(String provider) onProviderSet;
  SharedPreferences prefs;

  @override
  State<settingeMenu> createState() => _settingeMenuState();
}


class _settingeMenuState extends State<settingeMenu> {
  TextEditingController searchProvider = TextEditingController();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SwitchListTile(
            value: false,
            title: const Text("Enable Widgets"),
            onChanged: (value) {
              return null;
            }
          ),
          TextButton(
            onPressed: () {
              widget.prefs.reload();
              String? engine = widget.prefs.getString("provider");
              engine ??= "duckduckgo.com/?q=";
              showDialog(context: context, builder: (BuildContext context){
                return AlertDialog(
                  title: const Text("Enter Search Provider URL", style: TextStyle(fontSize: 15),),
                  actions: [
                    Row(
                      children: [
                        Text("example:"+"\n$engine", style: const TextStyle(fontSize: 12), textAlign: TextAlign.left,),
                      ],
                    ),
                    TextField(
                      controller: searchProvider,
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          }, 
                          child: const Text("Cancel")
                        ),
                        const Expanded(child: Padding(padding: EdgeInsets.only(right: 1))),
                        TextButton(
                          onPressed: () {
                            String provider = searchProvider.text;
                            widget.onProviderSet(provider);
                            widget.prefs.setString("provider", provider);
                            Navigator.pop(context);
                          }, 
                          child: const Text("Save")
                        ),
                      ],
                    ),
                  ],
                );
              });
            }, 
            child: const Text("Set Custom Search Provider",)
          ),
          Row(
            children: [
              BackButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => launcher(widget.prefs)),
                  );
                },
              ),
              const Expanded(child: Padding(padding: EdgeInsets.all(1))),
              TextButton(
                onPressed: () {
                  widget.prefs.clear();
                }, 
                child: const Text("Reset")
              ),
              
            ],
          )
          
        ],
      ),
    );
  }
}