
import 'package:flutter/material.dart';

class Event {
  String? location;
  String title;
  String description;
  String? date;
  TimeOfDay? starttime;
  TimeOfDay? endTime;

  Event({required this.title, required this.description, required this.date, this.starttime, this.location, this.endTime});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      endTime: json["endTime"],
      location: json["location"],
      starttime: json["starttime"],
      date: json["date"],
      title: json["title"],
      description: json["description"],
    );
  }
  Map<String, dynamic> toJson(){
    return {
      "endTime":endTime,
      "location":location,
      "starttime":starttime,
      "date": date,
      "title": title, 
      "description": description, 
      };
  }
}
/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}