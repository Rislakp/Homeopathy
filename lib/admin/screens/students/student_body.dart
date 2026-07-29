import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:homeopathy/responsive/extensions.dart';
import 'provider/student_provider.dart';
import 'model/student_model.dart';
import 'widgets/search_filter_bar.dart';
import 'widgets/student_table.dart';
import 'widgets/student_row.dart';
import 'widgets/status_chip.dart';
import 'widgets/add_edit_student_dialog.dart';
import 'widgets/delete_confirmation_dialog.dart';

class StudentBody extends StatelessWidget {
  const StudentBody({super.key});

  void _viewStudentDetails(BuildContext context, StudentModel student) {
    final avatarColor = StudentRow.getAvatarBgColor(student.name);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(28),
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Student Profile Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF9CA3AF)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: avatarColor.withOpacity(0.12),
                        child: Text(
                          student.avatarText,
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: avatarColor),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        student.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        student.email,
                        style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
                const SizedBox(height: 16),
                _detailItem('Phone Number', student.phone),
                _detailItem('Enrolled Course', student.course),
                _detailItem('Subscription Tier', student.subscription),
                _detailItem('Account Status', student.status, isStatus: true),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailItem(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
          isStatus
              ? StatusChip(status: value)
              : Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
        ],
      ),
    );
  }

  void _showAddStudentDialog(BuildContext context) async {
    final provider = context.read<StudentProvider>();
    final StudentModel? result = await showDialog<StudentModel>(
      context: context,
      builder: (context) => const AddEditStudentDialog(),
    );

    if (result != null && context.mounted) {
      provider.addStudent(result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Student "${result.name}" added successfully.'),
          backgroundColor: const Color(0xFF10B981),
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
          backgroundColor: const Color(0xFF10B981),
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

    // Use responsive extensions from project context
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
          Text(
            'Students',
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Manage enrolled students and their subscriptions.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: spacing),
          
          SearchFilterBar(
            onExportPressed: () => _showExportSnackbar(context),
            onAddStudentPressed: () => _showAddStudentDialog(context),
          ),
          SizedBox(height: spacing),
          
          Expanded(
            child: SingleChildScrollView(
              child: StudentTable(
                students: students,
                onView: (student) => _viewStudentDetails(context, student),
                onEdit: (student) => _showEditStudentDialog(context, student),
                onDelete: (student) => _showDeleteConfirmation(context, student),
                onClearFilters: () => provider.resetFilters(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
