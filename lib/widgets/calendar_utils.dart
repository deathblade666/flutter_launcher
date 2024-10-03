import 'package:flutter/material.dart';

class Event {
  String? location;
  String title;
  String description;
  String? date;
  TimeOfDay? starttime;
  TimeOfDay? endTime;
  String? eventNotes;

  Event({
    required this.title,
    required this.description,
    required this.date,
    this.starttime,
    this.location,
    this.endTime,
    this.eventNotes
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      location: json["location"],
      title: json["title"],
      description: json["description"],
      date: json["date"],
      starttime: json["starttime"] != null ? _timeOfDayFromString(json["starttime"]) : null,
      endTime: json["endTime"] != null ? _timeOfDayFromString(json["endTime"]) : null,
      eventNotes: json["eventNotes"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "location": location,
      "title": title,
      "description": description,
      "date": date,
      "starttime": starttime != null ? _timeOfDayToString(starttime!) : null,
      "endTime": endTime != null ? _timeOfDayToString(endTime!) : null,
      "eventNotes": eventNotes,
    };
  }
  static int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year; 
  }

  static TimeOfDay _timeOfDayFromString(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour}:${time.minute}';
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  
}
