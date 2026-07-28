import 'package:flutter/material.dart';
import 'package:homeopathy/admin/models/video_model.dart';
import 'package:homeopathy/services/video_service.dart';


class VideoProvider extends ChangeNotifier {
  final VideoService _videoService = VideoService();

  List<VideoModel> _allVideos = [];
  List<VideoModel> _filteredVideos = [];
  List<String> _courses = ['All'];
  
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCourse = 'All';

  // Getters
  List<VideoModel> get videos => _filteredVideos;
  List<String> get courses => _courses;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCourse => _selectedCourse;

  VideoProvider() {
    _courses = ['All', ...VideoService.mockCourses];
  }

  // Load videos
  Future<void> loadVideos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allVideos = await _videoService.fetchVideos();
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading videos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search videos
  void searchVideos(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // Filter by course
  void filterByCourse(String course) {
    _selectedCourse = course;
    _applyFilters();
  }

  // Upload video
  void uploadVideo(VideoModel video) {
    _allVideos.insert(0, video);
    _applyFilters();
  }

  // Update video
  void updateVideo(VideoModel updatedVideo) {
    final index = _allVideos.indexWhere((v) => v.id == updatedVideo.id);
    if (index != -1) {
      _allVideos[index] = updatedVideo;
      _applyFilters();
    }
  }

  // Delete video
  void deleteVideo(String id) {
    _allVideos.removeWhere((v) => v.id == id);
    _applyFilters();
  }

  // Clear filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCourse = 'All';
    _applyFilters();
  }

  // Helper method to apply current search and course filters
  void _applyFilters() {
    _filteredVideos = _allVideos.where((video) {
      final matchesSearch = video.title.toLowerCase().contains(_searchQuery.trim().toLowerCase()) ||
          video.description.toLowerCase().contains(_searchQuery.trim().toLowerCase()) ||
          video.course.toLowerCase().contains(_searchQuery.trim().toLowerCase());
      
      final matchesCourse = _selectedCourse == 'All' || video.course == _selectedCourse;

      return matchesSearch && matchesCourse;
    }).toList();
    
    // Sort by creation date descending
    _filteredVideos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
