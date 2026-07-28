import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_model.dart';
import 'category_provider.dart';
import 'screens/aiapget_screen.dart';
import 'screens/neet_pg_screen.dart';
import 'screens/ntet_screen.dart';
import 'screens/exit_exam_screen.dart';
import 'screens/upsc_psc_screen.dart';
import 'screens/materia_medica_screen.dart';
import 'screens/organon_screen.dart';
import 'screens/repertory_screen.dart';
import 'screens/clinical_screen.dart';
import 'screens/pathology_screen.dart';
import 'screens/research_methodology_screen.dart';
import 'screens/mcq_test_series_screen.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryUIProvider>(
      builder: (context, provider, child) {
        final isSelected = provider.selectedIndex == category.id;
        final isHovered = provider.hoveredIndex == category.id;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => provider.setHoveredIndex(category.id),
          onExit: (_) => provider.clearHoveredIndex(),
          child: AnimatedScale(
            scale: isHovered ? 1.04 : 1.00,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xffE8F5E9)
                    : Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xff2E7D32)
                      : (isHovered
                            ? const Color(0xff81C784).withOpacity(0.8)
                            : const Color(0xffE8F5E9)),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isHovered
                        ? const Color(0xff2E7D32).withOpacity(0.12)
                        : const Color(0xff2E7D32).withOpacity(0.04),
                    blurRadius: isHovered ? 20 : 12,
                    offset: isHovered
                        ? const Offset(0, 10)
                        : const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () {
                    provider.selectCategory(category.id);

                    Widget screen;
                    switch (category.id) {
                      case 0:
                        screen = const AIAPGETScreen();
                        break;
                      case 1:
                        screen = const NeetPGScreen();
                        break;
                      case 2:
                        screen = const NTETScreen();
                        break;
                      case 3:
                        screen = const ExitExamScreen();
                        break;
                      case 4:
                        screen = const UPSCPSCScreen();
                        break;
                      case 5:
                        screen = const MateriaMedicaScreen();
                        break;
                      case 6:
                        screen = const OrganonScreen();
                        break;
                      case 7:
                        screen = const RepertoryScreen();
                        break;
                      case 8:
                        screen = const ClinicalScreen();
                        break;
                      case 9:
                        screen = const PathologyScreen();
                        break;
                      case 10:
                        screen = const ResearchMethodologyScreen();
                        break;
                      case 11:
                        screen = const MCQTestSeriesScreen();
                        break;
                      default:
                        screen = const Scaffold(
                          body: Center(child: Text("Coming Soon")),
                        );
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => screen),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xff2E7D32)
                                : const Color(0xffE8F5E9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            category.icon,
                            size: 28,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xff2E7D32),
                          ),
                        ),

                        Text(
                          category.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),

                        Text(
                          category.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white70 : Colors.grey,
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white24
                                : const Color(0xffE8F5E9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category.testCountText ??
                                "${category.courseCount} Courses",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xff2E7D32),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
