import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/admin/models/live_class_model.dart';
import 'package:intl/intl.dart';
import '../../../../utils/validators.dart';

class AddLiveClassDialog extends StatefulWidget {
  final Function(LiveClassModel) onSave;

  const AddLiveClassDialog({
    super.key,
    required this.onSave,
  });

  @override
  State<AddLiveClassDialog> createState() => _AddLiveClassDialogState();
}

class _AddLiveClassDialogState extends State<AddLiveClassDialog> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _instructorController = TextEditingController();
  final _meetingLinkController = TextEditingController();
  final _durationController = TextEditingController();
  final _maxStudentsController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _selectedStatus = 'Upcoming';

  final List<String> _statuses = ['Upcoming', 'Live', 'Completed', 'Cancelled'];

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
      initialDate: DateTime.now(),
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
      initialTime: TimeOfDay.now(),
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
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a class date'), backgroundColor: Color(0xFFEF4444)),
        );
        return;
      }
      if (_startTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a start time'), backgroundColor: Color(0xFFEF4444)),
        );
        return;
      }
      if (_endTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an end time'), backgroundColor: Color(0xFFEF4444)),
        );
        return;
      }

      final newClass = LiveClassModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        instructor: _instructorController.text.trim(),
        meetingLink: _meetingLinkController.text.trim(),
        date: _selectedDate!,
        startTime: _startTime!,
        endTime: _endTime!,
        duration: _durationController.text.trim(),
        enrolledStudents: 0,
        status: _selectedStatus,
        createdAt: DateTime.now(),
      );

      widget.onSave(newClass);
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
                    'Schedule Live Class',
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

              // Fields Scrollable List
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

                      // Instructor & Meeting Link Row
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

                      // Date & Duration Row
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

                      // Start Time & End Time Picker Row
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

                      // Max Students & Status Row
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
                      'Save Class',
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
