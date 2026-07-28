class VideoModel {
  final String id;
  final String title;
  final String course;
  final String description;
  final String duration;
  final String thumbnail;
  final String videoUrl;
  final bool isDemo;
  final DateTime createdAt;

  const VideoModel({
    required this.id,
    required this.title,
    required this.course,
    required this.description,
    required this.duration,
    required this.thumbnail,
    required this.videoUrl,
    required this.isDemo,
    required this.createdAt,
  });

  VideoModel copyWith({
    String? id,
    String? title,
    String? course,
    String? description,
    String? duration,
    String? thumbnail,
    String? videoUrl,
    bool? isDemo,
    DateTime? createdAt,
  }) {
    return VideoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      course: course ?? this.course,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      thumbnail: thumbnail ?? this.thumbnail,
      videoUrl: videoUrl ?? this.videoUrl,
      isDemo: isDemo ?? this.isDemo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
