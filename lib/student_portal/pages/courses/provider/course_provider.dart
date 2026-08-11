import 'package:flutter/material.dart';
import '../models/course_model.dart';

class CourseProvider extends ChangeNotifier {
  String _searchQuery = "";
  String _selectedCategory = "All";

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = "";
    _selectedCategory = "All";
    notifyListeners();
  }

  final List<CourseModel> _courses = const [
    CourseModel(
      title: "Mastering Organon of Medicine & Philosophy",
      faculty: "Dr. Aditya Sharma (AIR 3)",
      rating: 4.9,
      students: 850,
      price: 4999,
      discountPrice: 2499,
      badge: "BESTSELLER",
      category: "Organon",
      duration: "45 Hours",
      language: "English",
    ),
    CourseModel(
      title: "Clinical Repertory & Case Taking in Practice",
      faculty: "Dr. Rajesh Venkataraman",
      rating: 4.8,
      students: 1200,
      price: 5999,
      discountPrice: 2999,
      badge: "TRENDING",
      category: "Repertory",
      duration: "30 Hours",
      language: "Bilingual",
    ),
    CourseModel(
      title: "AIAPGET Complete Homeopathy Crack Course",
      faculty: "Dr. Neha Verma (AIR 1)",
      rating: 5.0,
      students: 2300,
      price: 15999,
      discountPrice: 8999,
      badge: "BESTSELLER",
      category: "AIAPGET",
      duration: "120 Hours",
      language: "English",
    ),
    // CourseModel(
    //   title: "NEET PG Homeopathy Foundation Course",
    //   faculty: "Dr. Sandeep Kumar",
    //   rating: 4.7,
    //   students: 450,
    //   price: 11999,
    //   discountPrice: 6499,
    //   badge: "NEW",
    //   category: "NEET PG",
    //   duration: "80 Hours",
    //   language: "English",
    // ),
    CourseModel(
      title: "Materia Medica Keynotes & Comparative Study",
      faculty: "Dr. Ananya Mukherjee",
      rating: 4.9,
      students: 1600,
      price: 3999,
      discountPrice: 1999,
      badge: "BESTSELLER",
      category: "Materia Medica",
      duration: "50 Hours",
      language: "Bilingual",
    ),
    CourseModel(
      title: "UPSC Homeopathic Medical Officer Prep",
      faculty: "Dr. Vikrant Singh",
      rating: 4.8,
      students: 920,
      price: 12999,
      discountPrice: 7999,
      badge: "TRENDING",
      category: "UPSC",
      duration: "95 Hours",
      language: "English",
    ),
    CourseModel(
      title: "Kerala PSC Medical Officer Exam Course",
      faculty: "Dr. Lakshmi Nair",
      rating: 4.9,
      students: 1100,
      price: 8999,
      discountPrice: 4999,
      badge: "BESTSELLER",
      category: "Kerala PSC",
      duration: "75 Hours",
      language: "Bilingual",
    ),
    CourseModel(
      title: "Advanced Pediatric Clinical Homeopathy",
      faculty: "Dr. Srinivas Rao",
      rating: 4.8,
      students: 780,
      price: 6999,
      discountPrice: 3499,
      badge: "NEW",
      category: "Clinical",
      duration: "35 Hours",
      language: "English",
    ),
    CourseModel(
      title: "National Teachers Eligibility Test (NTET) Prep",
      faculty: "Dr. Priyanka Mehta",
      rating: 4.6,
      students: 310,
      price: 7999,
      discountPrice: 3999,
      badge: "NEW",
      category: "NTET",
      duration: "40 Hours",
      language: "English",
    ),
    CourseModel(
      title: "Homeopathic Therapeutics in Gynaecology",
      faculty: "Dr. Meenakshi Iyer",
      rating: 4.9,
      students: 880,
      price: 4999,
      discountPrice: 2499,
      badge: "TRENDING",
      category: "Clinical",
      duration: "28 Hours",
      language: "English",
    ),
    CourseModel(
      title: "Kent's Repertory Masterclass & Analysis",
      faculty: "Dr. Harsh Vardhan",
      rating: 4.7,
      students: 650,
      price: 3499,
      discountPrice: 1699,
      badge: "NEW",
      category: "Repertory",
      duration: "25 Hours",
      language: "Bilingual",
    ),
    CourseModel(
      title: "Boenninghausen's Method and Therapeutics",
      faculty: "Dr. Amit Patwardhan",
      rating: 4.8,
      students: 540,
      price: 3499,
      discountPrice: 1699,
      badge: "NEW",
      category: "Repertory",
      duration: "22 Hours",
      language: "English",
    ),
  ];

  List<CourseModel> get courses {
    return _courses.where((course) {
      if (_selectedCategory != "All") {
        if (course.category != _selectedCategory) {
          return false;
        }
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchTitle = course.title.toLowerCase().contains(query);
        final matchFaculty = course.faculty.toLowerCase().contains(query);
        final matchCategory = course.category.toLowerCase().contains(query);
        return matchTitle || matchFaculty || matchCategory;
      }
      return true;
    }).toList();
  }
}
