import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/grandmocktest/provider/test_provider.dart';
import 'package:provider/provider.dart';

class GrandMockPage extends StatelessWidget {
  const GrandMockPage({super.key});

  // ============================================================
  // COLORS & THEME
  // ============================================================
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color darkText = Color(0xFF0F172A);
  static const Color secondaryText = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color background = Color(0xFFF8FAFC);
  static const Color lightBlue = Color(0xFFEFF6FF);
  static const Color successGreen = Color(0xFF10B981);
  static const Color dangerRed = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Grand Mock Test Builder',
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: Consumer<GrandMockProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _stepIndicator(provider.currentStep, provider),
              const Divider(height: 1, color: borderColor),
              Expanded(child: _buildStep(context, provider)),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // BUILD STEP
  // ============================================================
  Widget _buildStep(BuildContext context, GrandMockProvider provider) {
    switch (provider.currentStep) {
      case 0:
        return _pdfStep(context, provider);
      case 1:
        return _detailsStep(context, provider);
      case 2:
        return _previewStep(context, provider);
      default:
        return const SizedBox();
    }
  }

  // ============================================================
  // STEP INDICATOR
  // ============================================================
  Widget _stepIndicator(int currentStep, GrandMockProvider provider) {
    const List<String> steps = [
      '1. Upload PDF',
      '2. Exam Details',
      '3. MCQ Preview & Edit',
    ];

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(steps.length, (index) {
            final bool active = index <= currentStep;
            final bool isCurrent = index == currentStep;

            return Padding(
              padding: const EdgeInsets.only(right: 28),
              child: InkWell(
                onTap: () {
                  // Allow tapping to previous completed steps or if questions exist
                  if (index <= currentStep || (index == 2 && provider.questions.isNotEmpty)) {
                    provider.setStep(index);
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active ? primaryBlue : const Color(0xFFF1F5F9),
                        border: isCurrent
                            ? Border.all(color: primaryBlue.withValues(alpha: 0.3), width: 4)
                            : null,
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: active ? Colors.white : secondaryText,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      steps[index],
                      style: TextStyle(
                        color: active ? darkText : secondaryText,
                        fontWeight: isCurrent ? FontWeight.w700 : (active ? FontWeight.w600 : FontWeight.w400),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ============================================================
  // STEP 1: PDF UPLOAD & EXTRACTION
  // ============================================================
  Widget _pdfStep(BuildContext context, GrandMockProvider provider) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(36),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: lightBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.picture_as_pdf_rounded,
                        size: 44,
                        color: primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Upload Question Paper (PDF)',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Upload a PDF document to automatically extract and generate MCQs.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: secondaryText, fontSize: 14),
                    ),
                    const SizedBox(height: 24),

                    // Display selected file info if available
                    if (provider.selectedPdf != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.insert_drive_file, color: primaryBlue, size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    provider.selectedPdf!.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: darkText,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${(provider.selectedPdf!.size / 1024).toStringAsFixed(1)} KB',
                                    style: const TextStyle(color: secondaryText, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: secondaryText, size: 20),
                              onPressed: provider.isParsing ? null : provider.clearPdf,
                              tooltip: 'Remove file',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Pick PDF Button
                    ElevatedButton.icon(
                      onPressed: provider.isParsing
                          ? null
                          : () async {
                              try {
                                final result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: const ['pdf'],
                                  allowMultiple: false,
                                  withData: true, // Required for Web & in-memory bytes
                                );

                                if (result == null || result.files.isEmpty) {
                                  return;
                                }

                                final file = result.files.single;

                                // Validate file size (e.g. 50 MB limit)
                                const int maxSizeBytes = 50 * 1024 * 1024;
                                if (file.size > maxSizeBytes) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Selected PDF exceeds the 50 MB limit.'),
                                        backgroundColor: dangerRed,
                                      ),
                                    );
                                  }
                                  return;
                                }

                                // Validate filename extension
                                final fileName = file.name.toLowerCase();
                                if (!fileName.endsWith('.pdf')) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Only files with a .pdf extension are allowed.'),
                                        backgroundColor: dangerRed,
                                      ),
                                    );
                                  }
                                  return;
                                }

                                provider.setPdf(file);
                              } catch (e) {
                                debugPrint('Error selecting PDF file: $e');
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('File selection failed: $e'),
                                      backgroundColor: dangerRed,
                                    ),
                                  );
                                }
                              }
                            },
                      icon: const Icon(Icons.file_upload_outlined),
                      label: Text(provider.selectedPdf == null ? 'Choose PDF File' : 'Change PDF File'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Error display if extraction previously failed
              if (provider.lastExtractionError != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFECACA)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.error_outline, color: dangerRed, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PDF Extraction Error',
                              style: TextStyle(
                                color: dangerRed,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              provider.lastExtractionError!,
                              style: const TextStyle(
                                color: Color(0xFF991B1B),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Bottom Action Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (provider.isParsing) ...[
                    const CircularProgressIndicator(color: primaryBlue),
                    const SizedBox(width: 16),
                    const Text(
                      'Extracting MCQs from PDF...',
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ] else ...[
                    _primaryButton(
                      text: 'Extract MCQs & Continue',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: () async {
                        if (provider.selectedPdf == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a PDF file first.'),
                              backgroundColor: dangerRed,
                            ),
                          );
                          return;
                        }

                        try {
                          await provider.extractQuestionsFromPdf();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Successfully extracted ${provider.questions.length} questions!',
                                ),
                                backgroundColor: successGreen,
                              ),
                            );
                            provider.nextStep();
                          }
                        } catch (e) {
                          final cleanError = e.toString().replaceFirst('Exception: ', '');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Extraction Failed: $cleanError'),
                                backgroundColor: dangerRed,
                                duration: const Duration(seconds: 5),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STEP 2: EXAM DETAILS
  // ============================================================
  Widget _detailsStep(BuildContext context, GrandMockProvider provider) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Grand Mock Test Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Configure test parameters and metadata before reviewing questions.',
                style: TextStyle(color: secondaryText, fontSize: 14),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _input(
                      label: 'Exam Title',
                      hintText: 'e.g. Materia Medica Grand Mock Exam 2026',
                      initialValue: provider.title,
                      onChanged: provider.setTitle,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _input(
                            label: 'Marks per Question',
                            initialValue: provider.marksPerQuestion.toString(),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (val) {
                              provider.setMarks(double.tryParse(val) ?? 1.0);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _input(
                            label: 'Duration (Minutes)',
                            initialValue: provider.durationMinutes.toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              provider.setDuration(int.tryParse(val) ?? 60);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _input(
                      label: 'Total Questions Count',
                      initialValue: provider.questions.isNotEmpty
                          ? provider.questions.length.toString()
                          : provider.numberOfQuestions.toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        provider.setQuestionCount(int.tryParse(val) ?? provider.questions.length);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: provider.previousStep,
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text('Back to PDF'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: darkText,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: borderColor),
                    ),
                  ),
                  _primaryButton(
                    text: 'Preview & Edit MCQs',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () {
                      if (provider.title.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter an exam title.'),
                            backgroundColor: dangerRed,
                          ),
                        );
                        return;
                      }
                      provider.nextStep();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STEP 3: MCQ PREVIEW & EDIT
  // ============================================================
  Widget _previewStep(BuildContext context, GrandMockProvider provider) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960),
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.title.trim().isEmpty ? 'Grand Mock MCQ Preview' : provider.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: darkText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${provider.durationMinutes} mins  •  ${provider.marksPerQuestion} mark/question  •  ${provider.questions.length} total questions',
                          style: const TextStyle(color: secondaryText, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  // ElevatedButton.icon(
                  //   onPressed: () {
                  //     _showEditQuestionDialog(context, provider, null, -1);
                  //   },
                  //   icon: const Icon(Icons.add, size: 18),
                  //   label: const Text('Add Question'),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: primaryBlue,
                  //     foregroundColor: Colors.white,
                  //     elevation: 0,
                  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  //   ),
                  // ),
                ],
              ),
            ),
            const Divider(height: 1, color: borderColor),

            // Questions List
            Expanded(
              child: provider.questions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.quiz_outlined, size: 64, color: secondaryText),
                          const SizedBox(height: 16),
                          const Text(
                            'No MCQ questions found.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: darkText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'You can add questions manually or re-upload a PDF.',
                            style: TextStyle(color: secondaryText, fontSize: 14),
                          ),
                         
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: provider.questions.length,
                      itemBuilder: (context, index) {
                        return _questionPreviewCard(
                          context,
                          index,
                          provider.questions[index],
                          provider,
                        );
                      },
                    ),
            ),

            // Bottom Publish Action Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: provider.isPublishing ? null : provider.previousStep,
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text('Back to Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: darkText,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: borderColor),
                    ),
                  ),
                  provider.isPublishing
                      ? const Row(
                          children: [
                            CircularProgressIndicator(color: primaryBlue),
                            SizedBox(width: 14),
                            Text(
                              'Publishing Exam...',
                              style: TextStyle(
                                color: primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : _primaryButton(
                          text: 'Publish Grand Mock Exam',
                          icon: Icons.check_circle_outline,
                          onPressed: () async {
                            if (provider.title.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please provide an exam title.'),
                                  backgroundColor: dangerRed,
                                ),
                              );
                              return;
                            }
                            if (provider.questions.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Add at least one question before publishing.'),
                                  backgroundColor: dangerRed,
                                ),
                              );
                              return;
                            }

                            try {
                              await provider.publishMockExam();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Grand Mock Exam published successfully!'),
                                    backgroundColor: successGreen,
                                  ),
                                );
                              }
                            } catch (e) {
                              final cleanError = e.toString().replaceFirst('Exception: ', '');
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to publish: $cleanError'),
                                    backgroundColor: dangerRed,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // QUESTION PREVIEW CARD
  // ============================================================
  Widget _questionPreviewCard(
    BuildContext context,
    int index,
    AdminMCQQuestion question,
    GrandMockProvider provider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Question Number, Marks, Edit & Delete actions
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Q${index + 1}',
                  style: const TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${question.marks} ${question.marks == 1.0 ? 'Mark' : 'Marks'}',
                style: const TextStyle(color: secondaryText, fontSize: 13),
              ),
             const Spacer(),
            ],
          ),
          const SizedBox(height: 12),

          // Question Text
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: darkText,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Options A, B, C, D
          ...question.options.asMap().entries.map((entry) {
            final int optIdx = entry.key;
            final String optText = entry.value;
            final bool isCorrect = optIdx == question.correctAnswer;

            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isCorrect ? lightBlue : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isCorrect ? primaryBlue : borderColor,
                  width: isCorrect ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCorrect ? primaryBlue : const Color(0xFFF1F5F9),
                    ),
                    child: Text(
                      String.fromCharCode(65 + optIdx),
                      style: TextStyle(
                        color: isCorrect ? Colors.white : secondaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      optText.isNotEmpty ? optText : '—',
                      style: TextStyle(
                        color: darkText,
                        fontWeight: isCorrect ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (isCorrect)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check, color: primaryBlue, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Correct Answer',
                            style: TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          }),

          // Explanation (if available)
          if (question.explanation != null && question.explanation!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, color: Color(0xFFF59E0B), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Explanation',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          question.explanation!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF334155),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

 

  Widget _dialogOptionInput(
    String letter,
    TextEditingController controller,
    bool isSelected,
    VoidCallback onSelect,
  ) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? lightBlue : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? primaryBlue : borderColor,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primaryBlue : const Color(0xFF94A3B8),
                  width: isSelected ? 6 : 2,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$letter: ',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isSelected ? primaryBlue : secondaryText,
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Option text',
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DELETE CONFIRMATION
  // ============================================================
  void _confirmDelete(BuildContext context, GrandMockProvider provider, int index) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Delete Question?'),
        content: Text('Are you sure you want to delete Question ${index + 1}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Cancel', style: TextStyle(color: secondaryText)),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteQuestion(index);
              Navigator.of(dialogCtx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Question deleted.')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: dangerRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REUSABLE INPUT
  // ============================================================
  Widget _input({
    required String label,
    required String initialValue,
    required ValueChanged<String> onChanged,
    String? hintText,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
      ),
    );
  }

  // ============================================================
  // PRIMARY BUTTON
  // ============================================================
  Widget _primaryButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
      label: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
