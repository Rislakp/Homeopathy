library;

/// Data Models for Students, Enrolled Courses, Subscriptions, and Exam Scores

typedef Student = StudentModel;
typedef Course = EnrolledCourse;
typedef Subscription = StudentSubscription;

/// Represents an enrolled course in a student's profile.
class EnrolledCourse {
  final String id;
  final String title;
  final String category;
  final double price;

  const EnrolledCourse({
    this.id = '',
    this.title = '',
    this.category = '',
    this.price = 0.0,
  });

  factory EnrolledCourse.fromJson(dynamic json) {
    if (json == null) return const EnrolledCourse();
    if (json is String) {
      return EnrolledCourse(title: json);
    }
    if (json is Map<String, dynamic>) {
      return EnrolledCourse(
        id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
        title: json['title']?.toString() ?? json['courseTitle']?.toString() ?? json['name']?.toString() ?? '',
        category: json['category']?.toString() ?? '',
        price: (json['price'] is num) ? (json['price'] as num).toDouble() : (double.tryParse(json['price']?.toString() ?? '0') ?? 0.0),
      );
    }
    return const EnrolledCourse();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'price': price,
    };
  }

  EnrolledCourse copyWith({
    String? id,
    String? title,
    String? category,
    double? price,
  }) {
    return EnrolledCourse(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      price: price ?? this.price,
    );
  }
}

/// Represents the subscription status and tier for a student.
class StudentSubscription {
  final String status;
  final String type;
  final DateTime? joinedDate;

  const StudentSubscription({
    this.status = 'Active',
    this.type = 'VIP',
    this.joinedDate,
  });

  factory StudentSubscription.fromJson(dynamic json) {
    if (json == null) return const StudentSubscription();
    if (json is String) {
      return StudentSubscription(type: json, status: 'Active');
    }
    if (json is Map<String, dynamic>) {
      DateTime? parsedDate;
      if (json['joined_date'] != null || json['joinedDate'] != null) {
        final rawDate = json['joined_date'] ?? json['joinedDate'];
        parsedDate = DateTime.tryParse(rawDate.toString());
      }
      return StudentSubscription(
        status: json['status']?.toString() ?? 'Active',
        type: json['type']?.toString() ?? json['plan']?.toString() ?? 'VIP',
        joinedDate: parsedDate,
      );
    }
    return const StudentSubscription();
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'type': type,
      if (joinedDate != null) 'joined_date': joinedDate!.toIso8601String(),
    };
  }

  StudentSubscription copyWith({
    String? status,
    String? type,
    DateTime? joinedDate,
  }) {
    return StudentSubscription(
      status: status ?? this.status,
      type: type ?? this.type,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }
}

/// Represents an attended exam score record for a student.
class ExamScore {
  final String examId;
  final String title;
  final double score;
  final double totalMarks;
  final int totalAttempted;
  final int totalCorrect;
  final int totalWrong;
  final double percentage;
  final String status;
  final DateTime? submittedAt;

  const ExamScore({
    this.examId = '',
    required this.title,
    required this.score,
    required this.totalMarks,
    this.totalAttempted = 0,
    this.totalCorrect = 0,
    this.totalWrong = 0,
    this.percentage = 0.0,
    required this.status,
    this.submittedAt,
  });

