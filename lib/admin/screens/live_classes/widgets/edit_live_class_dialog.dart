import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/admin/models/live_class_model.dart';
import 'package:intl/intl.dart';
import '../../../../utils/validators.dart';

class EditLiveClassDialog extends StatefulWidget {
  final LiveClassModel liveClass;
  final Function(LiveClassModel) onUpdate;

  const EditLiveClassDialog({
    super.key,
    required this.liveClass,
    required this.onUpdate,
  });

  @override
  State<EditLiveClassDialog> createState() => _EditLiveClassDialogState();
}

class _EditLiveClassDialogState extends State<EditLiveClassDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _instructorController;
  late TextEditingController _meetingLinkController;
  late TextEditingController _durationController;
  late TextEditingController _maxStudentsController;

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  late String _selectedStatus;

  final List<String> _statuses = ['Upcoming', 'Live', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    final lc = widget.liveClass;
    _titleController = TextEditingController(text: lc.title);
    _descriptionController = TextEditingController(text: lc.description);
    _instructorController = TextEditingController(text: lc.instructor);
    _meetingLinkController = TextEditingController(text: lc.meetingLink);
    _durationController = TextEditingController(text: lc.duration);
    _maxStudentsController = TextEditingController(text: lc.enrolledStudents.toString()); // mock max fallback

    _selectedDate = lc.date;
    _startTime = lc.startTime;
    _endTime = lc.endTime;
    _selectedStatus = lc.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _instructorController.dispose();
    _meetingLinkController.dispose();
    _durationController.dispose();
    _maxStudentsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _startTime == null || _endTime == null) {
        return;
      }

      final updatedClass = widget.liveClass.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        instructor: _instructorController.text.trim(),
        meetingLink: _meetingLinkController.text.trim(),
        date: _selectedDate!,
        startTime: _startTime!,
        endTime: _endTime!,
        duration: _durationController.text.trim(),
        status: _selectedStatus,
      );

      widget.onUpdate(updatedClass);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        width: 550,
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Live Class',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Fields List
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Class Title
                      Text('Class Title', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _titleController,
                        decoration: _inputDecoration('Enter class title...'),
                        validator: (value) => Validators.required(value, 'Class Title'),
                      ),
                      const SizedBox(height: 16),

                      // Instructor & Link Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Instructor', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _instructorController,
                                  decoration: _inputDecoration('e.g. Dr. Kent'),
                                  validator: (value) => Validators.required(value, 'Instructor'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Meeting Link', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _meetingLinkController,
                                  decoration: _inputDecoration('https://meet.google.com/...'),
                                  validator: (value) => Validators.meetingLink(value),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Text('Description', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 2,
                        decoration: _inputDecoration('Enter class description...'),
                        validator: (value) => Validators.required(value, 'Description'),
                      ),
                      const SizedBox(height: 16),

                      // Date & Duration
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: _pickDate,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.03),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: const Color(0xFFE5E7EB)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _selectedDate == null
                                              ? 'Select Date'
                                              : DateFormat('dd MMM yyyy').format(_selectedDate!),
                                          style: GoogleFonts.inter(
                                            color: _selectedDate == null ? const Color(0xFF9CA3AF) : const Color(0xFF111827),
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFF4B5563)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Duration', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _durationController,
                                  decoration: _inputDecoration('e.g. 1h 30m'),
                                  validator: (value) => Validators.duration(value),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Start & End Time
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Start Time', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: _pickStartTime,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.03),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: const Color(0xFFE5E7EB)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _startTime == null ? 'Start' : _startTime!.format(context),
                                          style: GoogleFonts.inter(
                                            color: _startTime == null ? const Color(0xFF9CA3AF) : const Color(0xFF111827),
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF4B5563)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('End Time', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: _pickEndTime,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.03),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: const Color(0xFFE5E7EB)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _endTime == null ? 'End' : _endTime!.format(context),
                                          style: GoogleFonts.inter(
                                            color: _endTime == null ? const Color(0xFF9CA3AF) : const Color(0xFF111827),
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF4B5563)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Max Students & Status
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Max Students', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _maxStudentsController,
                                  decoration: _inputDecoration('e.g. 50'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) => Validators.maxStudents(value),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Status', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  value: _selectedStatus,
                                  items: _statuses.map((status) {
                                    return DropdownMenuItem(value: status, child: Text(status));
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() {
                                        _selectedStatus = val;
                                      });
                                    }
                                  },
                                  decoration: _inputDecoration(''),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(color: const Color(0xFF4B5563), fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Update Class',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.withOpacity(0.03),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF16A34A), width: 2),
      ),
    );
  }
}
