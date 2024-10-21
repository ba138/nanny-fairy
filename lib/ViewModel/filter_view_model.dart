import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nanny_fairy/Models/search_model.dart';
import 'package:nanny_fairy/Repository/filter_repository.dart';

class FilteredViewModel extends ChangeNotifier {
  final FilteredRepository _filteredRepository;
  Timer? _debounce;

  FilteredViewModel(this._filteredRepository);

  List<SearchModel> get filteredUsers => _filteredRepository.filteredUsers;

  void filterUsersByPassions(List<String> passions) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _filteredRepository.filterUsersByMultiplePassions(passions);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
