import 'package:flutter/material.dart';
import 'category_model.dart';

class CategoryData {
  static const List<CategoryModel> categories = [
    CategoryModel(
      id: 0,
      title: "AIAPGET",
      subtitle: "Preparation Coaching",
      courseCount: 48,
      icon: Icons.school_rounded,
    ),
    CategoryModel(
      id: 1,
      title: "NEET PG Foundation",
      subtitle: "Basic & Clinical",
      courseCount: 36,
      icon: Icons.health_and_safety_rounded,
    ),
    CategoryModel(
      id: 2,
      title: "NTET Coaching",
      subtitle: "Teacher Eligibility Test",
      courseCount: 22,
      icon: Icons.co_present_rounded,
    ),
    CategoryModel(
      id: 3,
      title: "Exit Exam",
      subtitle: "Licensing Preparation",
      courseCount: 18,
      icon: Icons.fact_check_rounded,
    ),
    CategoryModel(
      id: 4,
      title: "UPSC & PSC",
      subtitle: "Govt Medical Officer",
      courseCount: 31,
      icon: Icons.account_balance_rounded,
    ),
    CategoryModel(
      id: 5,
      title: "Materia Medica",
      subtitle: "Homoeopathic Drugs",
      courseCount: 24,
      icon: Icons.menu_book_rounded,
    ),
    CategoryModel(
      id: 6,
      title: "Organon",
      subtitle: "Principles of Medicine",
      courseCount: 16,
      icon: Icons.psychology_rounded,
    ),
    CategoryModel(
      id: 7,
      title: "Repertory",
      subtitle: "Case analysis & Rubrics",
      courseCount: 12,
      icon: Icons.table_view_rounded,
    ),
    CategoryModel(
      id: 8,
      title: "Clinical",
      subtitle: "Practice & Diagnostics",
      courseCount: 29,
      icon: Icons.medical_services_rounded,
    ),
    CategoryModel(
      id: 9,
      title: "Pathology",
      subtitle: "Disease Mechanisms",
      courseCount: 14,
      icon: Icons.biotech_rounded,
    ),
    CategoryModel(
      id: 10,
      title: "Research Methodology",
      subtitle: "Biostatistics & Thesis",
      courseCount: 9,
      icon: Icons.analytics_rounded,
    ),
    CategoryModel(
      id: 11,
      title: "MCQ Test Series",
      subtitle: "Practice & Mock Exams",
      courseCount: 0,
      icon: Icons.quiz_rounded,
      testCountText: "60+ Tests",
    ),
  ];
}
