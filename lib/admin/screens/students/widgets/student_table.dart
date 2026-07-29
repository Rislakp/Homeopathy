import 'package:flutter/material.dart';
import 'package:homeopathy/responsive/extensions.dart';
import '../model/student_model.dart';
import 'student_row.dart';
import 'student_mobile_card.dart';

class StudentTable extends StatelessWidget {
  final List<StudentModel> students;
  final Function(StudentModel) onView;
  final Function(StudentModel) onEdit;
  final Function(StudentModel) onDelete;
  final VoidCallback onClearFilters;

  const StudentTable({
    super.key,
    required this.students,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return _buildEmptyState();
    }

    // Using existing project responsive extensions
    final bool isMobile = context.isMobile;

    if (isMobile) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return StudentMobileCard(
            student: student,
            onView: () => onView(student),
            onEdit: () => onEdit(student),
            onDelete: () => onDelete(student),
          );
        },
      );
    } else {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(const Color(0xFFF9FAFB)),
              dataRowMinHeight: 60,
              dataRowMaxHeight: 64,
              headingRowHeight: 52,
              horizontalMargin: 20,
              columnSpacing: context.responsiveValue<double>(
                mobile: 12,
                tablet: 18,
                desktop: 24,
              ),
              dividerThickness: 1,
              columns: const [
                DataColumn(label: Text('Profile', style: _headerStyle)),
                DataColumn(label: Text('Name', style: _headerStyle)),
                DataColumn(label: Text('Email', style: _headerStyle)),
                DataColumn(label: Text('Phone', style: _headerStyle)),
                DataColumn(label: Text('Course', style: _headerStyle)),
                DataColumn(label: Text('Subscription', style: _headerStyle)),
                DataColumn(label: Text('Status', style: _headerStyle)),
                DataColumn(label: Text('Actions', style: _headerStyle)),
              ],
              rows: students.map((student) {
                return StudentRow.buildDataRow(
                  context,
                  student,
                  onView: () => onView(student),
                  onEdit: () => onEdit(student),
                  onDelete: () => onDelete(student),
                );
              }).toList(),
            ),
          ),
        ),
      );
    }
  }

  static const TextStyle _headerStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Color(0xFF4B5563),
  );

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.people_outline_rounded,
              size: 40,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'No Students Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try adjusting your search query or filter settings.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onClearFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Reset Filters'),
          ),
        ],
      ),
    );
  }
}
