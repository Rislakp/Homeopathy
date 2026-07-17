
import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class CategoryProvider extends ChangeNotifier {

int selectedIndex = -1;

  final List<CategoryModel> categories = [

    CategoryModel(
      title: "AIAPGET",
      subtitle: "48 Courses",
      icon: Icons.emoji_events_outlined,
    ),

    CategoryModel(
      title: "NEET PG Foundation",
      subtitle: "36 Courses",
      icon: Icons.school_outlined,
    ),

    CategoryModel(
      title: "NTET Coaching",
      subtitle: "22 Courses",
      icon: Icons.workspace_premium_outlined,
    ),

    CategoryModel(
      title: "Exit Exam",
      subtitle: "18 Courses",
      icon: Icons.assignment_outlined,
    ),

    CategoryModel(
      title: "UPSC & PSC",
      subtitle: "31 Courses",
      icon: Icons.gavel_outlined,
    ),

    CategoryModel(
      title: "Materia Medica",
      subtitle: "24 Courses",
      icon: Icons.medication_outlined,
    ),

    CategoryModel(
      title: "Organon",
      subtitle: "16 Courses",
      icon: Icons.menu_book_outlined,
    ),

    CategoryModel(
      title: "Repertory",
      subtitle: "12 Courses",
      icon: Icons.science_outlined,
    ),
  ];

  void selectCategory(int index) {
    selectedIndex = index;
    notifyListeners();
  }

void clearSelected (){
  selectedIndex =-1;
  notifyListeners();
}

}