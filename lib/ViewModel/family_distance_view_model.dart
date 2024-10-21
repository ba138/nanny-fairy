import 'package:flutter/material.dart';
import 'package:nanny_fairy/Repository/family_distance_repository.dart';

class FamilyDistanceViewModel extends ChangeNotifier {
  final FamilyDistanceRepository _familyDistanceRepository;

  FamilyDistanceViewModel(this._familyDistanceRepository);

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get distanceFilteredProviders =>
      _familyDistanceRepository.distanceFilterProviders;

  Future<void> filterProvidersByDistance(
      double maxDistanceKm, BuildContext context) async {
    _setLoading(true);
    try {
      await _familyDistanceRepository.filterProvidersByDistance(
          context, maxDistanceKm);
      notifyListeners(); // Notify listeners to update the UI
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchProviderDataFromFiebase() async {
    _setLoading(true);
    try {
      await _familyDistanceRepository.fetchProvidersDataFromFirebase();
      notifyListeners(); // Notify listeners to update the UI
    } finally {
      _setLoading(false);
    }
  }

  Future<void> filterProvidersByPassions(
      String passion, BuildContext context) async {
    _setLoading(true);
    try {
      await _familyDistanceRepository.filterFamiliesByPassion(passion, context);
      notifyListeners(); // Notify listeners to update the UI
    } finally {
      _setLoading(false);
    }
  }

  Future<void> filterProvidersBySinglePassions(
      String passion, double maxDistanceKm, BuildContext context) async {
    _setLoading(true);
    try {
      await _familyDistanceRepository.filterFamiliesBySinglePassion(
          passion, maxDistanceKm, context);
      notifyListeners(); // Notify listeners to update the UI
    } finally {
      _setLoading(false);
    }
  }

  Future<void> filterProviders(
      BuildContext context,
      double maxDistanceKm,
      double minRate,
      double minRating,
      double maxRate,
      List<String> selectedPassions,
      Map<String, Map<String, bool>> selectedAvailability) async {
    _setLoading(true);
    try {
      await _familyDistanceRepository.filterProviders(
        context: context,
        maxDistanceKm: maxDistanceKm,
        minRate: minRate,
        minRating: minRating,
        maxRate: maxRate,
        selectedPassions: selectedPassions,
        selectedAvailability: selectedAvailability,
      );
      notifyListeners(); // Notify listeners to update the UI
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
