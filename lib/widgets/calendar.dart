import 'dart:math';

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
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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

  List<Event> _getEventsForMonth(DateTime month) {
    return events[month] ?? [];
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
              //availableGestures: AvailableGestures.none,
              eventLoader: _getEventsForMonth,
              onDaySelected: _onDaySelected,
              rangeSelectionMode: _rangeSelectionMode,
              onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
              },
            ),
          ),
          Row(
            children: [
              Expanded(child: Padding(padding: EdgeInsets.only(right: 1))),
              TextButton(
                onPressed:  (){
                  showDialog(
                    context: context, builder: (_) => _dialogWidget(context));
                  },
                child: const Icon(Icons.add)
              )
            ],
          ),
          Container(
            color: Colors.black,
            height: 217,
            child: ListView.builder(itemCount: events.length ,itemBuilder: (context, index){
              return const Center( child: Text("List of events for the month"));
            }),
          ),
        ]
      )
    );
  }
}

AlertDialog _dialogWidget(BuildContext context) {
    return AlertDialog.adaptive(
      scrollable: true,
      title: const Text('New Event'),
      content: const Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              //controller: _titleController,
              decoration: InputDecoration(helperText: 'Title'),
            ),
            TextField(
              //controller: _descriptionController,
              decoration: InputDecoration(helperText: 'Description'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
            
             // events.addAll({
              //  _selectedDay!: [
               //   ..._selectedEvents.value,
               //   Event(
               //       title: _titleController.text,
               //       description: _descriptionController.text)
              //  ]
             // });
             // _selectedEvents.value = _getEventsForDay(_selectedDay!);
            //  clearController();
            //  context.pop();
            },
            child: const Text('Submit'))
      ],
    );
  }