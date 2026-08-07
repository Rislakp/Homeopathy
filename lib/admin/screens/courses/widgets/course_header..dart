import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/courses/model/course_model.dart';
import 'package:homeopathy/admin/providers/course_management_provider.dart';
import 'package:homeopathy/services/course_api_service.dart';
import 'package:provider/provider.dart';

class CourseHeaderSection extends StatefulWidget {
  const CourseHeaderSection();

  @override
  State<CourseHeaderSection> createState() => _CourseHeaderSectionState();
}

class _CourseHeaderSectionState extends State<CourseHeaderSection> {
  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<CourseManagementNotifier>();
    final isMobile = MediaQuery.of(context).size.width < 768;

    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              const SizedBox(height: 16),
              _buildActions(context, notifier),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildTitle()),
              _buildActions(context, notifier),
            ],
          );
  }

  Widget _buildTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Course Management',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.6,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Manage all academy courses, pricing, instructors, and publishing.',
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildActions(
    BuildContext context,
    CourseManagementNotifier notifier,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.download_rounded,
            size: 18,
            color: Color(0xFF475569),
          ),
          label: const Text(
            'Export',
            style: TextStyle(
              color: Color(0xFF334155),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.file_upload_outlined,
            size: 18,
            color: Color(0xFF475569),
          ),
          label: const Text(
            'Import Courses',
            style: TextStyle(
              color: Color(0xFF334155),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.white,
          ),
        ),
      

  const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () => _showAddCourseDialog(context, notifier),
          icon: const Icon(Icons.add_rounded, size: 20, color: Colors.white),
          label: const Text(
            '+ Add Course',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF16A34A),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddCourseDialog(
    BuildContext context,
    CourseManagementNotifier notifier,
  ) {
    final titleCtrl = TextEditingController();
    final instCtrl = TextEditingController(text: 'Dr. Renu Sharma');
    final durCtrl = TextEditingController(text: '30 Hours');
    final priceCtrl = TextEditingController(text: '2499'); 

    // Instantiate API Service
    final apiService = CourseApiService();

    // Get categories excluding the "All Categories" option
    final categoryOptions = notifier.categories
        .where((cat) => cat != 'All Categories')
        .toList();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing dialog while loading
      builder: (ctx) {
        bool isLoading = false;
        String selectedCategory = categoryOptions.isNotEmpty 
            ? categoryOptions.first 
            : 'Materia Medica';

        return StatefulBuilder(
          builder: (dialogCtx, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              title: const Text(
                'Add New Course',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Course Name',
                        hintText: 'Enter course title',
                      ),
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: instCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Instructor',
                        hintText: 'Enter instructor name',
                      ),
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: categoryOptions
                          .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ))
                          .toList(),
                      onChanged: isLoading
                          ? null
                          : (val) {
                              if (val != null) {
                                setState(() {
                                  selectedCategory = val;
                                });
                              }
                            },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: durCtrl,
                            decoration: const InputDecoration(labelText: 'Duration'),
                            enabled: !isLoading,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: priceCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Price (₹)',
                              hintText: '0.00',
                            ),
                            keyboardType: TextInputType.number,
                            enabled: !isLoading,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          final title = titleCtrl.text.trim();
                          final instructor = instCtrl.text.trim();
                          final priceStr = priceCtrl.text.trim();

                          if (title.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a course name.'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }

                          if (instructor.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter an instructor name.'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }

                          final price = double.tryParse(priceStr);
                          if (price == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a valid price.'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }

                          // 1. Set loading to true and update dialog UI
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            // 2. Call the API to create the course
                            final newCourse = await apiService.createCourse(
                              courseTitle: title,
                              instructor: instructor,
                              category: selectedCategory,
                              price: price,
                            );

                            // 3. Add the returned CourseModel to the state
                            notifier.addCourse(newCourse);

                            // 4. Close the dialog
                            if (ctx.mounted) {
                              Navigator.pop(ctx);
                            }

                            // 5. Show success message on the main page context
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Course created successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            // 6. Stop loading and show error SnackBar
                            setState(() {
                              isLoading = false;
                            });

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString().replaceAll('Exception: ', '')),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Create',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}