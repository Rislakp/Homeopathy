import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class StatsProvider extends ChangeNotifier {

  final List<StatsModel> _stats = [
    StatsModel(
      count: "1,20,000+",
      title: "Active Students",
    ),
    StatsModel(
      count: "480+",
      title: "Rank Holders",
    ),
    StatsModel(
      count: "180+",
      title: "Expert Faculty",
    ),
    StatsModel(
      count: "96%",
      title: "Pass Rate",
    ),
  ];

  List<StatsModel> get stats => _stats;
}