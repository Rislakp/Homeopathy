import 'package:flutter/material.dart';

class McqStepper extends StatelessWidget {
  final double parentWidth;

  const McqStepper({
    super.key,
    required this.parentWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Stepper card container
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E7EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: parentWidth > 600 ? parentWidth - 48 : 550,
          child: Row(
            children: [
              _buildCompletedStep("General Information"),
              _buildLine(isCompleted: true),
              _buildActiveStep("MCQ Builder"),
              _buildLine(isCompleted: false),
              _buildInactiveStep("Preview"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedStep(String label) {
    const Color blue = Color.fromARGB(255, 10, 5, 100);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 10, 5, 100),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF172033),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveStep(String label) {
    const Color blue = Color.fromARGB(255, 10, 5, 100);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color:Color.fromARGB(255, 10, 5, 100), width: 2),
          ),
          child: const Text(
            "2",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 10, 5, 100),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 10, 5, 100),
          ),
        ),
      ],
    );
  }

  Widget _buildInactiveStep(String label) {
    const Color gray = Color(0xFFD9D9D9);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: gray, width: 2),
          ),
          child: const Text(
            "3",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF667085),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF667085),
          ),
        ),
      ],
    );
  }

  Widget _buildLine({required bool isCompleted}) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        color: isCompleted ? const Color.fromARGB(255, 10, 5, 100) : const Color(0xFFE1E7EC),
      ),
    );
  }
}
