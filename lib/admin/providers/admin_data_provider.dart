import 'package:flutter/material.dart';
import '../models/admin_data_models.dart';
import '../models/admin_menu_item.dart';

class AdminDataProvider extends ChangeNotifier {
  String _searchQuery = '';
  String _activeFilter = 'All';
  int _currentPage = 1;
  int _rowsPerPage = 8;
  bool _isLoading = false;
  
  // Custom item list per menu
  final Map<AdminMenuItem, List<AdminTableRowData>> _menuDataMap = {};

  String get searchQuery => _searchQuery;
  String get activeFilter => _activeFilter;
  int get currentPage => _currentPage;
  int get rowsPerPage => _rowsPerPage;
  bool get isLoading => _isLoading;

  void setSearchQuery(String query) {
    _searchQuery = query;
    _currentPage = 1;
    notifyListeners();
  }

  void setFilter(String filter) {
    _activeFilter = filter;
    _currentPage = 1;
    notifyListeners();
  }

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void setRowsPerPage(int rows) {
    _rowsPerPage = rows;
    _currentPage = 1;
    notifyListeners();
  }

  void triggerLoading() {
    _isLoading = true;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 400), () {
      _isLoading = false;
      notifyListeners();
    });
  }

  List<AdminTableRowData> getRowsForMenu(AdminMenuItem menu) {
    if (!_menuDataMap.containsKey(menu)) {
      _menuDataMap[menu] = MockDataGenerator.getTableRowsForMenu(menu.label);
    }
    
    var rows = _menuDataMap[menu]!;
    
    // Apply Filter
    if (_activeFilter != 'All') {
      rows = rows.where((r) => r.status.toLowerCase() == _activeFilter.toLowerCase()).toList();
    }

    // Apply Search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      rows = rows.where((r) =>
        r.title.toLowerCase().contains(q) ||
        r.id.toLowerCase().contains(q) ||
        r.category.toLowerCase().contains(q) ||
        r.status.toLowerCase().contains(q)
      ).toList();
    }

    return rows;
  }

  List<AdminTableRowData> getPaginatedRowsForMenu(AdminMenuItem menu) {
    final allRows = getRowsForMenu(menu);
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    if (startIndex >= allRows.length) {
      return [];
    }
    final endIndex = (startIndex + _rowsPerPage).clamp(0, allRows.length);
    return allRows.sublist(startIndex, endIndex);
  }

  int getTotalPagesForMenu(AdminMenuItem menu) {
    final count = getRowsForMenu(menu).length;
    if (count == 0) return 1;
    return (count / _rowsPerPage).ceil();
  }

  void addNewRecord(AdminMenuItem menu, String title, String category) {
    final currentList = _menuDataMap[menu] ?? MockDataGenerator.getTableRowsForMenu(menu.label);
    final newRow = AdminTableRowData(
      id: 'WCA-${1000 + currentList.length + 1}',
      title: title,
      subtitle: 'Newly created record for ${menu.label}',
      category: category,
      date: '2026-07-21',
      status: 'Active',
      amountOrMeta: '\$250',
      statusColor: const Color(0xFF10B981),
    );
    currentList.insert(0, newRow);
    _menuDataMap[menu] = currentList;
    notifyListeners();
  }

  void deleteRecord(AdminMenuItem menu, String id) {
    if (_menuDataMap.containsKey(menu)) {
      _menuDataMap[menu]!.removeWhere((r) => r.id == id);
      notifyListeners();
    }
  }

  void resetFilters() {
    _searchQuery = '';
    _activeFilter = 'All';
    _currentPage = 1;
    notifyListeners();
  }
}
