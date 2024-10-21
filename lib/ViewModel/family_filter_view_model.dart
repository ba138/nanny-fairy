import 'package:flutter/material.dart';
import 'package:nanny_fairy/Models/family_search_model.dart';
import 'package:nanny_fairy/Repository/family_filter_repository.dart';

class FamilyFilterController extends ChangeNotifier {
  final FamilyFilterRepository _familyFilterRepository;

  FamilyFilterController(this._familyFilterRepository);

  Future<void> filterProviders({
    required double minRate,
    required double maxRate,
    required List<String> selectedPassions,
    required Map<String, Map<String, bool>> selectedAvailability,
    required double minRating,
  }) async {
    await _familyFilterRepository.filterProviders(
      minRate: minRate,
      maxRate: maxRate,
      selectedPassions: selectedPassions,
      selectedAvailability: selectedAvailability,
      minRating: minRate,
    );
    notifyListeners();
  }

  List<ProviderSearchModel> get filteredProviders =>
      _familyFilterRepository.filteredProviders;

  bool get isLoading => _familyFilterRepository.isLoading;
}
