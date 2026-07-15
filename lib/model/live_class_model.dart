class LiveClassModel {
  final String id;
  final String title;
  final String description;
  final String facultyName;
  final String facultyImage;
  final String meetingLink;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int duration;
  final String thumbnail;
  final bool isLive;
  final bool isCompleted;

  LiveClassModel({
    required this.id,
    required this.title,
    required this.description,
    required this.facultyName,
    required this.facultyImage,
    required this.meetingLink,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.thumbnail,
    required this.isLive,
    required this.isCompleted,
  });

  factory LiveClassModel.fromJson(Map<String, dynamic> json) {
    return LiveClassModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      facultyName: json['facultyName'],
      facultyImage: json['facultyImage'],
      meetingLink: json['meetingLink'],
      date: DateTime.parse(json['date']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      duration: json['duration'],
      thumbnail: json['thumbnail'],
      isLive: json['isLive'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'facultyName': facultyName,
      'facultyImage': facultyImage,
      'meetingLink': meetingLink,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'duration': duration,
      'thumbnail': thumbnail,
      'isLive': isLive,
      'isCompleted': isCompleted,
    };
  }
}