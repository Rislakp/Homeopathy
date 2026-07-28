import 'package:flutter/material.dart';
import 'package:homeopathy/admin/models/live_class_model.dart';
import 'package:homeopathy/services/live_class_service.dart';


class LiveClassProvider extends ChangeNotifier {
  final LiveClassService _liveClassService = LiveClassService();

  List<LiveClassModel> _allLiveClasses = [];
  List<LiveClassModel> _filteredLiveClasses = [];
  
  bool _isLoading = false;
  String _searchQuery = '';
  String _statusFilter = 'All';
  String _sortBy = 'Newest'; // 'Newest', 'Oldest', 'Date'

  // Getters
  List<LiveClassModel> get liveClasses => _filteredLiveClasses;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get statusFilter => _statusFilter;
  String get sortBy => _sortBy;

  // Load all live classes from service
  Future<void> loadLiveClasses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allLiveClasses = await _liveClassService.fetchLiveClasses();
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading live classes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new live class
  void addLiveClass(LiveClassModel newClass) {
    _allLiveClasses.insert(0, newClass);
    _applyFilters();
  }

  // Update an existing live class
  void updateLiveClass(LiveClassModel updatedClass) {
    final index = _allLiveClasses.indexWhere((lc) => lc.id == updatedClass.id);
    if (index != -1) {
      _allLiveClasses[index] = updatedClass;
      _applyFilters();
    }
  }

  // Delete a live class
  void deleteLiveClass(String id) {
    _allLiveClasses.removeWhere((lc) => lc.id == id);
    _applyFilters();
  }

  // Live search
  void searchLiveClasses(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // Filter by status
  void filterByStatus(String status) {
    _statusFilter = status;
    _applyFilters();
  }

  // Sort live classes
  void sortByDate(String sortType) {
    _sortBy = sortType;
    _applyFilters();
  }

  // Reset all filters
  void clearFilters() {
    _searchQuery = '';
    _statusFilter = 'All';
    _sortBy = 'Newest';
    _applyFilters();
  }

  // Internal filter/sort applicability helper
  void _applyFilters() {
    // 1. Apply search and status filters
    List<LiveClassModel> results = _allLiveClasses.where((lc) {
      final matchesSearch = lc.title.toLowerCase().contains(_searchQuery.trim().toLowerCase()) ||
          lc.instructor.toLowerCase().contains(_searchQuery.trim().toLowerCase()) ||
          lc.meetingLink.toLowerCase().contains(_searchQuery.trim().toLowerCase());

      final matchesStatus = _statusFilter == 'All' || lc.status.toLowerCase() == _statusFilter.toLowerCase();

      return matchesSearch && matchesStatus;
    }).toList();

    // 2. Apply sorting
    if (_sortBy == 'Newest') {
      results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (_sortBy == 'Oldest') {
      results.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } else if (_sortBy == 'Date') {
      // Sort by class date and then start time
      results.sort((a, b) {
        final dateComparison = a.date.compareTo(b.date);
        if (dateComparison != 0) return dateComparison;
        
        final aMinutes = a.startTime.hour * 60 + a.startTime.minute;
        final bMinutes = b.startTime.hour * 60 + b.startTime.minute;
        return aMinutes.compareTo(bMinutes);
      });
    }

    _filteredLiveClasses = results;
    notifyListeners();
  }
}
