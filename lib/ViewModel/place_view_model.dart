import 'package:flutter/material.dart';
import 'package:nanny_fairy/Models/predicate_model.dart';
import 'package:nanny_fairy/Repository/place_repository.dart';

class PlaceViewModel extends ChangeNotifier {
  final SearchPlaceRepository _searchPlaceRepository;

  PlaceViewModel(this._searchPlaceRepository);
  String? get providerAddress => _searchPlaceRepository.proAddress;
  List<PredictedPlaces> get placePredictedList =>
      _searchPlaceRepository.placePridList;
  Future<void> findPlaceAutoCompleteSearch(String input) async {
    try {
      await _searchPlaceRepository.findPlaceAutoCompleteSearch(input);
      notifyListeners();
    } catch (e) {}
  }

  Future<void> filterFamiliesByDistance(
      String? placeId, BuildContext context) async {
    try {
      await _searchPlaceRepository.getPlaceDirectionDetails(placeId, context);
      notifyListeners();
    } catch (e) {}
  }
}
