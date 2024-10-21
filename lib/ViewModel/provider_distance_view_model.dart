import 'package:flutter/material.dart';
import 'package:nanny_fairy/Repository/provider_distance_repository.dart';

class ProviderDistanceViewModel extends ChangeNotifier {
  final ProviderDistanceRepository _providerDistanceRepository;

  ProviderDistanceViewModel(this._providerDistanceRepository);

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get distanceFilteredFamilies =>
      _providerDistanceRepository.distanceFilteredFamilies;

  // List<Map<String, dynamic>> get searchedFamilies =>
  //     _providerDistanceRepository.searchedFamilies;

  Future<void> filterFamiliesByDistance(
      double maxDistanceKm, BuildContext context) async {
    _setLoading(true);
    try {
      await _providerDistanceRepository.filterFamiliesByDistance(
          maxDistanceKm, context);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchFamiliesFromFirebaseData() async {
    try {
      await _providerDistanceRepository.fetchFamiliesFromFirebaseData();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void searchFamiliesByPassion(
      String query, double maxDistanceKm, BuildContext context) async {
    await _providerDistanceRepository.filterFamiliesByPassion(query, context);
    notifyListeners(); // Ensure listeners are notified after the filtering is done
  }

  void filteredFamiliesByMultipleQueries(double maxDistanceKm,
      BuildContext context, List<String> queries, double totalRating) async {
    await _providerDistanceRepository
        .filterUsersByMultiplePassionsAndTotalRating(
      maxDistanceKm,
      context,
      queries,
      totalRating,
    );
    notifyListeners(); // Ensure listeners are notified after the filtering is done
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
