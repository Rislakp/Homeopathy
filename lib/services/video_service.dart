import 'package:homeopathy/admin/models/video_model.dart';


class VideoService {
  // Mock data for initial categories/courses
  static const List<String> mockCourses = [
    'Materia Medica',
    'Repertory',
    'Organon of Medicine',
    'Pediatric Homeopathy',
    'Homeopathic Pharmacy',
    'Case Studies',
    'Chronic Diseases',
    'Practice Management',
  ];

  Future<List<VideoModel>> fetchVideos() async {
    // Simulate API network latency of 800 milliseconds
    await Future.delayed(const Duration(milliseconds: 800));
    
    return [
      VideoModel(
        id: '1',
        title: 'Introduction to Materia Medica',
        course: 'Materia Medica',
        description: 'An overview of homeopathic remedies and introduction to drug pictures.',
        duration: '15:45',
        thumbnail: 'placeholder_thumbnail_materia.png',
        videoUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
        isDemo: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      VideoModel(
        id: '2',
        title: 'Kentian Repertory Analysis & Methodology',
        course: 'Repertory',
        description: 'Detailed analysis of Kent\'s Repertory, structure, and rubric selection rules.',
        duration: '32:10',
        thumbnail: 'placeholder_thumbnail_kent.png',
        videoUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
        isDemo: false,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
      VideoModel(
        id: '3',
        title: 'Organon of Medicine - Aphorisms 1 to 10',
        course: 'Organon of Medicine',
        description: 'Unpacking Aphorisms 1-10 regarding the mission of the physician.',
        duration: '24:00',
        thumbnail: 'placeholder_thumbnail_organon.png',
        videoUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
        isDemo: true,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      VideoModel(
        id: '4',
        title: 'Pediatric Homeopathy - Common Childhood Fevers',
        course: 'Pediatric Homeopathy',
        description: 'Analyzing and prescribing remedies for acute fevers in children.',
        duration: '18:15',
        thumbnail: 'placeholder_thumbnail_pediatric.png',
        videoUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
        isDemo: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }
}
