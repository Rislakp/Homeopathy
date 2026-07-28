import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  int selectedIndex = -1;

  void selectCategory(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void clearSelected() {
    selectedIndex = -1;
    notifyListeners();
  }
}