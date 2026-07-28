import 'package:flutter/material.dart';

class CategoryUIProvider extends ChangeNotifier {
  int _selectedIndex = -1;
  int _hoveredIndex = -1;

  int get selectedIndex => _selectedIndex;
  int get hoveredIndex => _hoveredIndex;

  void selectCategory(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void setHoveredIndex(int index) {
    _hoveredIndex = index;
    notifyListeners();
  }

  void clearHoveredIndex() {
    _hoveredIndex = -1;
    notifyListeners();
  }

  void clearSelected() {
    _selectedIndex = -1;
    notifyListeners();
  }
}
