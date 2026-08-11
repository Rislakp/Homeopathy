class ApiCourse {
  final String? id; // MongoDB _id
  final String courseId;
  final String courseTitle;
  final String instructor;
  final String? category;
  final double price;
  final String? createdAt;
  final String? updatedAt;

  ApiCourse({
    this.id,
    required this.courseId,
    required this.courseTitle,
    required this.instructor,
    this.category,
    required this.price,
    this.createdAt,
    this.updatedAt,
  });

  factory ApiCourse.fromJson(Map<String, dynamic> json) {
    return ApiCourse(
      id: json['_id'] as String?,
      courseId: json['courseId'] as String? ?? '',
      courseTitle: json['courseTitle'] as String? ?? '',
      instructor: json['instructor'] as String? ?? '',
      category: json['category'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'instructor': instructor,
      if (category != null) 'category': category,
      'price': price,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }
}

class ApiModule {
  final String? id;
  final String lessonTitle;
  final String uploadFileOrLink;
  final String lessonType;
  final String? createdAt;

  ApiModule({
    this.id,
    required this.lessonTitle,
    required this.uploadFileOrLink,
    required this.lessonType,
    this.createdAt,
  });

  factory ApiModule.fromJson(Map<String, dynamic> json) {
    return ApiModule(
      id: json['_id'] as String?,
      lessonTitle: json['lessonTitle'] as String? ?? '',
      uploadFileOrLink: json['uploadFileOrLink'] as String? ?? '',
      lessonType: json['lessonType'] as String? ?? '',
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'lessonTitle': lessonTitle,
      'uploadFileOrLink': uploadFileOrLink,
      'lessonType': lessonType,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }
}

class CourseCreateResponse {
  final bool success;
  final String message;
  final ApiCourse data;

  CourseCreateResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CourseCreateResponse.fromJson(Map<String, dynamic> json) {
    return CourseCreateResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: ApiCourse.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class CourseListResponse {
  final bool success;
  final List<ApiCourse> data;

  CourseListResponse({
    required this.success,
    required this.data,
  });

  factory CourseListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List? ?? [];
    return CourseListResponse(
      success: json['success'] as bool? ?? false,
      data: list.map((e) => ApiCourse.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class CourseUpdateResponse {
  final bool success;
  final ApiCourse data;

  CourseUpdateResponse({
    required this.success,
    required this.data,
  });

  factory CourseUpdateResponse.fromJson(Map<String, dynamic> json) {
    return CourseUpdateResponse(
      success: json['success'] as bool? ?? false,
      data: ApiCourse.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class CourseDeleteResponse {
  final bool success;
  final String message;

  CourseDeleteResponse({
    required this.success,
    required this.message,
  });

  factory CourseDeleteResponse.fromJson(Map<String, dynamic> json) {
    return CourseDeleteResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }
}

class ModuleCreateResponse {
  final bool success;
  final String message;
  final ApiModule data;

  ModuleCreateResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ModuleCreateResponse.fromJson(Map<String, dynamic> json) {
    return ModuleCreateResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: ApiModule.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class CourseDetailModel {
  final ApiCourse course;
  final List<ApiModule> modules;

  CourseDetailModel({
    required this.course,
    required this.modules,
  });
}
