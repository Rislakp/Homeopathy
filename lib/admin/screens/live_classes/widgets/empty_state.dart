import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onSchedulePressed;

  const EmptyState({
    super.key,
    required this.onSchedulePressed,
  });
@override
Widget build(BuildContext context) {
  return Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF0FDF4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  size: 40,
                  color: Color(0xFF16A34A),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'No Live Classes Found',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'No classes match your current search/filter.\nAdjust your filters or schedule a new live class.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF4B5563),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: onSchedulePressed,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Schedule New Class'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}