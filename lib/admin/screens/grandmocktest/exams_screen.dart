import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/grandmocktest/provider/test_provider.dart';
import 'package:provider/provider.dart';


// class GrandMockView extends StatelessWidget {
//   const GrandMockView({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => GrandMockProvider(),

//       child: const _GrandMockPage(),
//     );
//   }
// }

class GrandMockPage extends StatelessWidget {
  const GrandMockPage();

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryBlue =
      Color(0xFF2563EB);

  static const Color darkText =
      Color(0xFF0F172A);

  static const Color secondaryText =
      Color(0xFF64748B);

  static const Color borderColor =
      Color(0xFFE2E8F0);

  static const Color background =
      Color(0xFFF8FAFC);

  static const Color lightBlue =
      Color(0xFFEFF6FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Create Grand Mock',
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: Consumer<GrandMockProvider>(
        builder: (
          context,
          provider,
          child,
        ) {
          return Column(
            children: [
              _stepIndicator(
                provider.currentStep,
              ),

              const Divider(
                height: 1,
              ),

              Expanded(
                child: _buildStep(
                  context,
                  provider,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // BUILD STEP
  // ============================================================

  Widget _buildStep(
    BuildContext context,
    GrandMockProvider provider,
  ) {
    switch (provider.currentStep) {
      case 0:
        return _detailsStep(
          context,
          provider,
        );

      case 1:
        return _pdfStep(
          context,
          provider,
        );

      case 2:
        return _mcqBuilderStep(
          context,
          provider,
        );

      case 3:
        return _previewStep(
          context,
          provider,
        );

      default:
        return const SizedBox();
    }
  }

  // ============================================================
  // STEP INDICATOR
  // ============================================================

  Widget _stepIndicator(
    int currentStep,
  ) {
    const List<String> steps = [
      'Details',
      'PDF',
      'MCQ Builder',
      'Preview',
    ];

    return Container(
      width: double.infinity,
      color: Colors.white,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      child: SingleChildScrollView(
        scrollDirection:
            Axis.horizontal,

        child: Row(
          children:
              List.generate(
            steps.length,
            (index) {
              final bool active =
                  index <= currentStep;

              return Padding(
                padding:
                    const EdgeInsets.only(
                  right: 24,
                ),

                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,

                      alignment:
                          Alignment.center,

                      decoration:
                          BoxDecoration(
                        shape:
                            BoxShape.circle,

                        color: active
                            ? primaryBlue
                            : const Color(
                                0xFFE2E8F0,
                              ),
                      ),

                      child: Text(
                        '${index + 1}',

                        style: TextStyle(
                          color: active
                              ? Colors.white
                              : secondaryText,

                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    Text(
                      steps[index],

                      style: TextStyle(
                        color: active
                            ? primaryBlue
                            : secondaryText,

                        fontWeight:
                            active
                                ? FontWeight.w700
                                : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STEP 1
  // DETAILS
  // ============================================================

  Widget _detailsStep(
    BuildContext context,
    GrandMockProvider provider,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(
          maxWidth: 800,
        ),

        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              const Text(
                'Grand Mock Details',

                style: TextStyle(
                  fontSize: 26,
                  fontWeight:
                      FontWeight.w800,
                  color: darkText,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              const Text(
                'Configure your Grand Mock before adding questions.',

                style: TextStyle(
                  color: secondaryText,
                  fontSize: 14,
                ),
              ),

              const SizedBox(
                height: 28,
              ),

              _input(
                label: 'Question Title',
                initialValue:
                    provider.title,

                onChanged:
                    provider.setTitle,
              ),

              const SizedBox(
                height: 18,
              ),

              _input(
                label:
                    'Marks per Question',

                initialValue:
                    provider
                        .marksPerQuestion
                        .toString(),

                keyboardType:
                    const TextInputType
                        .numberWithOptions(
                  decimal: true,
                ),

                onChanged: (value) {
                  provider.setMarks(
                    double.tryParse(
                          value,
                        ) ??
                        1,
                  );
                },
              ),

              const SizedBox(
                height: 18,
              ),

              _input(
                label:
                    'Duration (Minutes)',

                initialValue:
                    provider
                        .durationMinutes
                        .toString(),

                keyboardType:
                    TextInputType.number,

                onChanged: (value) {
                  provider.setDuration(
                    int.tryParse(
                          value,
                        ) ??
                        60,
                  );
                },
              ),

              const SizedBox(
                height: 18,
              ),

              _input(
                label:
                    'Number of Questions',

                initialValue:
                    provider
                        .numberOfQuestions
                        .toString(),

                keyboardType:
                    TextInputType.number,

                onChanged: (value) {
                  provider
                      .setQuestionCount(
                    int.tryParse(
                          value,
                        ) ??
                        10,
                  );
                },
              ),

              const SizedBox(
                height: 30,
              ),

              Align(
                alignment:
                    Alignment.centerRight,

                child:
                    _primaryButton(
                  text: 'Continue',
                  onPressed: () {
                    provider.nextStep();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INPUT
  // ============================================================

  Widget _input({
    required String label,
    required String initialValue,
    required ValueChanged<String>
        onChanged,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      initialValue: initialValue,

      keyboardType:
          keyboardType,

      onChanged: onChanged,

      decoration:
          InputDecoration(
        labelText: label,

        filled: true,
        fillColor: Colors.white,

        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),

          borderSide:
              const BorderSide(
            color: borderColor,
          ),
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),

          borderSide:
              const BorderSide(
            color: borderColor,
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),

          borderSide:
              const BorderSide(
            color: primaryBlue,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STEP 2
  // PDF
  // ============================================================

  Widget _pdfStep(
    BuildContext context,
    GrandMockProvider provider,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(
          maxWidth: 700,
        ),

        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(24),

          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),

              Container(
                width: double.infinity,

                padding:
                    const EdgeInsets.all(
                  45,
                ),

                decoration:
                    BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),

                  border: Border.all(
                    color: borderColor,
                  ),
                ),

                child: Column(
                  children: [
                    const Icon(
                      Icons
                          .picture_as_pdf_outlined,

                      size: 60,

                      color: primaryBlue,
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    Text(
                      provider.pdfPath ??
                          'No PDF selected',

                      textAlign:
                          TextAlign.center,

                      style:
                          const TextStyle(
                        color:
                            secondaryText,
                      ),
                    ),

                    const SizedBox(
                      height: 22,
                    ),

                    ElevatedButton.icon(
                      onPressed: () {
                        /*
                        ==================================================
                        PDF API / FILE PICKER
                        ==================================================

                        Add file_picker package.

                        final result =
                            await FilePicker.platform
                                .pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );

                        if (result != null) {
                          provider.setPdf(
                            result.files.single.path!,
                          );
                        }

                        ==================================================
                        BACKEND API

                        POST
                        /api/admin/grand-mocks/{id}/pdf

                        Type:
                        multipart/form-data

                        ==================================================
                        */

                        ScaffoldMessenger
                            .of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Connect PDF picker here',
                            ),
                          ),
                        );
                      },

                      icon:
                          const Icon(
                        Icons.upload_file,
                      ),

                      label:
                          const Text(
                        'Choose PDF',
                      ),

                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            primaryBlue,

                        foregroundColor:
                            Colors.white,

                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end,

                children: [
                  OutlinedButton(
                    onPressed:
                        provider
                            .previousStep,

                    child:
                        const Text(
                      'Back',
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  _primaryButton(
                    text: 'Continue',
                    onPressed: () {
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
  // STEP 3
  // MCQ BUILDER
  // ============================================================

  Widget _mcqBuilderStep(
    BuildContext context,
    GrandMockProvider provider,
  ) {
    return _MCQBuilder(
      provider: provider,
    );
  }

  // ============================================================
  // STEP 4
  // PREVIEW
  // ============================================================

  Widget _previewStep(
    BuildContext context,
    GrandMockProvider provider,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(
          maxWidth: 1000,
        ),

        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.all(20),

              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      provider.title
                              .trim()
                              .isEmpty
                          ? 'Grand Mock Preview'
                          : provider.title,

                      style:
                          const TextStyle(
                        fontSize: 23,
                        fontWeight:
                            FontWeight.w800,
                        color: darkText,
                      ),
                    ),
                  ),

                  Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),

                    decoration:
                        BoxDecoration(
                      color: lightBlue,

                      borderRadius:
                          BorderRadius
                              .circular(
                        20,
                      ),
                    ),

                    child: Text(
                      '${provider.questions.length} Questions',

                      style:
                          const TextStyle(
                        color:
                            primaryBlue,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child:
                  provider.questions.isEmpty
                      ? const Center(
                          child: Text(
                            'No MCQ questions added.',
                          ),
                        )
                      : ListView.builder(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 20,
                          ),

                          itemCount:
                              provider
                                  .questions
                                  .length,

                          itemBuilder:
                              (context, index) {
                            return _questionPreview(
                              index + 1,
                              provider
                                  .questions[
                                      index],
                            );
                          },
                        ),
            ),

            Padding(
              padding:
                  const EdgeInsets.all(20),

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.end,

                children: [
                  OutlinedButton(
                    onPressed:
                        provider
                            .previousStep,

                    child:
                        const Text(
                      'Back',
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  _primaryButton(
                    text: 'Publish',
                    onPressed: () {
                      /*
                      ================================================
                      PUBLISH API

                      POST
                      /api/admin/grand-mocks/{id}/publish

                      Type:
                      POST

                      Provider → ApiService → Backend
                      ================================================
                      */

                      ScaffoldMessenger
                          .of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Connect Publish API here',
                          ),
                        ),
                      );
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
  // QUESTION PREVIEW
  // ============================================================

  Widget _questionPreview(
    int number,
    AdminMCQQuestion question,
  ) {
    return Container(
      width: double.infinity,

      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),

      padding:
          const EdgeInsets.all(20),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),

        border: Border.all(
          color: borderColor,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Text(
                'Question $number',

                style:
                    const TextStyle(
                  color: primaryBlue,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const Spacer(),

              Text(
                '${question.marks} Mark',

                style:
                    const TextStyle(
                  color: secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 12,
          ),

          Text(
            question.question,

            style:
                const TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w600,
              color: darkText,
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          ...question.options
              .asMap()
              .entries
              .map(
            (entry) {
              final bool isCorrect =
                  entry.key ==
                      question.correctAnswer;

              return Container(
                width: double.infinity,

                margin:
                    const EdgeInsets.only(
                  bottom: 8,
                ),

                padding:
                    const EdgeInsets.all(
                  13,
                ),

                decoration:
                    BoxDecoration(
                  color: isCorrect
                      ? lightBlue
                      : Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),

                  border: Border.all(
                    color: isCorrect
                        ? primaryBlue
                        : borderColor,
                  ),
                ),

                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,

                      alignment:
                          Alignment.center,

                      decoration:
                          BoxDecoration(
                        shape:
                            BoxShape.circle,

                        color: isCorrect
                            ? primaryBlue
                            : const Color(
                                0xFFF1F5F9,
                              ),
                      ),

                      child: Text(
                        String.fromCharCode(
                          65 + entry.key,
                        ),

                        style:
                            TextStyle(
                          color: isCorrect
                              ? Colors.white
                              : secondaryText,

                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child: Text(
                        entry.value,

                        style:
                            const TextStyle(
                          color: darkText,
                        ),
                      ),
                    ),

                    if (isCorrect)
                      const Icon(
                        Icons.check_circle,
                        color:
                            primaryBlue,
                        size: 21,
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUTTON
  // ============================================================

  Widget _primaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,

      style:
          ElevatedButton.styleFrom(
        backgroundColor:
            primaryBlue,

        foregroundColor:
            Colors.white,

        elevation: 0,

        padding:
            const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 14,
        ),

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),
      ),

      child: Text(
        text,

        style:
            const TextStyle(
          fontWeight:
              FontWeight.w700,
        ),
      ),
    );
  }
}

// ==================================================================
// MCQ BUILDER STATEFUL WIDGET
// ==================================================================

class _MCQBuilder extends StatefulWidget {
  final GrandMockProvider provider;

  const _MCQBuilder({
    required this.provider,
  });

  @override
  State<_MCQBuilder> createState() =>
      _MCQBuilderState();
}

class _MCQBuilderState
    extends State<_MCQBuilder> {
  final TextEditingController
      questionController =
      TextEditingController();

  final TextEditingController
      optionAController =
      TextEditingController();

  final TextEditingController
      optionBController =
      TextEditingController();

  final TextEditingController
      optionCController =
      TextEditingController();

  final TextEditingController
      optionDController =
      TextEditingController();

  // ⭐ This stores the selected correct option.
  // A = 0
  // B = 1
  // C = 2
  // D = 3
  int correctAnswer = 0;

  List<TextEditingController>
      get optionControllers => [
        optionAController,
        optionBController,
        optionCController,
        optionDController,
      ];

  @override
  void dispose() {
    questionController.dispose();
    optionAController.dispose();
    optionBController.dispose();
    optionCController.dispose();
    optionDController.dispose();

    super.dispose();
  }

  // ============================================================
  // ADD QUESTION
  // ============================================================

  void _addQuestion() {
    final String question =
        questionController.text.trim();

    final List<String> options = [
      optionAController.text.trim(),
      optionBController.text.trim(),
      optionCController.text.trim(),
      optionDController.text.trim(),
    ];

    if (question.isEmpty) {
      _showError(
        'Please enter the question.',
      );
      return;
    }

    if (options.any(
      (option) => option.isEmpty,
    )) {
      _showError(
        'Please enter all four options.',
      );
      return;
    }

    widget.provider.addQuestion(
      AdminMCQQuestion(
        question: question,

        options: options,

        // ⭐ Correct answer selected by admin
        correctAnswer: correctAnswer,

        marks:
            widget.provider
                .marksPerQuestion,
      ),
    );

    // Clear fields
    questionController.clear();
    optionAController.clear();
    optionBController.clear();
    optionCController.clear();
    optionDController.clear();

    setState(() {
      correctAnswer = 0;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'MCQ added successfully',
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          const EdgeInsets.all(20),

      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(
            maxWidth: 850,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              const Text(
                'MCQ Builder',

                style:
                    TextStyle(
                  fontSize: 25,
                  fontWeight:
                      FontWeight.w800,
                  color:
                      Color(0xFF0F172A),
                ),
              ),

              const SizedBox(
                height: 6,
              ),

              const Text(
                'Create MCQ and select the correct answer.',

                style:
                    TextStyle(
                  color:
                      Color(0xFF64748B),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              _questionInput(),

              const SizedBox(
                height: 22,
              ),

              const Text(
                'Options',

                style:
                    TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w700,
                  color:
                      Color(0xFF0F172A),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // ⭐ OPTION A-D
              ...List.generate(
                4,
                (index) {
                  return _optionEditor(
                    index: index,
                    controller:
                        optionControllers[
                            index],
                  );
                },
              ),

              const SizedBox(
                height: 5,
              ),

              // ⭐ SELECTED ANSWER
              Container(
                width:
                    double.infinity,

                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFEFF6FF,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),

                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color:
                          Color(0xFF2563EB),
                      size: 19,
                    ),

                    const SizedBox(
                      width: 7,
                    ),

                    Text(
                      'Correct Answer: Option '
                      '${String.fromCharCode(
                        65 + correctAnswer,
                      )}',

                      style:
                          const TextStyle(
                        color:
                            Color(0xFF2563EB),
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 22,
              ),

              // ==================================================
              // ACTION BUTTONS
              // ==================================================

              Wrap(
                spacing: 10,
                runSpacing: 10,

                children: [
                  ElevatedButton.icon(
                    onPressed:
                        _addQuestion,

                    icon:
                        const Icon(
                      Icons.add,
                    ),

                    label:
                        const Text(
                      'Add MCQ',
                    ),

                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          const Color(
                        0xFF2563EB,
                      ),

                      foregroundColor:
                          Colors.white,

                      elevation: 0,

                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                  ),

                  OutlinedButton(
                    onPressed:
                        widget.provider
                            .previousStep,

                    child:
                        const Text(
                      'Back',
                    ),
                  ),

                  OutlinedButton(
                    onPressed: () {
                      if (widget
                          .provider
                          .questions
                          .isEmpty) {
                        _showError(
                          'Add at least one MCQ before preview.',
                        );
                        return;
                      }

                      widget.provider
                          .nextStep();
                    },

                    child:
                        const Text(
                      'Preview',
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 32,
              ),

              // ==================================================
              // ADDED QUESTIONS
              // ==================================================

              if (widget
                  .provider
                  .questions
                  .isNotEmpty)
                const Text(
                  'Added Questions',

                  style:
                      TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        Color(0xFF0F172A),
                  ),
                ),

              const SizedBox(
                height: 12,
              ),

              ...widget
                  .provider
                  .questions
                  .asMap()
                  .entries
                  .map(
                (entry) {
                  final question =
                      entry.value;

                  return _addedQuestionCard(
                    index: entry.key,
                    question: question,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // QUESTION INPUT
  // ============================================================

  Widget _questionInput() {
    return Container(
      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(14),

        border: Border.all(
          color:
              const Color(0xFFE2E8F0),
        ),
      ),

      child: TextField(
        controller:
            questionController,

        maxLines: 3,

        decoration:
            const InputDecoration(
          labelText: 'Question',

          hintText:
              'Enter your question here...',

          border:
              InputBorder.none,

          contentPadding:
              EdgeInsets.all(16),
        ),
      ),
    );
  }

  // ============================================================
  // OPTION EDITOR
  // ============================================================

  Widget _optionEditor({
    required int index,
    required TextEditingController
        controller,
  }) {
    final bool isCorrect =
        correctAnswer == index;

    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 10,
      ),

      child: GestureDetector(
        onTap: () {
          setState(() {
            correctAnswer = index;
          });
        },

        child: AnimatedContainer(
          duration:
              const Duration(
            milliseconds: 180,
          ),

          padding:
              const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7,
          ),

          decoration:
              BoxDecoration(
            color: isCorrect
                ? const Color(
                    0xFFEFF6FF,
                  )
                : Colors.white,

            borderRadius:
                BorderRadius.circular(
              12,
            ),

            border: Border.all(
              color: isCorrect
                  ? const Color(
                      0xFF2563EB,
                    )
                  : const Color(
                      0xFFE2E8F0,
                    ),

              width:
                  isCorrect
                      ? 1.5
                      : 1,
            ),
          ),

          child: Row(
            children: [
              // LETTER
              Container(
                width: 34,
                height: 34,

                alignment:
                    Alignment.center,

                decoration:
                    BoxDecoration(
                  shape:
                      BoxShape.circle,

                  color: isCorrect
                      ? const Color(
                          0xFF2563EB,
                        )
                      : const Color(
                          0xFFF1F5F9,
                        ),
                ),

                child: Text(
                  String.fromCharCode(
                    65 + index,
                  ),

                  style:
                      TextStyle(
                    color: isCorrect
                        ? Colors.white
                        : const Color(
                            0xFF475569,
                          ),

                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              // OPTION TEXT
              Expanded(
                child: TextField(
                  controller:
                      controller,

                  onTap: () {
                    setState(() {
                      correctAnswer =
                          index;
                    });
                  },

                  decoration:
                      InputDecoration(
                    hintText:
                        'Enter Option '
                        '${String.fromCharCode(
                          65 + index,
                        )}',

                    border:
                        InputBorder.none,

                    hintStyle:
                        const TextStyle(
                      color:
                          Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              // ⭐ CORRECT ANSWER TICK
              AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 180,
                ),

                width: 28,
                height: 28,

                decoration:
                    BoxDecoration(
                  shape:
                      BoxShape.circle,

                  color: isCorrect
                      ? const Color(
                          0xFF2563EB,
                        )
                      : Colors.transparent,

                  border: isCorrect
                      ? null
                      : Border.all(
                          color:
                              const Color(
                            0xFFCBD5E1,
                          ),
                        ),
                ),

                child: isCorrect
                    ? const Icon(
                        Icons.check,
                        color:
                            Colors.white,
                        size: 18,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ADDED QUESTION CARD
  // ============================================================

  Widget _addedQuestionCard({
    required int index,
    required AdminMCQQuestion
        question,
  }) {
    final correct =
        question.correctAnswer;

    return Container(
      width:
          double.infinity,

      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      padding:
          const EdgeInsets.all(16),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(14),

        border: Border.all(
          color:
              const Color(0xFFE2E8F0),
        ),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Container(
            width: 36,
            height: 36,

            alignment:
                Alignment.center,

            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFFEFF6FF,
              ),

              shape:
                  BoxShape.circle,
            ),

            child: Text(
              '${index + 1}',

              style:
                  const TextStyle(
                color:
                    Color(0xFF2563EB),
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  question.question,

                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.w600,
                    color:
                        Color(0xFF0F172A),
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(
                  'Correct: Option '
                  '${String.fromCharCode(
                    65 + correct,
                  )}',

                  style:
                      const TextStyle(
                    color:
                        Color(0xFF2563EB),
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              widget.provider
                  .deleteQuestion(
                index,
              );
            },

            icon:
                const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}