  factory ExamScore.fromJson(Map<String, dynamic> json) {
    final double rawScore = (json['score'] is num)
        ? (json['score'] as num).toDouble()
        : (double.tryParse(json['score']?.toString() ?? '0') ?? 0.0);

    final double rawTotalMarks = (json['total_marks'] is num || json['totalMarks'] is num)
        ? ((json['total_marks'] ?? json['totalMarks']) as num).toDouble()
        : (double.tryParse((json['total_marks'] ?? json['totalMarks'])?.toString() ?? '0') ?? 0.0);

    double calcPct = 0.0;
    if (json['percentage'] is num) {
      calcPct = (json['percentage'] as num).toDouble();
    } else if (json['percentage'] != null) {
      calcPct = double.tryParse(json['percentage'].toString()) ?? 0.0;
    } else if (rawTotalMarks > 0) {
      calcPct = (rawScore / rawTotalMarks) * 100;
    }

    DateTime? parsedDate;
    final dateStr = json['submitted_at'] ?? json['submittedAt'] ?? json['date'];
    if (dateStr != null) {
      parsedDate = DateTime.tryParse(dateStr.toString());
    }

    return ExamScore(
      examId: json['exam_id']?.toString() ?? json['examId']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Exam',
      score: rawScore,
      totalMarks: rawTotalMarks,
      totalAttempted: (json['total_attempted'] ?? json['totalAttempted'] ?? 0) is num
          ? ((json['total_attempted'] ?? json['totalAttempted']) as num).toInt()
          : (int.tryParse((json['total_attempted'] ?? json['totalAttempted'])?.toString() ?? '0') ?? 0),
      totalCorrect: (json['total_correct'] ?? json['totalCorrect'] ?? 0) is num
          ? ((json['total_correct'] ?? json['totalCorrect']) as num).toInt()
          : (int.tryParse((json['total_correct'] ?? json['totalCorrect'])?.toString() ?? '0') ?? 0),
      totalWrong: (json['total_wrong'] ?? json['totalWrong'] ?? 0) is num
          ? ((json['total_wrong'] ?? json['totalWrong']) as num).toInt()
          : (int.tryParse((json['total_wrong'] ?? json['totalWrong'])?.toString() ?? '0') ?? 0),
      percentage: calcPct,
      status: json['status']?.toString() ?? (calcPct >= 50 ? 'Passed' : 'Failed'),
      submittedAt: parsedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exam_id': examId,
      'title': title,
      'score': score,
      'total_marks': totalMarks,
      'total_attempted': totalAttempted,
      'total_correct': totalCorrect,
      'total_wrong': totalWrong,
      'percentage': percentage,
      'status': status,
      if (submittedAt != null) 'submitted_at': submittedAt!.toIso8601String(),
    };
  }

  ExamScore copyWith({
    String? examId,
    String? title,
    double? score,
    double? totalMarks,
    int? totalAttempted,
    int? totalCorrect,
    int? totalWrong,
    double? percentage,
    String? status,
    DateTime? submittedAt,
  }) {
    return ExamScore(
      examId: examId ?? this.examId,
      title: title ?? this.title,
      score: score ?? this.score,
      totalMarks: totalMarks ?? this.totalMarks,
      totalAttempted: totalAttempted ?? this.totalAttempted,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalWrong: totalWrong ?? this.totalWrong,
      percentage: percentage ?? this.percentage,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }
}

/// Represents high-level student performance statistics.
class StudentStats {
  final int totalExamsAttended;
  final double averageScore;
  final int passedExams;

  const StudentStats({
    this.totalExamsAttended = 0,
    this.averageScore = 0.0,
    this.passedExams = 0,
  });

  factory StudentStats.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return const StudentStats();
    }
    return StudentStats(
      totalExamsAttended: (json['total_exams_attended'] ?? json['totalExamsAttended'] ?? 0) is num
          ? ((json['total_exams_attended'] ?? json['totalExamsAttended']) as num).toInt()
          : (int.tryParse((json['total_exams_attended'] ?? json['totalExamsAttended'])?.toString() ?? '0') ?? 0),
      averageScore: (json['average_score'] ?? json['averageScore'] ?? 0) is num
          ? ((json['average_score'] ?? json['averageScore']) as num).toDouble()
          : (double.tryParse((json['average_score'] ?? json['averageScore'])?.toString() ?? '0') ?? 0.0),
      passedExams: (json['passed_exams'] ?? json['passedExams'] ?? 0) is num
          ? ((json['passed_exams'] ?? json['passedExams']) as num).toInt()
          : (int.tryParse((json['passed_exams'] ?? json['passedExams'])?.toString() ?? '0') ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_exams_attended': totalExamsAttended,
      'average_score': averageScore,
      'passed_exams': passedExams,
    };
  }
}

/// Main Student model representing a student in the admin dashboard.
class StudentModel {
  final String id;
  final String studentId;
  final String name;
  final String email;
  final String phone;
  final String? dateOfBirth;
  final String? qualification;
  final String? profileImage;
  final EnrolledCourse enrolledCourse;
  final StudentSubscription subscriptionDetails;
  final StudentStats stats;
  final List<ExamScore> attendedExams;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Internal storage for direct string properties if passed directly
  final String? _explicitCourse;
  final String? _explicitSubscription;
  final String? _explicitStatus;
  final String? _explicitAvatarText;

