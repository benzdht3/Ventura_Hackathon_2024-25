import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  List<String> _searchValues = [];

  List<String> get searchValues => _searchValues;

  void updateSearchValues(String value) {
    _searchValues = value.split(',').map((e) => e.trim()).toList();
    notifyListeners();
  }

  void removeSearchValue(String value) {
    searchValues.remove(value);
    notifyListeners();
  }

  void addMultipleSearchValues(List<String> values) {
    searchValues.addAll(values);
    notifyListeners();
  }
}
