
import 'package:flutter/material.dart';

class WidgetVisibilityState with ChangeNotifier {
  List<bool> _visibility = [true, true, true, true]; // Initial visibility states
  List<int> _order = [0, 1, 2]; // Initial order of widgets

  List<bool> get visibility => _visibility;
  List<int> get order => _order;

  void toggleVisibility(int index) {
    _visibility[index] = !_visibility[index];
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final int item = _order.removeAt(oldIndex);
    _order.insert(newIndex, item);
    notifyListeners();
  }
}
