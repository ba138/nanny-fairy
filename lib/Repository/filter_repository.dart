import 'package:flutter/material.dart';
import 'package:nanny_fairy/Models/search_model.dart';
import 'package:nanny_fairy/Repository/search_repository.dart';

class FilteredRepository extends ChangeNotifier {
  final SearchRepository _searchRepository;
  List<SearchModel> _filteredUsers = [];

  FilteredRepository(this._searchRepository);

  List<SearchModel> get filteredUsers => _filteredUsers;

  void filterUsersByMultiplePassions(List<String> passions) {
    _filteredUsers = _searchRepository.users
        .where((user) => user.passions.any((passion) => passions.any(
            (query) => passion.toLowerCase().startsWith(query.toLowerCase()))))
        .toList();
    notifyListeners();
  }
}
