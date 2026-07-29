class LiveClassModel {
  final String title;
  final String facultyName;
  final DateTime startTime;
  final String dayLabel; // e.g. "Today · 7:00 PM", "Tomorrow · 10:00 AM"

  const LiveClassModel({
    required this.title,
    required this.facultyName,
    required this.startTime,
    required this.dayLabel,
  });
}
