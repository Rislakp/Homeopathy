import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/question_bank/widget/model/question_model.dart';
import 'package:homeopathy/admin/screens/question_bank/widget/table_row.dart';

class QuestionTable extends StatelessWidget {
  final List<Question> questions;
  final Set<String> selectedQuestionIds;
  final ValueChanged<String> onSelectQuestion;
  final ValueChanged<bool> onSelectAll;

  const QuestionTable({
    required this.questions,
    required this.selectedQuestionIds,
    required this.onSelectQuestion,
    required this.onSelectAll,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAllSelected = questions.isNotEmpty &&
        questions.every((q) => selectedQuestionIds.contains(q.id));
    final bool isAnySelected = questions.isNotEmpty &&
        questions.any((q) => selectedQuestionIds.contains(q.id));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E7EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000,
              child: Column(
                children: [
                  // Table Header Row
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                      border: Border(bottom: BorderSide(color: Color(0xFFE1E7EC))),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Checkbox(
                            value: isAllSelected,
                            tristate: isAnySelected && !isAllSelected,
                            activeColor: const Color(0xFF08A653),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            onChanged: (val) => onSelectAll(val ?? false),
                          ),
                        ),
                        const SizedBox(
                          width: 100,
                          child: Text(
                            "QUESTION ID",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF667085),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 4,
                          child: Text(
                            "QUESTION",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF667085),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Text(
                            "COURSE",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF667085),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Text(
                            "SUBJECT",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF667085),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Text(
                            "MODULE",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF667085),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Table Row Items
                  if (questions.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      alignment: Alignment.center,
                      child: const Text(
                        "No questions matched active filter selection.",
                        style: TextStyle(fontSize: 13.5, color: Color(0xFF667085)),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final q = questions[index];
                        final isSelected = selectedQuestionIds.contains(q.id);

                        return QuestionTableRow(
                          question: q,
                          isSelected: isSelected,
                          isAlternate: index % 2 == 1,
                          onSelectedChanged: (_) => onSelectQuestion(q.id),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),

          // Pagination Footer Row
          const Divider(height: 1, color: Color(0xFFE1E7EC)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Showing 1-${questions.length} of ${questions.length} entries",
                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF667085), fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    const Text("Rows per page: 10 ", style: TextStyle(fontSize: 12.5, color: Color(0xFF667085))),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded, size: 12),
                      color: const Color(0xFF667085),
                      onPressed: () {},
                    ),
                    const Text(
                      "Page 1",
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF172033)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded, size: 12),
                      color: const Color(0xFF667085),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}