  StudentModel({
    required this.id,
    String? studentId,
    required this.name,
    required this.email,
    required this.phone,
    this.dateOfBirth,
    this.qualification,
    this.profileImage,
    EnrolledCourse? enrolledCourse,
    StudentSubscription? subscriptionDetails,
    StudentStats? stats,
    List<ExamScore>? attendedExams,
    this.createdAt,
    this.updatedAt,
    // Backward compatibility params
    String? course,
    String? subscription,
    String? status,
    String? avatarText,
  })  : studentId = studentId ?? id,
        _explicitCourse = course,
        _explicitSubscription = subscription,
        _explicitStatus = status,
        _explicitAvatarText = avatarText,
        enrolledCourse = enrolledCourse ?? EnrolledCourse(title: course ?? ''),
        subscriptionDetails = subscriptionDetails ??
            StudentSubscription(
              status: status ?? 'Active',
              type: subscription ?? 'VIP',
            ),
        stats = stats ?? const StudentStats(),
        attendedExams = attendedExams ?? const [];

  /// Get course title (backward-compatible)
  String get course {
    if (enrolledCourse.title.isNotEmpty) return enrolledCourse.title;
    final explicit = _explicitCourse;
    if (explicit != null && explicit.isNotEmpty) return explicit;
    return 'General Course';
  }

  /// Get subscription tier/type (backward-compatible)
  String get subscription {
    if (subscriptionDetails.type.isNotEmpty) return subscriptionDetails.type;
    final explicit = _explicitSubscription;
    if (explicit != null && explicit.isNotEmpty) return explicit;
    return 'VIP';
  }

  /// Get subscription/account status (backward-compatible)
  String get status {
    if (subscriptionDetails.status.isNotEmpty) return subscriptionDetails.status;
    final explicit = _explicitStatus;
    if (explicit != null && explicit.isNotEmpty) return explicit;
    return 'Active';
  }

  /// Alias for attended exams
  List<ExamScore> get exams => attendedExams;

  /// Get avatar text / initials
  String get avatarText {
    final explicit = _explicitAvatarText;
    if (explicit != null && explicit.isNotEmpty) {
      return explicit;
    }
    return initials;
  }

