import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WidgetVisibilityState with ChangeNotifier {
  List<bool> _visibility = [false, false, false, false];
  List<int> _order = [0, 1, 2, 3];
  List<String> _names = ["Tasks", "Calendar", "Notes", "WebView"];
  List<bool> get visibility => _visibility;
  List<int> get order => _order;
  List<String> get names => _names;

  WidgetVisibilityState() {
    _loadState();
  }

  void toggleVisibility(int index) {
    _visibility[index] = !_visibility[index];
    notifyListeners();
    _saveState();
  }

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final int item = _order.removeAt(oldIndex);
    _order.insert(newIndex, item);
    notifyListeners();
    _saveState();
  }

  void updateName(int index, String newName) {
    _names[index] = newName;
    notifyListeners();
    _saveState();
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('visibility', jsonEncode(_visibility));
    prefs.setString('order', jsonEncode(_order));
    prefs.setString('names', jsonEncode(_names));
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final visibilityString = prefs.getString('visibility');
    final orderString = prefs.getString('order');
    final namesString = prefs.getString('names');

    if (visibilityString != null) {
      _visibility = List<bool>.from(jsonDecode(visibilityString));
    }
    if (orderString != null) {
      _order = List<int>.from(jsonDecode(orderString));
    }
    if (namesString != null) {
      _names = List<String>.from(jsonDecode(namesString));
    }
    notifyListeners();
  }
}
