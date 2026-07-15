import 'package:flutter/material.dart';

class JourneyStepModel {
  final int number;
  final String title;
  final String description;
  final IconData icon;

  JourneyStepModel({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });
}