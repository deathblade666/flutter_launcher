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


  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForday(_selectedDay!));
  }
    

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForday(DateTime day) {
      return events[day] ?? [];
  }




  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        _selectedEvents.value = _getEventsForday(selectedDay);
      });
      
    }
  }

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  void clearController() {
    _titleController.clear();
    _descriptionController.clear();
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
                  color: Theme.of(context).colorScheme.tertiary,
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
                                  date: _selectedDay.toString(),
                                  title: _titleController.text,
                                  description: _descriptionController.text)
                               ]
                            });
                            _selectedEvents.value = _getEventsForday(_selectedDay!);
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
            child: ValueListenableBuilder(valueListenable: _selectedEvents, builder: (context, value,_){
              return ListView.builder(itemCount: value.length, itemBuilder: (context, index){
                var _grabDate = DateTime.parse(value[index].date!.toString().split(' ')[0]);
                String month = formatDate(_grabDate, [M]);
                String eventDay = formatDate(_grabDate, [d]);
              if (value.isNotEmpty){
              return SizedBox(
                height: 50,
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      children: [
                        Text(month, textScaler: TextScaler.linear(1.3),),
                        Text(' $eventDay', textScaler: TextScaler.linear(1.2),),
                      ],
                    ),
                    
                    const Padding(padding: EdgeInsets.only(right: 15)),
                    VerticalDivider(
                      indent: 4,
                      endIndent: 4,
                      width: 2, 
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child:  Text(
                              value[index].title, 
                              textScaler: const TextScaler.linear(1.2), 
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(value[index].description),
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
            });
            },
          ),
        )

        ]
      )
    );
  }
}