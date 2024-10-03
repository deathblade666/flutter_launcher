import 'package:flutter/material.dart';

class pages extends StatefulWidget {
  const pages({super.key});

  @override
  State<pages> createState() => _pagesState();
}

class _pagesState extends State<pages> {
  @override
  Widget build(BuildContext context) {
    return Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: SizedBox(
                            height: 500,
                            child: PageView(
                              children: <Widget>[
                                if (displayTasks == true)...[  
                                  Visibility(
                                    visible: displayTasks,
                                    child: SizedBox(
                                      height: 800,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Tasks(widget.prefs),
                                          ],
                                        ),
                                      ),
                                    )
                                  ),
                                ] else... [],
                                if (enableCalendar == true)...[  
                                  Visibility(
                                    visible: enableCalendar,
                                    child: SizedBox(
                                      height: 800,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Calendar(widget.prefs)
                                          ],
                                        ),
                                      ),
                                    ))
                                ] else... [],
                                if (enableNotes == true)...[
                                  Visibility(
                                    visible: enableNotes,
                                    child: SizedBox(
                                      height: 800,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Notes(widget.prefs)
                                          ],
                                        ),
                                      ),
                                    )
                                  )
                                ] else ...[],
                                if (enableCalendar == false || enableTasks == false || enableNotes == false)...[
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    child: const Center( 
                                      child: Text("click here to add a widget!"),
                                    ),
                                    onTap: ()  {
                                      Navigator.pop(context);
                                      widgetSelection();
                                    },
                                  ),
                                ] else ...[]
                              ],
                            )
                          )
                        );
  }
}