  /// Derive 2-letter initials from name
  String get initials {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    final filtered = parts.where((part) {
      final norm = part.toLowerCase();
      return norm != 'dr.' && norm != 'dr' && norm != 'mr.' && norm != 'mr' && norm != 'ms.' && norm != 'ms';
    }).toList();

    final toUse = filtered.isNotEmpty ? filtered : parts;
    if (toUse.length >= 2) {
      return '${toUse[0][0]}${toUse[1][0]}'.toUpperCase();
    }
    if (toUse[0].length >= 2) {
      return toUse[0].substring(0, 2).toUpperCase();
    }
    return toUse[0][0].toUpperCase();
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    // ID handling
    final id = json['id']?.toString() ?? json['_id']?.toString() ?? json['student_id']?.toString() ?? '';
    final studentId = json['student_id']?.toString() ?? id;

    // Contact handling
    final phone = json['phone']?.toString() ?? json['contact_number']?.toString() ?? json['contactNumber']?.toString() ?? '';

    // Profile Image / Avatar
    final profileImage = json['profile_image']?.toString() ?? json['profileImage']?.toString() ?? json['avatar']?.toString();

    // Enrolled Course parsing
    EnrolledCourse parsedCourse;
    if (json['enrolled_course'] != null) {
      parsedCourse = EnrolledCourse.fromJson(json['enrolled_course']);
    } else if (json['course'] != null) {
      parsedCourse = EnrolledCourse.fromJson(json['course']);
    } else {
      parsedCourse = const EnrolledCourse();
    }

    // Subscription parsing
    final String resolvedStatus = json['status']?.toString() ??
        (json['subscription'] is Map ? json['subscription']['status']?.toString() : null) ??
        'Active';

    StudentSubscription parsedSubscription;
    if (json['subscription'] != null) {
      if (json['subscription'] is String) {
        parsedSubscription = StudentSubscription(
          type: json['subscription'].toString(),
          status: resolvedStatus,
        );
      } else {
        parsedSubscription = StudentSubscription.fromJson(json['subscription']);
        if (json['status'] != null) {
          parsedSubscription = parsedSubscription.copyWith(status: resolvedStatus);
        }
      }
    } else {
      parsedSubscription = StudentSubscription(
        status: resolvedStatus,
        type: 'VIP',
      );
    }

    // Stats parsing
    final stats = StudentStats.fromJson(json['stats']);

    // Attended Exams parsing
    List<ExamScore> exams = [];
    final examsData = json['attended_exams'] ?? json['attendedExams'] ?? json['exams'];
    if (examsData is List) {
      exams = examsData.map((e) => ExamScore.fromJson(e as Map<String, dynamic>)).toList();
    }

    // Dates
    DateTime? createdAt;
    if (json['created_at'] != null || json['createdAt'] != null) {
      createdAt = DateTime.tryParse((json['created_at'] ?? json['createdAt']).toString());
    }

    DateTime? updatedAt;
    if (json['updated_at'] != null || json['updatedAt'] != null) {
      updatedAt = DateTime.tryParse((json['updated_at'] ?? json['updatedAt']).toString());
    }

    return StudentModel(
      id: id,
      studentId: studentId,
      name: json['name']?.toString() ?? 'Unnamed Student',
      email: json['email']?.toString() ?? '',
      phone: phone,
      dateOfBirth: json['date_of_birth']?.toString() ?? json['dateOfBirth']?.toString(),
      qualification: json['qualification']?.toString(),
      profileImage: profileImage,
      enrolledCourse: parsedCourse,
      subscriptionDetails: parsedSubscription,
      stats: stats,
      attendedExams: exams,
      createdAt: createdAt,
      updatedAt: updatedAt,
      course: parsedCourse.title,
      subscription: parsedSubscription.type,
      status: resolvedStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'name': name,
      'email': email,
      'phone': phone,
      'contact_number': phone,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (qualification != null) 'qualification': qualification,
      if (profileImage != null) 'profile_image': profileImage,
      'enrolled_course': enrolledCourse.toJson(),
      'subscription': subscriptionDetails.toJson(),
      'stats': stats.toJson(),
      'attended_exams': attendedExams.map((e) => e.toJson()).toList(),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  StudentModel copyWith({
    String? id,
    String? studentId,
    String? name,
    String? email,
    String? phone,
    String? dateOfBirth,
    String? qualification,
    String? profileImage,
    EnrolledCourse? enrolledCourse,
    StudentSubscription? subscriptionDetails,
    StudentStats? stats,
    List<ExamScore>? attendedExams,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? course,
    String? subscription,
    String? status,
    String? avatarText,
  }) {
    return StudentModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      qualification: qualification ?? this.qualification,
      profileImage: profileImage ?? this.profileImage,
      enrolledCourse: enrolledCourse ?? (course != null ? EnrolledCourse(title: course) : this.enrolledCourse),
      subscriptionDetails: subscriptionDetails ??
          (subscription != null || status != null
              ? this.subscriptionDetails.copyWith(type: subscription, status: status)
              : this.subscriptionDetails),
      stats: stats ?? this.stats,
      attendedExams: attendedExams ?? this.attendedExams,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      course: course ?? (enrolledCourse != null ? enrolledCourse.title : this.course),
      subscription: subscription ?? (subscriptionDetails != null ? subscriptionDetails.type : this.subscription),
      status: status ?? (subscriptionDetails != null ? subscriptionDetails.status : this.status),
      avatarText: avatarText ?? _explicitAvatarText,
    );
  }
}

/// Pagination metadata from the students API.
class PaginationMeta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  const PaginationMeta({
    this.total = 0,
    this.page = 1,
    this.limit = 10,
    this.totalPages = 1,
    this.hasNext = false,
    this.hasPrev = false,
  });

  factory PaginationMeta.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return const PaginationMeta();
    }
    return PaginationMeta(
      total: (json['total'] ?? 0) is num ? (json['total'] as num).toInt() : (int.tryParse(json['total']?.toString() ?? '0') ?? 0),
      page: (json['page'] ?? 1) is num ? (json['page'] as num).toInt() : (int.tryParse(json['page']?.toString() ?? '1') ?? 1),
      limit: (json['limit'] ?? 10) is num ? (json['limit'] as num).toInt() : (int.tryParse(json['limit']?.toString() ?? '10') ?? 10),
      totalPages: (json['total_pages'] ?? json['totalPages'] ?? 1) is num
          ? ((json['total_pages'] ?? json['totalPages']) as num).toInt()
          : (int.tryParse((json['total_pages'] ?? json['totalPages'])?.toString() ?? '1') ?? 1),
      hasNext: json['has_next'] == true || json['hasNext'] == true,
      hasPrev: json['has_prev'] == true || json['hasPrev'] == true,
    );
  }
}
