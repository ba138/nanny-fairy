import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:nanny_fairy/Models/family_search_model.dart';

class FamilySearchRepository extends ChangeNotifier {
  final DatabaseReference _providerRef =
      FirebaseDatabase.instance.ref().child('Providers');
  List<ProviderSearchModel> _providers = [];
  List<ProviderSearchModel> _filteredProviders = [];
  bool _isLoading = true;

  List<ProviderSearchModel> get providers => _providers;
  List<ProviderSearchModel> get filteredProviders => _filteredProviders;
  bool get isLoading => _isLoading;

  // Fetch users from Firebase and assign to the list
  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      DatabaseEvent snapshot = await _providerRef.once();

      if (snapshot.snapshot.value != null) {
        final Map<dynamic, dynamic> data =
            snapshot.snapshot.value as Map<dynamic, dynamic>;
        List<ProviderSearchModel> fetchedProviders = [];

        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            try {
              final Map<String, dynamic> providerData =
                  Map<String, dynamic>.from(value);

              // Handle availability field
              if (providerData['Availability'] is Map<dynamic, dynamic>) {
                providerData['Availability'] = (providerData['Availability']
                        as Map<dynamic, dynamic>)
                    .map((k, v) => MapEntry(k.toString(),
                        v is bool ? v : false)); // Default to false if not bool
              }

              // Add provider to the list
              fetchedProviders
                  .add(ProviderSearchModel.fromMap(providerData, key));
            } catch (e) {
              debugPrint('Error processing provider $key: $e');
            }
          } else {
            debugPrint('Unexpected data format for provider $key: $value');
          }
        });

        _providers = fetchedProviders;
      } else {
        debugPrint('No data found');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Search users by passion from the list
  void searchUsersByPassion(String query) {
    if (_providers.isEmpty) {
      debugPrint('No providers available to search');
    } else {
      if (query.isEmpty) {
        _filteredProviders = List.from(_providers);
      } else {
        final normalizedQuery = query.trim().toLowerCase();
        _filteredProviders = _providers.where((provider) {
          bool matchFound = provider.passions.any((passion) {
            final normalizedPassion = passion.trim().toLowerCase();
            final isMatch = normalizedPassion.contains(normalizedQuery);

            debugPrint(
                "Checking passion: '$normalizedPassion', Query: '$normalizedQuery', Match: $isMatch");
            return isMatch;
          });

          debugPrint("Provider ${provider.uid} match found: $matchFound");
          return matchFound;
        }).toList();
      }

      debugPrint(
          "Filtered Providers: ${_filteredProviders.map((provider) => provider.passions).toList()}");
    }

    notifyListeners();
  }
}
