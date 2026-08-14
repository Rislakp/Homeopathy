/// Model representing the evaluation summary returned by backend upon submitting an exam.
class TestResultModel {
  final String? resultId;
  final String? examId;
  final String? examTitle;
  final double score;
  final int totalMarks;
  final int totalAttempted;
  final int totalCorrect;
  final int totalWrong;
  final String status;
  final double percentage;

  const TestResultModel({
    this.resultId,
    this.examId,
    this.examTitle,
    required this.score,
    required this.totalMarks,
    required this.totalAttempted,
    required this.totalCorrect,
    required this.totalWrong,
    required this.status,
    required this.percentage,
  });

  /// Factory constructor to safely parse a [TestResultModel] from backend JSON response.
  factory TestResultModel.fromJson(Map<String, dynamic> json) {
    // Handle nested 'data' or 'result' objects if returned by backend
    final Map<String, dynamic> data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : (json['result'] is Map<String, dynamic>)
            ? json['result'] as Map<String, dynamic>
            : json;

    final double scoreVal = (data['score'] as num?)?.toDouble() ??
        (data['totalScore'] as num?)?.toDouble() ??
        (data['marksObtained'] as num?)?.toDouble() ??
        0.0;

    final int totalM = (data['totalMarks'] as num?)?.toInt() ??
        (data['maxMarks'] as num?)?.toInt() ??
        0;

    final int totalAtt = (data['totalAttempted'] as num?)?.toInt() ??
        (data['attempted'] as num?)?.toInt() ??
        (data['questionsAttempted'] as num?)?.toInt() ??
        0;

    final int totalCorr = (data['totalCorrect'] as num?)?.toInt() ??
        (data['correct'] as num?)?.toInt() ??
        (data['correctAnswers'] as num?)?.toInt() ??
        0;

    final int totalW = (data['totalWrong'] as num?)?.toInt() ??
        (data['wrong'] as num?)?.toInt() ??
        (data['incorrect'] as num?)?.toInt() ??
        0;

    final double pct = (data['percentage'] as num?)?.toDouble() ??
        (totalM > 0 ? (scoreVal / totalM) * 100 : 0.0);

    return TestResultModel(
      resultId: data['_id'] as String? ?? data['resultId'] as String?,
      examId: data['examId'] as String?,
      examTitle: data['examTitle'] as String? ?? data['title'] as String?,
      score: scoreVal,
      totalMarks: totalM,
      totalAttempted: totalAtt,
      totalCorrect: totalCorr,
      totalWrong: totalW,
      status: data['status'] as String? ?? 'Completed',
      percentage: pct,
    );
  }

  /// Converts model to JSON map.
  Map<String, dynamic> toJson() {
    return {
      if (resultId != null) '_id': resultId,
      if (examId != null) 'examId': examId,
      if (examTitle != null) 'examTitle': examTitle,
      'score': score,
      'totalMarks': totalMarks,
      'totalAttempted': totalAttempted,
      'totalCorrect': totalCorrect,
      'totalWrong': totalWrong,
      'status': status,
      'percentage': percentage,
    };
  }

  @override
  String toString() {
    return 'TestResultModel(score: $score/$totalMarks, attempted: $totalAttempted, correct: $totalCorrect, wrong: $totalWrong)';
  }
}
