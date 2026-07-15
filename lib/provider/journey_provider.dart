import 'package:flutter/material.dart';
import 'package:homeopathy/model/journey_model.dart';

class JourneyProvider extends ChangeNotifier {
  final List<JourneyStepModel> _steps = [
    JourneyStepModel(
      number: 1,
      title: "Discover",
      description:
          "Pick your exam & preferred track from our curated catalogue.",
      icon: Icons.search,
    ),
    JourneyStepModel(
      number: 2,
      title: "Learn Live",
      description:
          "Join daily live classes with India's top homeopathy faculty.",
      icon: Icons.videocam_outlined,
    ),
    JourneyStepModel(
      number: 3,
      title: "Practice",
      description: "Attempt weekly mock tests and adaptive MCQ drills.",
      icon: Icons.assignment_outlined,
    ),
    JourneyStepModel(
      number: 4,
      title: "Succeed",
      description: "Personal mentorship until you clear your exam with rank.",
      icon: Icons.emoji_events_outlined,
    ),
  ];

  List<JourneyStepModel> get steps => _steps;
}
