import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/utils/app_colors.dart';
import '../course_content_screen.dart';

class AddLessonDialog extends StatefulWidget {
  const AddLessonDialog({super.key});

  @override
  State<AddLessonDialog> createState() => _AddLessonDialogState();
}

class _AddLessonDialogState extends State<AddLessonDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  
  String? _selectedModuleId;
  LessonType _selectedType = LessonType.liveClass; // Default to Live Class as requested
  String? _selectedFileName;
  
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Attempt to access CourseContentProvider safely to enable fallback mock behaviour
    CourseContentProvider? provider;
    try {
      provider = context.watch<CourseContentProvider>();
    } catch (_) {
      provider = null;
    }

    final isDark = provider?.isDarkMode ?? false;
    final dialogBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final secColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563);
    final labelColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF374151);
    final border = BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB));
    
    // Changed to Colors.white for an exact match with the screenshot's crisp UI
    final fieldBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    // Mock modules for standalone mode if provider is not present
    final modulesList = provider?.modules ?? [
      ModuleContent(id: "mod-1", title: "Module 1 — Introduction to Homeopathy", lessons: []),
      ModuleContent(id: "mod-2", title: "Module 2 — Chronic Miasms", lessons: []),
    ];

    if (_selectedModuleId == null && modulesList.isNotEmpty) {
      _selectedModuleId = modulesList.first.id;
    }

    return Dialog(
      backgroundColor: dialogBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 10,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =============================================================
                // 1. HEADER SECTION
                // =============================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add Lesson",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, size: 18),
                        color: secColor,
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(),
                        tooltip: "Close",
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),

                // =============================================================
                // 2. FORM BODY (Vertical Scrollable)
                // =============================================================
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // A. Module Dropdown
                        Text(
                          "Module",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: labelColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedModuleId,
                          dropdownColor: dialogBg,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down, color: secColor, size: 20),
                          style: GoogleFonts.inter(color: textColor, fontSize: 13),
                          decoration: _getInputDecoration(fieldBg, border),
                          items: modulesList.map((mod) {
                            return DropdownMenuItem<String>(
                              value: mod.id,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
                                      width: 0.8,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  mod.title,
                                  style: GoogleFonts.inter(
                                    color: textColor,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedModuleId = val;
                            });
                          },
                        ),

                        const SizedBox(height: 18),

                        // B. Lesson Title
                        Text(
                          "Lesson Title",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: labelColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _titleController,
                          style: GoogleFonts.inter(color: textColor, fontSize: 13),
                          validator: (val) => val == null || val.trim().isEmpty ? "Title is required" : null,
                          decoration: _getInputDecoration(fieldBg, border).copyWith(
                            hintText: "e.g. Understanding Miasms in Practice",
                            hintStyle: GoogleFonts.inter(
                              color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
                              fontSize: 13,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // C. Lesson Type Dropdown
                        Text(
                          "Lesson Type",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: labelColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<LessonType>(
                          value: _selectedType,
                          dropdownColor: dialogBg,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down, color: secColor, size: 20),
                          style: GoogleFonts.inter(color: textColor, fontSize: 13),
                          decoration: _getInputDecoration(fieldBg, border),
                          items: [
                            DropdownMenuItem(
                              value: LessonType.liveClass,
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.red.shade700, width: 0.5),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text("Live Class", style: GoogleFonts.inter(color: textColor)),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: LessonType.video,
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text("Recorded Video", style: GoogleFonts.inter(color: textColor)),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: LessonType.document,
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.orange,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text("PDF Notes", style: GoogleFonts.inter(color: textColor)),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: LessonType.quiz,
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text("Quiz Assessment", style: GoogleFonts.inter(color: textColor)),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: LessonType.assignment,
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.purple,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text("Assignment", style: GoogleFonts.inter(color: textColor)),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedType = val;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 18),

                        // D. Upload File / Link (Custom Input perfectly matched to image)
                        Text(
                          "Upload File / Link",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: labelColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFileName = _selectedFileName == null 
                                  ? "remedy_provings_guide.pdf" 
                                  : null;
                            });
                          },
                          child: InputDecorator(
                            decoration: _getInputDecoration(fieldBg, border).copyWith(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF3F4F6),
                                    border: Border.all(
                                      color: isDark ? const Color(0xFF475569) : const Color(0xFFD1D5DB),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "Choose File",
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: isDark ? Colors.white : const Color(0xFF374151),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _selectedFileName ?? "No file chosen",
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: _selectedFileName == null 
                                          ? (isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563))
                                          : textColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                
                // Divider removed to match the extremely clean layout in the image
                // =============================================================
                // 3. FOOTER SECTION (Action Buttons)
                // =============================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.inter(
                          color: secColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Add Lesson Button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() && _selectedModuleId != null) {
                          final typeLabel = _selectedType == LessonType.liveClass
                              ? "Live Class"
                              : _selectedType == LessonType.video
                                  ? "Recorded Video"
                                  : _selectedType == LessonType.document
                                      ? "PDF Notes"
                                      : _selectedType == LessonType.quiz
                                          ? "Quiz"
                                          : "Assignment";

                          final durationInfo = _selectedType == LessonType.liveClass 
                              ? "10:00 AM" 
                              : "15:00";

                          final newLesson = LessonItem(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            title: _titleController.text.trim(),
                            type: _selectedType,
                            durationText: "$typeLabel • $durationInfo",
                            status: "Published",
                            isLocked: false,
                          );

                          if (provider != null) {
                            provider.addLesson(_selectedModuleId!, newLesson);
                          }

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Lesson '${_titleController.text.trim()}' added successfully!",
                                style: GoogleFonts.inter(),
                              ),
                              backgroundColor: const Color(0xFF10B981), 
                              behavior: SnackBarBehavior.floating,
                              width: 320,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981), // Vibrant exact green match
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        "Add Lesson",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Input Field Decoration Helper
  InputDecoration _getInputDecoration(Color fieldBg, BorderSide border) {
    return InputDecoration(
      filled: true,
      fillColor: fieldBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), // Adjusted vertical padding for cleaner look
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: border,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}