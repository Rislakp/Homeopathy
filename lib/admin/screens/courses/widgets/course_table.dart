import 'package:flutter/material.dart';
import 'package:homeopathy/admin/providers/course_management_provider.dart';
import 'package:provider/provider.dart';

class CourseTableSection extends StatelessWidget {
  const CourseTableSection();

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<CourseManagementNotifier>();
    final courses = notifier.filteredCourses;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 320),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
              horizontalMargin: 20,
              columnSpacing: 24,
              dataRowMaxHeight: 68,
              columns: const [
                DataColumn(label: Text('THUMBNAIL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                DataColumn(label: Text('COURSE NAME', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                DataColumn(label: Text('CATEGORY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                DataColumn(label: Text('INSTRUCTOR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                DataColumn(label: Text('DURATION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                DataColumn(label: Text('PRICE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                DataColumn(label: Text('STUDENTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                DataColumn(label: Text('RATING', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
              ],
              rows: courses.map((course) {
                final isPublished = course.status == 'Published';
                return DataRow(
                  cells: [
                    DataCell(Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: course.thumbnailBgColor.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                      child: Icon(course.thumbnailIcon, color: course.thumbnailBgColor, size: 22),
                    )),
                    DataCell(Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(course.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                        Text(course.id, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                      ],
                    )),
                    DataCell(Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                      child: Text(course.category, style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w500)),
                    )),
                    DataCell(Text(course.instructor, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF334155)))),
                    DataCell(Text(course.duration, style: const TextStyle(fontSize: 13, color: Color(0xFF475569)))),
                    DataCell(Text(course.price, style:  TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)))),
                    DataCell(Text('${course.students}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)))),
                    DataCell(Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 4),
                        Text('${course.rating}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      ],
                    )),
                    DataCell(Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPublished ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 6, height: 6, decoration: BoxDecoration(color: isPublished ? const Color(0xFF16A34A) : const Color(0xFFD97706), shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text(course.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isPublished ? const Color(0xFF15803D) : const Color(0xFFB45309))),
                        ],
                      ),
                    )),
                    DataCell(PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF64748B), size: 20),
                      onSelected: (val) {
                        if (val == 'delete') notifier.deleteCourse(course.id);
                      },
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(value: 'view', child: Text('View')),
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                      ],
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
