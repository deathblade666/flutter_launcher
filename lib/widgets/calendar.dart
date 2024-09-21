import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;

  @override
  void initState(){
    var now = DateTime.now();
    _selectedDay = now;
    _focusedDay = now;
    _firstDay = DateTime(now.year - 10, now.month, 1);
    _lastDay = DateTime(now.year + 10, now.month, 1);
  }




  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      width: 400,
      child:Column(
        children: [
          SizedBox(
            height: 300,
            width: 400,
            child: TableCalendar(
              focusedDay: _focusedDay, 
              firstDay: _firstDay, 
              lastDay: _lastDay,
              rowHeight: 35,
              calendarFormat: CalendarFormat.month,
            )
          ),
          //TODO: List of Events for the entire month
        ]
      )
    );
  }
}

