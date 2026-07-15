import 'package:flutter/material.dart';
import 'package:homeopathy/model/live_class_model.dart';


class LiveClassProvider extends ChangeNotifier {
  final List<LiveClassModel> liveClasses = [
    LiveClassModel(
      id: "1",
      title: "Human Anatomy",
      description: "Introduction to Human Anatomy",
      facultyName: "Dr. John",
      facultyImage: "assets/images/faculty1.png",
      meetingLink: "https://meet.google.com/abc-defg",
      date: DateTime(2026, 7, 14),
      startTime: "10:00 AM",
      endTime: "11:00 AM",
      duration: 60,
      thumbnail: "assets/images/live_class.png",
      isLive: true,
      isCompleted: false,
    ),
    LiveClassModel(
      id: "2",
      title: "Homeopathy Basics",
      description: "Introduction to Homeopathy",
      facultyName: "Dr. Sarah",
      facultyImage: "assets/images/faculty2.png",
      meetingLink: "https://meet.google.com/xyz-abcd",
      date: DateTime(2026, 7, 15),
      startTime: "02:00 PM",
      endTime: "03:00 PM",
      duration: 60,
      thumbnail: "assets/images/live_class2.png",
      isLive: false,
      isCompleted: false,
    ),
  ];

    List<LiveClassModel> get liveClass => liveClass;

  void addLiveClass(LiveClassModel liveClass) {
    liveClasses.add(liveClass);
    notifyListeners();
  }

  void removeLiveClass(String id) {
    liveClasses.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateLiveStatus(String id, bool isLive) {
    final index = liveClasses.indexWhere((item) => item.id == id);

    if (index != -1) {
      final old = liveClasses[index];

      liveClasses[index] = LiveClassModel(
        id: old.id,
        title: old.title,
        description: old.description,
        facultyName: old.facultyName,
        facultyImage: old.facultyImage,
        meetingLink: old.meetingLink,
        date: old.date,
        startTime: old.startTime,
        endTime: old.endTime,
        duration: old.duration,
        thumbnail: old.thumbnail,
        isLive: isLive,
        isCompleted: old.isCompleted,
      );

      notifyListeners();
    }
  }
}