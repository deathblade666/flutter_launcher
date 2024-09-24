
class Event {
  String title;
  String description;
  String? date;

  Event({required this.title, required this.description, required this.date});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      date: json["date"],
      title: json["title"],
      description: json["description"],
    );
  }
  Map<String, dynamic> toJson(){
    return {
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