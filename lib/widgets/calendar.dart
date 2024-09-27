import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher/widgets/calendar_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  Calendar(this.prefs,{super.key});
  SharedPreferences prefs;
  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  Map<DateTime, List<Event>> events = {};
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay pickedStartTime = TimeOfDay.now();
  TimeOfDay pickedEndTime = TimeOfDay.now();
  final _locationController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String modifiedDate ='';


  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForday(_selectedDay!));
    _loadEvents();
  }   

  //TODO: Load events list for intially selected date (today) on page load

 Future<void> _loadEvents() async {
    Map<DateTime, List<Event>> _events = await loadEvents();
    setState(() {
      _selectedEvents.value = _getEventsForday(DateTime.now());
      events = _events;
    });
  }

  Future<Map<DateTime, List<Event>>> loadEvents() async {
    String? jsonString = widget.prefs.getString('Events');
    if (jsonString == null) {
      return {};
    }
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    Map<DateTime, List<Event>> events = jsonMap.map((key, value) => MapEntry(
      DateTime.parse(key),
      (value as List).map((event) => Event.fromJson(event)).toList(),
    ));
    return events;
  }
  
  void ReloadCalendar(){
    Map<DateTime, List<Event>> _events = events;
    setState(() {
      print(_selectedDay);
      _selectedEvents.value = _getEventsForday(_selectedDay!);
      events = _events;
    });
  }

  Future<void> saveEvents(Map<DateTime, List<Event>> events) async {
    Map<String, dynamic> jsonMap = events.map((key, value) => MapEntry(
      key.toIso8601String(),
      value.map((event) => event.toJson()).toList(),
    ));
    String jsonString = jsonEncode(jsonMap);
    await widget.prefs.setString('Events', jsonString);
  }

  modifyDate (BuildContext context) async {
    final DateTime? modifiedSelectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      initialEntryMode: DatePickerEntryMode.calendarOnly
    );
    if (modifiedSelectedDate != null){
      setState(() {
        modifiedDate = modifiedSelectedDate.toString();
      });
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents.value = _getEventsForday(selectedDay);
    });
  }

  List<Event> _getEventsForday(DateTime day) {
      return events[day] ?? [];
  }  

  void clearController() {
    _titleController.clear();
    _descriptionController.clear();
    _locationController.clear();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child:Column(
        children: [
          SizedBox(
            height: 235,
            child: TableCalendar(
              focusedDay: _focusedDay, 
              firstDay: DateTime.utc(2000, 12, 31),
              lastDay: DateTime.utc(2030, 01, 01),
              rowHeight: 35,
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                leftChevronVisible: false,
                rightChevronVisible: false
              ),
              calendarStyle: CalendarStyle(
                markerDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.secondary
                )
              ),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getEventsForday,
              onDaySelected: _onDaySelected,
              rangeSelectionMode: _rangeSelectionMode,
              onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
              },
            ),
          ),
          const Divider(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(flex: 3,),
              const Text("Events", textScaler: TextScaler.linear(1.4),), 
              const Spacer(flex: 2,),
              TextButton(
                onPressed:  (){
                  showDialog(
                    context: context, builder: (BuildContext context) {
                      return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                        return AlertDialog.adaptive(
                          scrollable: true,
                          title: const Text('New Event'),
                          content: Padding(
                            padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _titleController,
                                    decoration: const InputDecoration(helperText: 'Title'),
                                  ),
                                  Row(
                                    children: [
                                      const Text("Start Time:"),
                                      TextButton(
                                        onPressed: () async {
                                          final TimeOfDay? newTime = await showTimePicker(
                                            context: context,
                                            initialTime: pickedStartTime,
                                          );
                                          if (newTime != null) {
                                            setState(() {
                                              pickedStartTime = newTime;
                                            });
                                          }    
                                        }, 
                                        child: Text(pickedStartTime.format(context))
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("End Time:"),
                                      TextButton(
                                        onPressed: () async {
                                          final TimeOfDay? newTime = await showTimePicker(
                                            context: context,
                                            initialTime: pickedEndTime,
                                          );
                                          if (newTime != null) {
                                            setState(() {
                                              pickedEndTime = newTime;
                                            });
                                          }    
                                        }, 
                                        child: Text(pickedEndTime.format(context))
                                      ),
                                    ],
                                  ),
                                  TextField(
                                    controller: _locationController,
                                    decoration: const InputDecoration(helperText: 'Location'),
                                  ),
                                  TextField(
                                    controller: _descriptionController,
                                    decoration: const InputDecoration(helperText: 'Description'),
                                  ),
                                ],
                              ),
                            ),
                          actions: [
                            
                            //TODO: First submit saves to map but doesnt updat ehte calendar

                            TextButton(
                              onPressed: () {
                                events.addAll({
                                  _selectedDay!: [
                                    ..._selectedEvents.value,
                                    Event(
                                      location: _locationController.text,
                                      title: _titleController.text,
                                      description: _descriptionController.text,
                                      date: _selectedDay.toString(),
                                      starttime: pickedStartTime,
                                      endTime: pickedEndTime,
                                    )
                                  ]
                                });
                                ReloadCalendar();
                                _selectedEvents.value = _getEventsForday(_selectedDay!);
                                clearController();
                                saveEvents(events);
                                Navigator.pop(context);
                              },
                              child: const Text('Submit')
                            )
                          ],
                        );
                      });
                    }
                  );
                },
                child: const Icon(Icons.add)
              )
            ],
          ),
          SizedBox(
            height: 200,
            child: ValueListenableBuilder(valueListenable: _selectedEvents, builder: (context, value,_){
              return ListView.builder(itemCount: value.length, itemBuilder: (context, index){
                var _grabDate = DateTime.parse(value[index].date!.toString().split(' ')[0]);
                String month = formatDate(_grabDate, [M]);
                String longMonth = formatDate(_grabDate, [MM]);
                String eventDay = formatDate(_grabDate, [d]);
                if (value.isNotEmpty){
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onLongPress: (){
                      showDialog(
                        context: context, builder: (BuildContext context) {
                          return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                            return AlertDialog.adaptive(
                              scrollable: true,
                              title: const Text('Edit Event'),
                              content: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        //TODO: Update Date shown to be the date selected


                                        final  DateTime? modifiedSelectedDate = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2025),
                                          initialEntryMode: DatePickerEntryMode.calendarOnly
                                        );
                                        if (modifiedSelectedDate != null){
                                          value[index].date = modifiedSelectedDate.toString();
                                       }
                                       _selectedEvents.value = _getEventsForday(modifiedSelectedDate!);
                                      },
                                      child: Text('$longMonth $eventDay')
                                    ),
                                    TextField(
                                      controller: _titleController,
                                      decoration: const InputDecoration(helperText: 'Title'),
                                    ),
                                    Row(
                                      children: [
                                        const Text("Start Time:"),
                                        TextButton(
                                          onPressed: () async {
                                            final TimeOfDay? newTime = await showTimePicker(
                                              context: context,
                                              initialTime: pickedStartTime,
                                            );
                                            if (newTime != null) {
                                              setState(() {
                                                pickedStartTime = newTime;
                                              });
                                            }    
                                          }, 
                                          child: Text(pickedStartTime.format(context))
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("End Time:"),
                                        TextButton(
                                          onPressed: () async {
                                            final TimeOfDay? newTime = await showTimePicker(
                                              context: context,
                                              initialTime: pickedEndTime,
                                            );
                                            if (newTime != null) {
                                              setState(() {
                                                pickedEndTime = newTime;
                                              });
                                            }    
                                          }, 
                                          child: Text(pickedEndTime.format(context))
                                        ),
                                      ],
                                    ),
                                    TextField(
                                      controller: _locationController,
                                      decoration: const InputDecoration(helperText: 'Location'),
                                    ),
                                    TextField(
                                      controller: _descriptionController,
                                      decoration: const InputDecoration(helperText: 'Description'),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(

                                  //TODO: Update Key value to reflect if a new date is selected

                                  onPressed: () {
                                    if (_titleController.text != ''){
                                      value[index].title = _titleController.text;
                                    }
                                    if (_descriptionController.text != ''){
                                      value[index].description = _descriptionController.text;
                                    }
                                    if (pickedStartTime != value[index].starttime){
                                      value[index].starttime = pickedStartTime;
                                    }
                                    if (pickedEndTime != value[index].endTime){
                                      value[index].endTime = pickedEndTime;
                                    }
                                    if (_locationController.text != ''){
                                      value[index].location = _locationController.text;
                                    }
                                    _selectedEvents.value = _getEventsForday(_selectedDay!);
                                    clearController();
                                    saveEvents(events);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Submit')
                                )
                              ],
                            );
                          });
                        }
                      );
                    },
                    onTap: (){
                      showDialog(context: context, builder: (BuildContext context){
                        return AlertDialog.adaptive(
                          title: Center(
                            child: Text(value[index].title)
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Date: " '$longMonth $eventDay'),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Time: "'${value[index].starttime?.format(context)} - ${value[index].endTime?.format(context)}'),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Location: " '${value[index].location}'),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Decription: " '${value[index].description}'),
                              ),
                            ],
                          ),                    
                        );
                      });
                    },
                    child: SizedBox(
                      height: 65,
                      child: Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(month, textScaler: const TextScaler.linear(1.5)),
                              Text(' $eventDay', textScaler: const TextScaler.linear(1.4)),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(right: 15)),
                          VerticalDivider(
                            indent: 4,
                            endIndent: 4,
                            width: 2, 
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Padding(
                            padding: const EdgeInsets.only( left: 10, right: 10),
                            child: SizedBox(
                              width: 335,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          value[index].title, 
                                          textScaler: const TextScaler.linear(1.2), 
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const Spacer(),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Text('${value[index].starttime?.format(context)}  -  ${value[index].endTime?.format(context)}',overflow: TextOverflow.ellipsis,),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(value[index].description),
                                  )
                                ],
                              )
                            ) 
                          ),
                        ],
                      ) 
                    )
                  );
                } else {
                  return  const Center(
                    child:Text("No Events")
                  );
                }
              });
            }),
          )
        ]
      )
    );
  }
}