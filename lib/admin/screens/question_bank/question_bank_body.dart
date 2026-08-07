
import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/question_bank/add_questions1.dart';
import 'package:homeopathy/admin/screens/question_bank/mockdata/mock_data.dart';
import 'package:homeopathy/admin/screens/question_bank/widget/filter_dropdown.dart';
import 'package:homeopathy/admin/screens/question_bank/widget/model/action_button.dart';
import 'package:homeopathy/admin/screens/question_bank/widget/model/question_model.dart';
import 'package:homeopathy/admin/screens/question_bank/widget/question_table.dart';

class QuestionBankBody extends StatefulWidget {
  const QuestionBankBody({super.key});

  @override
  State<QuestionBankBody> createState() => _QuestionBankBodyState();
}

class _QuestionBankBodyState extends State<QuestionBankBody> {
  late List<Question> _allQuestions;

  final Set<String> _selectedQuestionIds = {};

  String _searchQuery = "";

  String? _selectedCourse;
  String? _selectedSubject;
  String? _selectedModule;
  String? _selectedChapter;
  String? _selectedTopic;
  String? _selectedDifficulty;
  String? _selectedType;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _allQuestions = List.from(dummyQuestions);
  }

  // ------------------------------------------------------------
  // FILTER QUESTIONS
  // ------------------------------------------------------------

  List<Question> get _filteredQuestions {
    List<Question> list = List.from(_allQuestions);

    if (_selectedCourse != null) {
      list = list
          .where((q) => q.course == _selectedCourse)
          .toList();
    }

    if (_selectedSubject != null) {
      list = list
          .where((q) => q.subject == _selectedSubject)
          .toList();
    }

    if (_selectedModule != null) {
      list = list
          .where((q) => q.module == _selectedModule)
          .toList();
    }

    if (_selectedChapter != null) {
      list = list
          .where((q) => q.chapter == _selectedChapter)
          .toList();
    }

    if (_selectedTopic != null) {
      list = list
          .where((q) => q.topic == _selectedTopic)
          .toList();
    }

    if (_selectedDifficulty != null) {
      list = list
          .where((q) => q.difficulty == _selectedDifficulty)
          .toList();
    }

    if (_selectedType != null) {
      list = list
          .where((q) => q.type == _selectedType)
          .toList();
    }

    if (_selectedStatus != null) {
      list = list
          .where((q) => q.status == _selectedStatus)
          .toList();
    }

    // Search
    if (_searchQuery.isNotEmpty) {
      final String term = _searchQuery.toLowerCase();

      list = list
          .where(
            (q) =>
                q.id.toLowerCase().contains(term) ||
                q.question.toLowerCase().contains(term),
          )
          .toList();
    }

    return list;
  }

  // ------------------------------------------------------------
  // FEEDBACK
  // ------------------------------------------------------------

  void _showFeedback(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF08A653),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredQuestions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(filtered.length),

        const SizedBox(height: 24),

        _buildFilters(),

        const SizedBox(height: 24),

        QuestionTable(
          questions: filtered,
          selectedQuestionIds: _selectedQuestionIds,

          onSelectQuestion: (id) {
            setState(() {
              if (_selectedQuestionIds.contains(id)) {
                _selectedQuestionIds.remove(id);
              } else {
                _selectedQuestionIds.add(id);
              }
            });
          },

          onSelectAll: (val) {
            setState(() {
              if (val) {
                for (var q in filtered) {
                  _selectedQuestionIds.add(q.id);
                }
              } else {
                for (var q in filtered) {
                  _selectedQuestionIds.remove(q.id);
                }
              }
            });
          },
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader(int filteredCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Question Bank",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172033),
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "$filteredCount of ${_allQuestions.length} questions",
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF667085),
              ),
            ),
          ],
        ),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ActionButton(
              label: "Import",
              icon: Icons.download_rounded,
              onPressed: () {
                _showFeedback("Import triggered.");
              },
            ),

            const SizedBox(width: 8),

            ActionButton(
              label: "Export",
              icon: Icons.upload_rounded,
              onPressed: () {
                _showFeedback("Export triggered.");
              },
            ),

            const SizedBox(width: 8),

            ActionButton(
              label: "Bulk Upload",
              icon: Icons.cloud_upload_rounded,
              onPressed: () {
                _showFeedback("Bulk upload triggered.");
              },
            ),

            const SizedBox(width: 12),

            ActionButton(
              label: "Add Question",
              icon: Icons.add_rounded,
              isPrimary: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddQuestionsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // FILTER SECTION
  // ------------------------------------------------------------

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE1E7EC),
        ),
      ),
      child: Column(
        children: [
          // SEARCH
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFE1E7EC),
              ),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                hintText: "Search question text or ID...",
                hintStyle: TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 13,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Color(0xFF08A653),
                  size: 18,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                ),
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF172033),
              ),
            ),
          ),

          const SizedBox(height: 16),

          _buildDropdownGrid(
            MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // DROPDOWNS
  // ------------------------------------------------------------

  Widget _buildDropdownGrid(double width) {
    final List<Widget> dropdowns = [
      FilterDropdown(
        label: "Course",
        value: _selectedCourse,
        items: const [
          "All Courses",
          "MBBS Final Year",
          "NEET PG",
          "Nursing (BSc)",
        ],
        onChanged: (val) {
          setState(() {
            _selectedCourse =
                val == "All Courses" ? null : val;
          });
        },
      ),

      FilterDropdown(
        label: "Subject",
        value: _selectedSubject,
        items: const [
          "All Subjects",
          "Medicine",
          "Surgery",
        ],
        onChanged: (val) {
          setState(() {
            _selectedSubject =
                val == "All Subjects" ? null : val;
          });
        },
      ),

      FilterDropdown(
        label: "Module",
        value: _selectedModule,
        items: const [
          "All Modules",
          "Cardiology",
          "Neurology",
        ],
        onChanged: (val) {
          setState(() {
            _selectedModule =
                val == "All Modules" ? null : val;
          });
        },
      ),

      FilterDropdown(
        label: "Chapter",
        value: _selectedChapter,
        items: const [
          "All Chapters",
        ],
        onChanged: (val) {
          setState(() {
            _selectedChapter =
                val == "All Chapters" ? null : val;
          });
        },
      ),

      FilterDropdown(
        label: "Topic",
        value: _selectedTopic,
        items: const [
          "All Topics",
        ],
        onChanged: (val) {
          setState(() {
            _selectedTopic =
                val == "All Topics" ? null : val;
          });
        },
      ),

      FilterDropdown(
        label: "Difficulty",
        value: _selectedDifficulty,
        items: const [
          "All",
          "Easy",
          "Medium",
          "Hard",
        ],
        onChanged: (val) {
          setState(() {
            _selectedDifficulty =
                val == "All" ? null : val;
          });
        },
      ),

      FilterDropdown(
        label: "Question Type",
        value: _selectedType,
        items: const [
          "All Types",
          "MCQ",
          "Multiple Select",
          "True/False",
        ],
        onChanged: (val) {
          setState(() {
            _selectedType =
                val == "All Types" ? null : val;
          });
        },
      ),

      FilterDropdown(
        label: "Status",
        value: _selectedStatus,
        items: const [
          "All Statuses",
          "Active",
          "Draft",
          "Archived",
        ],
        onChanged: (val) {
          setState(() {
            _selectedStatus =
                val == "All Statuses" ? null : val;
          });
        },
      ),
    ];

    int cols = width > 1100
        ? 4
        : (width > 700 ? 2 : 1);

    if (cols == 1) {
      return Column(
        children: dropdowns
            .map(
              (widget) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: widget,
              ),
            )
            .toList(),
      );
    }

    final List<Widget> rows = [];

    for (int i = 0; i < dropdowns.length; i += cols) {
      final List<Widget> rowItems = [];

      for (int j = 0; j < cols; j++) {
        if (i + j < dropdowns.length) {
          rowItems.add(
            Expanded(
              child: dropdowns[i + j],
            ),
          );
        } else {
          rowItems.add(
            Expanded(
              child: Container(),
            ),
          );
        }

        if (j < cols - 1) {
          rowItems.add(
            const SizedBox(width: 12),
          );
        }
      }

      rows.add(
        Row(
          children: rowItems,
        ),
      );

      if (i + cols < dropdowns.length) {
        rows.add(
          const SizedBox(height: 12),
        );
      }
    }

    return Column(
      children: rows,
    );
  }
}
