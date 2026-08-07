import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/question_bank/widget/model/question_model.dart';

class QuestionTableRow extends StatelessWidget {
  final Question question;
  final bool isSelected;
  final bool isAlternate;
  final ValueChanged<bool?> onSelectedChanged;

  const QuestionTableRow({
    required this.question,
    required this.isSelected,
    required this.onSelectedChanged,
    this.isAlternate = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderCol = const Color(0xFFE1E7EC);
    final Color primaryGreen = const Color(0xFF08A653);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? primaryGreen.withOpacity(0.04)
            : (isAlternate ? const Color(0xFFF9FAFB) : Colors.white),
        border: Border(bottom: BorderSide(color: borderCol)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Checkbox(
              value: isSelected,
              activeColor: primaryGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              onChanged: onSelectedChanged,
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              question.id,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172033),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                question.question,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF172033),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              question.course,
              style: const TextStyle(fontSize: 13, color: Color(0xFF172033), fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              question.subject,
              style: const TextStyle(fontSize: 13, color: Color(0xFF172033), fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              question.module,
              style: const TextStyle(fontSize: 13, color: Color(0xFF172033), fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
