import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nanny_fairy/Models/family_search_model.dart';

class FamilyFilterRepository extends ChangeNotifier {
  final DatabaseReference _familyRef =
      FirebaseDatabase.instance.ref().child('Providers');

  List<ProviderSearchModel> _filteredProviders = [];
  bool _isLoading = false;

  List<ProviderSearchModel> get filteredProviders => _filteredProviders;
  bool get isLoading => _isLoading;

  Future<void> filterProviders({
    required double minRate,
    required double maxRate,
    required double minRating,
    required List<String> selectedPassions,
    required Map<String, Map<String, bool>> selectedAvailability,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch the data from Firebase
      DataSnapshot snapshot = await _familyRef.get();
      List<ProviderSearchModel> allProviders = [];
      for (var element in snapshot.children) {
        if (element.value is Map) {
          var data = Map<String, dynamic>.from(element.value as Map);
          allProviders.add(ProviderSearchModel.fromMap(data, element.key!));
        }
      }
      debugPrint("All Providers: ${allProviders.length}");

      // Filter by hourly rate
      _filteredProviders = allProviders.where((provider) {
        double rate = double.tryParse(provider.hoursrate) ?? 0.0;
        return rate >= minRate && rate <= maxRate;
      }).toList();
      debugPrint("After rate filter: ${_filteredProviders.length}");

      // Filter by average rating
      if (minRating != null) {
        List<ProviderSearchModel> ratingFilteredProviders =
            _filteredProviders.where((provider) {
          return provider.averageRating >= minRating;
        }).toList();

        if (ratingFilteredProviders.isNotEmpty) {
          _filteredProviders = ratingFilteredProviders;
        }
        debugPrint("After rating filter: ${_filteredProviders.length}");
      }

      // Filter by passions
      if (selectedPassions.isNotEmpty) {
        List<ProviderSearchModel> passionFilteredProviders =
            _filteredProviders.where((provider) {
          return selectedPassions.every((selectedPassion) {
            return provider.passions
                .map((p) => p.toLowerCase())
                .contains(selectedPassion.toLowerCase());
          });
        }).toList();

        if (passionFilteredProviders.isNotEmpty) {
          _filteredProviders = passionFilteredProviders;
        }
        debugPrint("After passions filter: ${_filteredProviders.length}");
      }

      if (selectedAvailability.isNotEmpty) {
        List<ProviderSearchModel> availabilityFilteredProviders =
            _filteredProviders.where((provider) {
          return selectedAvailability.entries.every((timeOfDayEntry) {
            String timeOfDay = timeOfDayEntry.key;
            Map<String, bool> days = timeOfDayEntry.value;

            return days.entries.every((dayEntry) {
              String day = dayEntry.key;
              bool isSelectedAvailable = dayEntry.value;

              // Check if the provider has the same availability for the given day and timeOfDay
              bool providerAvailable =
                  provider.availability[timeOfDay]?[day] ?? false;
              return providerAvailable == isSelectedAvailable;
            });
          });
        }).toList();

        if (availabilityFilteredProviders.isNotEmpty) {
          _filteredProviders = availabilityFilteredProviders;
        }
        debugPrint("After availability filter: ${_filteredProviders.length}");
      }

      // If no providers matched, fallback to the most relaxed filter
      if (_filteredProviders.isEmpty) {
        _filteredProviders = allProviders.where((provider) {
          return (minRate != null &&
                  double.tryParse(provider.hoursrate) != null &&
                  double.parse(provider.hoursrate) >= minRate) ||
              (minRating != null && provider.averageRating >= minRating) ||
              (selectedPassions.isNotEmpty &&
                  selectedPassions.every((selectedPassion) {
                    return provider.passions
                        .map((p) => p.toLowerCase())
                        .contains(selectedPassion.toLowerCase());
                  })) ||
              (selectedAvailability.isNotEmpty &&
                  selectedAvailability.entries.every((timeOfDayEntry) {
                    String timeOfDay = timeOfDayEntry.key;
                    Map<String, bool> days = timeOfDayEntry.value;

                    return days.entries.every((dayEntry) {
                      String day = dayEntry.key;
                      bool isSelectedAvailable = dayEntry.value;

                      // Check if the provider has the same availability for the given day and timeOfDay
                      bool providerAvailable = provider
                              .availability[timeOfDay]?.entries
                              .any((providerDayEntry) {
                            return providerDayEntry.key == day &&
                                providerDayEntry.value == isSelectedAvailable;
                          }) ??
                          false;

                      return providerAvailable;
                    });
                  }));
        }).toList();
      }

      debugPrint("Final filtered providers: ${_filteredProviders.length}");
    } catch (e) {
      debugPrint("Error filtering providers: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
