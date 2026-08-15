import 'package:flutter/material.dart';
import 'package:homeopathy/admin/theme/admin_colors.dart';
import 'package:provider/provider.dart';
import 'package:homeopathy/responsive/extensions.dart';
import 'provider/student_provider.dart';
import 'model/student_model.dart';
import 'widgets/search_filter_bar.dart';
import 'widgets/student_table.dart';
import 'widgets/add_edit_student_dialog.dart';
import 'widgets/delete_confirmation_dialog.dart';
import 'widgets/view_student_scores_dialog.dart';

class StudentBody extends StatelessWidget {
  const StudentBody({super.key});

  /// Opens the View Scores modal dialog for the selected student.
  void _viewStudentScores(BuildContext context, StudentModel student) {
    ViewStudentScoresDialog.show(context, student);
  }

  void _showAddStudentDialog(BuildContext context) async {
    final StudentModel? result = await showDialog<StudentModel>(
      context: context,
      barrierDismissible: false, // prevent accidental close during API call
      builder: (context) => const AddEditStudentDialog(),
    );

    // The dialog handles the API call and list refresh internally.
    // We only need to show a confirmation SnackBar on success.
    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Student "${result.name}" registered successfully.'),
          backgroundColor: AppColors.adminBlue,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }


  void _showEditStudentDialog(BuildContext context, StudentModel student) async {
    final provider = context.read<StudentProvider>();
    final StudentModel? result = await showDialog<StudentModel>(
      context: context,
      builder: (context) => AddEditStudentDialog(student: student),
    );

    if (result != null && context.mounted) {
      provider.editStudent(result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Student "${result.name}" updated successfully.'),
          backgroundColor: const Color.fromARGB(255, 10, 5, 100),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showDeleteConfirmation(BuildContext context, StudentModel student) async {
    final provider = context.read<StudentProvider>();
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmationDialog(studentName: student.name),
    );

    if (confirm == true && context.mounted) {
      provider.deleteStudent(student.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Student "${student.name}" deleted successfully.'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showExportSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export feature coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();
    final students = provider.students;

    final double padding = context.responsiveValue<double>(
      mobile: 16.0,
      tablet: 20.0,
      desktop: 24.0,
    );

    final double titleSize = context.responsiveValue<double>(
      mobile: 22.0,
      tablet: 26.0,
      desktop: 28.0,
    );

    final double spacing = context.responsiveValue<double>(
      mobile: 16.0,
      tablet: 20.0,
      desktop: 24.0,
    );

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              /*IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Color(0xFF4B5563)),
                tooltip: 'Refresh Students',
                onPressed: () => provider.refresh(),
              ),*/
            ],
          ),
          SizedBox(height: spacing),

          SearchFilterBar(
            onExportPressed: () => _showExportSnackbar(context),
            onAddStudentPressed: () => _showAddStudentDialog(context),
          ),
          SizedBox(height: spacing),

          if (provider.isLoading && students.isNotEmpty)
            LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(AppColors.adminBlue),
              minHeight: 3,
            ),

          Expanded(
            child: _buildMainContent(context, provider),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, StudentProvider provider) {
    if (provider.isLoading && provider.students.isEmpty) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation(AppColors.adminBlue),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Fetching students list...',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.errorMessage != null && provider.students.isEmpty) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          constraints: const BoxConstraints(maxWidth: 450),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 40,
                  color: Color(0xFFEF4444),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Failed to Load Students',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                provider.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => provider.refresh(),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.adminBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: StudentTable(
        students: provider.students,
        onView: (student) => _viewStudentScores(context, student),
        onEdit: (student) => _showEditStudentDialog(context, student),
        onDelete: (student) => _showDeleteConfirmation(context, student),
        onClearFilters: () => provider.resetFilters(),
      ),
    );
  }
}