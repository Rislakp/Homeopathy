import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class FacultyCard extends StatelessWidget {
  final Faculty faculty;

  const FacultyCard({super.key, required this.faculty});

  String _formatStudents(int count) {
    if (count >= 1000) {
      final k = count / 1000;
      return '${k % 1 == 0 ? k.toInt() : k.toStringAsFixed(1)}k+';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.teal.shade400, Colors.cyan.shade600],
              ),
              image: faculty.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(faculty.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
         AppSpacing.h16,
          Text(
            faculty.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.h4,
          Text(
            faculty.qualification,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
       AppSpacing.h12,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < faculty.rating.round()
                      ? Icons.star
                      : Icons.star_border,
                  size: 18,
                  color: Colors.orange,
                );
              }),
             AppSpacing.w10,
              Text(
                faculty.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
         
          AppSpacing.h16,
          Divider(color: Colors.grey.shade200),
         
          AppSpacing.h12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    '${faculty.experienceYears} yrs',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'Experience',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    _formatStudents(faculty.studentsCount),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'Students',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        AppSpacing.h12,
          Text(
            faculty.tags.join(' · '),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
