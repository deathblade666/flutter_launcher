import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher/widgets/calendar_utils.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

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
  List eventList = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForMonth(_selectedDay!));
    loadPreviousEvents();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForMonth(DateTime day) {
    eventList = events.entries
      .expand((entry) => entry.value.map((event) => MapEntry(entry.key, event)))
      .toList();
    return events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
      _selectedEvents.value = _getEventsForMonth(selectedDay);
    }
  }

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  void clearController() {
    _titleController.clear();
    _descriptionController.clear();
  }

  void loadPreviousEvents() {
    events = {
      _selectedDay!: [const Event(title: '', description: '')],
      _selectedDay!: [const Event(title: '', description: '')]
    };
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
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.tertiary
                )
              ),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getEventsForMonth,
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed:  (){
                  showDialog(
                    context: context, builder: (BuildContext context) {
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
                                TextField(
                                  controller: _descriptionController,
                                  decoration: const InputDecoration(helperText: 'Description'),
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
                                  title: _titleController.text,
                                  description: _descriptionController.text)
                               ]
                            });
                            _selectedEvents.value = _getEventsForMonth(_selectedDay!);
                            clearController();
                            Navigator.pop(context);
                          },
                          child: const Text('Submit'))
                        ],
                      );
                    }
                  );
                },
                child: const Icon(Icons.add)
              )
            ],
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(itemCount: events.length, itemBuilder: (context, index){
              if (eventList.isNotEmpty){
              final eventEntry = eventList[index];
              final eventDate = eventEntry.key;
              final event = eventEntry.value;
              final eventTitle = event.title;
              final eventDescripiton = event.description;
              
              return SizedBox(
                height: 50,
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Text(eventDate.toLocal().toString().split(' ')[0]),
                    const Padding(padding: EdgeInsets.only(right: 15)),
                    VerticalDivider(
                      indent: 4,
                      endIndent: 4,
                      width: 2, 
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    //const Padding(padding: EdgeInsets.only(right: 15)),
                    Column(
                      children: [

                     
                        
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child:  Text(
                              eventTitle, 
                              textScaler: const TextScaler.linear(1.2), 
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(eventDescripiton),
                          ),
                        ),
                      ],
                    )
                  ],
                ) 
              );
              } else {
                return  const Center(
                  child:Text("No Events")
                );
              }
            }),
          ),
        ]
      )
    );
  }
}