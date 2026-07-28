import 'package:flutter/material.dart';

class SubscriptionProvider extends ChangeNotifier {
  bool _isSubscribed = false;

  bool get isSubscribed => _isSubscribed;

  void subscribe() {
    _isSubscribed = true;
    notifyListeners();
  }
}