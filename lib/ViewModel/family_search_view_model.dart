import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nanny_fairy/Models/family_search_model.dart';
import 'package:nanny_fairy/Repository/family_search_repository.dart';

class FamilySearchViewModel extends ChangeNotifier {
  final FamilySearchRepository _familySearchRepository;
  Timer? _debounce;

  FamilySearchViewModel(this._familySearchRepository);

  List<ProviderSearchModel> get users =>
      _familySearchRepository.filteredProviders;
  bool get isLoading => _familySearchRepository.isLoading;

  Future<void> fetchUsers() async {
    await _familySearchRepository.fetchUsers();
    notifyListeners();
  }

  void searchUsersByPassion(String passion) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _familySearchRepository.searchUsersByPassion(passion);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
