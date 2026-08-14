import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:homeopathy/core/theme/app_colors.dart';
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
            scale: isHovered ? 1.03 : 1.00,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryDark
                      : (isHovered ? AppColors.primaryBorder : AppColors.border),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isHovered
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : const Color(0xFF0F172A).withValues(alpha: 0.04),
                    blurRadius: isHovered ? 18 : 10,
                    offset: isHovered ? const Offset(0, 8) : const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
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
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.2)
                                : AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            category.icon,
                            size: 20,
                            color: isSelected ? Colors.white : AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          category.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),

                        Text(
                          category.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isSelected ? Colors.white70 : AppColors.textMuted,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white24
                                : AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category.testCountText ??
                                "${category.courseCount} Courses",
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primaryDark,
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
