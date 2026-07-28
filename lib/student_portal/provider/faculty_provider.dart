
import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class FacultyProvider extends ChangeNotifier {
  List<Faculty> _faculties = [];
  bool _isLoading = false;
  String? _error;

  List<Faculty> get faculties => _faculties;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchFaculties() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Replace with real API call:
      // final res = await http.get(Uri.parse('https://your-api.com/faculties'));
      // final data = jsonDecode(res.body) as List;
      // _faculties = data.map((e) => Faculty.fromJson(e)).toList();

      await Future.delayed(const Duration(milliseconds: 500));

      _faculties = [
        const Faculty(
          id: '1',
          name: 'Dr. Anjali Menon',
          qualification: 'MD Homeopathy · AIIMS',
          rating: 4.9,
          experienceYears: 18,
          studentsCount: 24000,
          tags: ['AIAPGET', 'ORGANON'],
        ),
        const Faculty(
          id: '2',
          name: 'Dr. Rakesh Iyer',
          qualification: 'MD · PhD Homeopathy',
          rating: 4.9,
          experienceYears: 22,
          studentsCount: 31000,
          tags: ['NEET PG', 'PATHOLOGY'],
        ),
        const Faculty(
          id: '3',
          name: 'Dr. Priya Sharma',
          qualification: 'MD Homeopathy · Gold Medalist',
          rating: 4.8,
          experienceYears: 15,
          studentsCount: 18000,
          tags: ['MATERIA MEDICA'],
        ),
        const Faculty(
          id: '4',
          name: 'Dr. Vinod Kumar',
          qualification: 'MD Homeopathy · Author',
          rating: 4.9,
          experienceYears: 20,
          studentsCount: 22000,
          tags: ['REPERTORY', 'CLINICAL'],
        ),
      ];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}