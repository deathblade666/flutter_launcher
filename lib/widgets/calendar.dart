import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher/pages/home.dart';
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
  final _eventNoteController = TextEditingController();
  String modifiedDate ='';
  DateTime? modifiedSelectedDate;


  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForday(_selectedDay!));
    _loadEvents();
  }

 Future<void> _loadEvents() async {
    widget.prefs.reload();
    Map<DateTime, List<Event>> _events = await loadEvents();
    var selectedDay = DateTime.now();
    var focusedDay = DateTime.now();
     events = LinkedHashMap(
      equals: isSameDay,
      hashCode: Event.getHashCode,
    )..addAll(_events);
    _onDaySelected(selectedDay, focusedDay);
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
              lastDay: DateTime.utc(2300, 01, 01),
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
                                  TextField(
                                    controller: _eventNoteController,
                                    decoration: const InputDecoration(helperText: 'Notes'),
                                    //expands: true,
                                    maxLines: null,
                                  ),
                                ],
                              ),
                            ),
                          actions: [
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
                                      eventNotes: _eventNoteController.text,
                                    )
                                  ]
                                });
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
                      _titleController.text = value[index].title;
                      _descriptionController.text = value[index].description;
                      _locationController.text = value[index].location!;
                      var oldDate = value[index].date;
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
                                        DateTime? modifiedSelectedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.parse(value[index].date!),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2300),
                                        initialEntryMode: DatePickerEntryMode.calendarOnly
                                        );
                                        if (modifiedSelectedDate != null){ 
                                          value[index].date = modifiedSelectedDate.toString();
                                          setState(() => eventDay = formatDate(modifiedSelectedDate, [d]));
                                          setState(()=> longMonth = formatDate(modifiedSelectedDate, [MM]));
                                       }
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
                                    TextField(
                                      controller: _eventNoteController,
                                      decoration: const InputDecoration(helperText: 'Notes'),
                                    )
                                  ],
                                ),
                              ),
                              actions: [
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: (){
                                        var selectedDay = DateTime.parse(value[index].date!);
                                        var focusedDay = DateTime.parse(value[index].date!);
                                        //_selectedEvents.value = _getEventsForday(_selectedDay!);
                                        value.remove(value[index]);
                                        _onDaySelected(selectedDay, focusedDay);
                                        clearController();
                                        saveEvents(events);
                                        Navigator.pop(context);
                                      }, 
                                      child: const Text("Delete Event"),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        if (value[index].date == oldDate && _titleController.text != value[index].title){
                                          value[index].title = _titleController.text;
                                        }
                                        if (value[index].date == oldDate  && _descriptionController.text != value[index].description){
                                          value[index].description = _descriptionController.text;
                                        }
                                        if (value[index].date == oldDate && pickedStartTime != value[index].starttime){
                                          value[index].starttime = pickedStartTime;
                                        }
                                        if (value[index].date == oldDate && pickedEndTime != value[index].endTime){
                                          value[index].endTime = pickedEndTime;
                                        }
                                        if ( value[index].date == oldDate && _locationController.text != value[index].location){
                                          value[index].location = _locationController.text;
                                        }
                                        if (value[index].date == oldDate && _eventNoteController.text != value[index].eventNotes){
                                          value[index].eventNotes = _eventNoteController.text;
                                        }
                                        if (value[index].date != oldDate){
                                          _selectedDay = DateTime.parse(value[index].date!);
                                          value.remove(value[index]);
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
                                                eventNotes: _eventNoteController.text,
                                              )
                                            ]
                                          });
                                        }
                                        _selectedEvents.value = _getEventsForday(_selectedDay!);
                                        var selectedDay = _selectedDay!;
                                        var focusedDay = _selectedDay!;
                                        _onDaySelected(selectedDay, focusedDay);
                                        clearController();
                                        saveEvents(events);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Submit')
                                    ),
                                  ],
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
                              const Divider(),
                              const Align(
                                alignment: Alignment.center,
                                child: Text("Notes:"),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('${value[index].eventNotes}'),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: (){
                                    var selectedDay = DateTime.parse(value[index].date!);
                                    var focusedDay = DateTime.parse(value[index].date!);
                                    //_selectedEvents.value = _getEventsForday(_selectedDay!);
                                    value.remove(value[index]);
                                    _onDaySelected(selectedDay, focusedDay);
                                    saveEvents(events);
                                    Navigator.pop(context);
                                  }, 
                                  child: const Text("Delete Event"),
                                ),
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