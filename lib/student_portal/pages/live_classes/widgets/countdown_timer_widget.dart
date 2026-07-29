import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CountdownTimerWidget extends StatefulWidget {
  final DateTime targetTime;

  const CountdownTimerWidget({
    super.key,
    required this.targetTime,
  });

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  Timer? _timer;
  late Duration _timeRemaining;

  @override
  void initState() {
    super.initState();
    _calculateTimeRemaining();
    _startTimer();
  }

  void _calculateTimeRemaining() {
    final now = DateTime.now();
    if (widget.targetTime.isAfter(now)) {
      _timeRemaining = widget.targetTime.difference(now);
    } else {
      _timeRemaining = Duration.zero;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _calculateTimeRemaining();
        if (_timeRemaining == Duration.zero) {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F9EE),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "STARTS IN",
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6B7280),
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            _formatDuration(_timeRemaining),
            style: GoogleFonts.shareTechMono(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F9D58),
            ),
          ),
        ],
      ),
    );
  }
}
