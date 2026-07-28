import 'package:flutter/material.dart';
import '../models/admin_menu_item.dart';

class DrawerProvider extends ChangeNotifier {
  AdminMenuItem _selectedMenu = AdminMenuItem.dashboard;
  bool _isCollapsed = false;
  final Set<AdminMenuSection> _expandedSections = {
    AdminMenuSection.overview,
    AdminMenuSection.academics,
  };
  String _drawerSearchQuery = '';

  AdminMenuItem get selectedMenu => _selectedMenu;
  bool get isCollapsed => _isCollapsed;
  Set<AdminMenuSection> get expandedSections => _expandedSections;
  String get drawerSearchQuery => _drawerSearchQuery;

  void selectMenu(AdminMenuItem menu) {
    if (menu == AdminMenuItem.logout) {
      // Logic for logout prompt
      return;
    }
    _selectedMenu = menu;
    // Auto-expand section if not expanded
    _expandedSections.add(menu.section);
    notifyListeners();
  }

  void toggleCollapse() {
    _isCollapsed = !_isCollapsed;
    notifyListeners();
  }

  void setCollapsed(bool value) {
    _isCollapsed = value;
    notifyListeners();
  }

  void toggleSection(AdminMenuSection section) {
    if (_expandedSections.contains(section)) {
      _expandedSections.remove(section);
    } else {
      _expandedSections.add(section);
    }
    notifyListeners();
  }

  bool isSectionExpanded(AdminMenuSection section) {
    return _expandedSections.contains(section);
  }

  void setDrawerSearchQuery(String query) {
    _drawerSearchQuery = query;
    notifyListeners();
  }
}
