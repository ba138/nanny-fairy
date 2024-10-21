// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart'; // Add this import for ChangeNotifier
import 'package:http/http.dart' as http;
import 'package:nanny_fairy/Family_View/findJobFamily/family_all_jobs_view.dart';
import 'package:nanny_fairy/res/components/colors.dart';

class FamilyDistanceRepository extends ChangeNotifier {
  List<Map<String, dynamic>> _distanceFilterProviders = [];
  List<Map<String, dynamic>> get distanceFilterProviders =>
      _distanceFilterProviders;

  bool _isActive = true;

  // Function to fetch provider data from Firebase
  Future<List<Map<String, dynamic>>> fetchProvidersData() async {
    final databaseReference =
        FirebaseDatabase.instance.ref().child('Providers');
    DatabaseEvent snapshot = await databaseReference.once();
    debugPrint("this is address of providers:${snapshot.snapshot.value}");
    final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (data == null) {
      return [];
    }

    List<Map<String, dynamic>> providerList = [];
    data.forEach((key, value) {
      if (value is Map<dynamic, dynamic>) {
        providerList.add(Map<String, dynamic>.from(value));
      }
    });

    return providerList;
  }

  Future<void> fetchProvidersDataFromFirebase() async {
    final databaseReference =
        FirebaseDatabase.instance.ref().child('Providers');
    DatabaseEvent snapshot = await databaseReference.once();

    debugPrint("This is address of providers: ${snapshot.snapshot.value}");
    final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (data == null) {
      return;
    }

    _distanceFilterProviders.clear();

    data.forEach((key, value) {
      if (value is Map<dynamic, dynamic>) {
        // Check if the 'bio' field exists and is not null
        if (value.containsKey('bio') &&
            value['bio'] != null &&
            value['bio'].toString().isNotEmpty &&
            value.containsKey('status') &&
            value['status'] != "Unverified" &&
            value['status'] != null &&
            value['status'].toString().isNotEmpty) {
          _distanceFilterProviders.add(Map<String, dynamic>.from(value));
        }
      }
    });

    // Optionally notify listeners if this data is being used to update the UI
    notifyListeners();
  }

  // Function to get the current family address
  Future<String?> getFamilyAddress() async {
    var auth = FirebaseAuth.instance;
    final databaseReference = FirebaseDatabase.instance
        .ref()
        .child('Family')
        .child(auth.currentUser!.uid)
        .child('address');

    try {
      DatabaseEvent snapshot = await databaseReference.once();
      debugPrint("this is address of family:${snapshot.snapshot.value}");
      final address = snapshot.snapshot.value as String?;

      if (address != null) {
        return address;
      } else {
        debugPrint('No address found for the current family.');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching family address: $e');
      return null;
    }
  }

  // Function to get the distance in kilometers between two addresses
  Future<double> getDistanceInKm(String origin, String destination) async {
    if (origin.isEmpty || destination.isEmpty) {
      throw Exception('Origin or destination address is empty');
    }

    String encodedOrigin = Uri.encodeComponent(origin);
    String encodedDestination = Uri.encodeComponent(destination);

    String url = 'https://maps.googleapis.com/maps/api/distancematrix/json'
        '?origins=$encodedOrigin'
        '&destinations=$encodedDestination'
        '&units=metric'
        '&key=AIzaSyCBUyZVjnq9IGxH9Zu6ACNRIJXtkfZ2iuQ'; // Replace with your actual API key

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['rows'] != null &&
          jsonResponse['rows'].isNotEmpty &&
          jsonResponse['rows'][0]['elements'] != null &&
          jsonResponse['rows'][0]['elements'].isNotEmpty &&
          jsonResponse['rows'][0]['elements'][0]['status'] == 'OK') {
        var distance = jsonResponse['rows'][0]['elements'][0]['distance']
            ['value']; // Distance in meters
        return distance / 1000; // Convert to kilometers
      } else {
        throw Exception('No valid data found in the API response.');
      }
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dialog from closing on tap outside
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: AppColor.creamyColor,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: AppColor.lavenderColor,
                ),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to filter providers based on distance from the current family address
  Future<void> filterProvidersByDistance(
      BuildContext context, double maxDistanceKm) async {
    _showLoadingDialog(context);
    try {
      List<Map<String, dynamic>> providers = await fetchProvidersData();
      String? familyAddress = await getFamilyAddress();

      if (familyAddress == null || familyAddress.isEmpty) {
        debugPrint('No valid family address found');
        Navigator.of(context).pop();
        return; // Exit if no family address is found
      }

      _distanceFilterProviders.clear(); // Clear previous results
      Map<String, Map<String, dynamic>> uniqueProviders =
          {}; // Map to store unique providers

      for (var provider in providers) {
        String? providerUid = provider['uid']?.toString().trim();
        String? providerAddress =
            provider['address']?.toString().trim(); // Trim the address

        debugPrint(
            "Checking provider ${provider['firstName']} ${provider['lastName']} with address: $providerAddress");

        // Skip if provider UID or address is invalid
        if (providerUid != null &&
            providerAddress != null &&
            providerAddress.isNotEmpty &&
            provider['bio'] != null &&
            provider.containsKey('status') &&
            provider['status'] != "Unverified" &&
            provider['status'] != null &&
            provider['status'].toString().isNotEmpty) {
          // This block will only execute if all the conditions are true
        } else {
          debugPrint(
              'Provider ${provider['firstName']} ${provider['lastName']} with address $providerAddress is null, empty, or invalid. Skipping.');
          continue;
        }

        // Fetch the distance between the family address and the provider address
        double distance = await getDistanceInKm(familyAddress, providerAddress);
        debugPrint(
            "Distance between family and provider ${provider['firstName']} is $distance km");

        // Check if the provider is within the specified distance
        if (distance <= maxDistanceKm) {
          if (uniqueProviders.containsKey(providerUid)) {
            debugPrint(
                'Duplicate provider found: ${provider['firstName']} ${provider['lastName']}');
          }

          // Add or update the provider in the map (overwrite if duplicate UID)
          uniqueProviders[providerUid] = provider;
          debugPrint(
              "Adding/updating provider ${provider['firstName']} ${provider['lastName']} with distance $distance km");
        }
      }

      // Convert map values to list
      _distanceFilterProviders.addAll(uniqueProviders.values);
      debugPrint(
          "this is length of the distanceFilterProvider list:${_distanceFilterProviders.length}");
      Navigator.of(context).pop();
      if (_isActive) {
        notifyListeners(); // Notify listeners that the data has been updated
      }
    } catch (e) {
      debugPrint('Error filtering providers by distance: $e');
      Navigator.of(context).pop();
    }
  }

  // Function to filter providers by passion and distance
  Future<void> filterFamiliesByPassion(
      String passion, BuildContext context) async {
    try {
      // Create a temporary set to store unique families filtered by passion
      Set<Map<String, dynamic>> filteredByPassion = {};

      // Iterate through the already distance-filtered families
      for (var family in _distanceFilterProviders) {
        List<dynamic>? familyPassions = family['Passions'] as List<dynamic>?;

        if (familyPassions != null) {
          // Check if any passion in the family's passions contains the input substring
          bool matches = familyPassions.any((p) =>
              p.toString().toLowerCase().contains(passion.toLowerCase()));

          if (matches) {
            filteredByPassion.add(family); // Add to Set to avoid duplicates
          }
        }
      }

      // Replace the filtered list with families matching the passion
      _distanceFilterProviders = filteredByPassion.toList();

      // Notify listeners once filtering is complete
      notifyListeners();

      debugPrint(
          "Filtered families by passion: ${_distanceFilterProviders.length}");
    } catch (e) {
      debugPrint('Error filtering families by passion: $e');
    }
  }

  // Method to deactivate the repository
  void deactivate() {
    _isActive = false;
  }

  // Method to activate the repository
  void activate() {
    _isActive = true;
  }

  Future<void> filterFamiliesBySinglePassion(
      String passion, double distance, BuildContext context) async {
    try {
      debugPrint("filterFamiliesBySinglePassion called with passion: $passion");

      // Fetch all providers
      List<Map<String, dynamic>> providers = await fetchProvidersData();
      debugPrint("Fetched providers: ${providers.length}");

      List<Map<String, dynamic>> providersSinglePassionData = [];

      // If no passion is provided, filter by distance only
      if (passion.isEmpty) {
        await filterProvidersByDistance(context, distance);
      } else {
        // Iterate through all providers
        for (var provider in providers) {
          List<dynamic>? providerPassions =
              provider['Passions'] as List<dynamic>?;

          // If the provider's passions list is not null and contains the passion, add them to the result
          if (providerPassions != null && providerPassions.contains(passion)) {
            providersSinglePassionData.add(provider);
          }
        }

        // Log the number of filtered providers
        debugPrint(
            "Filtered providers by passion: ${providersSinglePassionData.length}");
      }

      // Navigate to the view regardless of whether the list is empty or not
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => FamilyAllJobsView(
            providers: providersSinglePassionData, // Can be empty or populated
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error filtering providers by single passion: $e');
    }
  }

  Future<void> filterProviders({
    required BuildContext context, // Pass context for navigation
    required double maxDistanceKm, // For distance filtering
    required double minRate,
    required double maxRate,
    required double minRating,
    required List<String> selectedPassions,
    required Map<String, Map<String, bool>> selectedAvailability,
  }) async {
    List<Map<String, dynamic>> filteredProviders = [];

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Step 1: Fetch the family address for distance calculation
      String? familyAddress = await getFamilyAddress();
      if (familyAddress == null || familyAddress.isEmpty) {
        debugPrint('No valid family address found');
        Navigator.of(context).pop(); // Close the loading dialog
        return;
      }

      // Step 2: Fetch all provider data directly from Firebase as a list of maps
      List<Map<String, dynamic>> providers = await fetchProvidersData();
      debugPrint("All Providers: ${providers.length}");

      // Step 3: Filter out providers without a valid bio
      List<Map<String, dynamic>> providersWithBio = providers.where((provider) {
        String? bio = provider['bio']?.toString().trim();
        return bio != null && bio.isNotEmpty;
      }).toList();
      debugPrint("After bio filter: ${providersWithBio.length}");

      // Step 4: Filter providers by distance
      List<Map<String, dynamic>> distanceFilteredProviders = [];
      for (var provider in providersWithBio) {
        String? providerAddress = provider['address']?.toString().trim();
        if (providerAddress != null && providerAddress.isNotEmpty) {
          double distance =
              await getDistanceInKm(familyAddress, providerAddress);
          debugPrint(
              "Distance to provider ${provider['firstName']}: $distance km");

          if (distance <= maxDistanceKm) {
            distanceFilteredProviders.add(provider);
          }
        }
      }
      debugPrint("After distance filter: ${distanceFilteredProviders.length}");

      // Step 5: Filter by hourly rate
      List<Map<String, dynamic>> rateFilteredProviders =
          distanceFilteredProviders.where((provider) {
        double rate =
            double.tryParse(provider['hoursrate']?.toString() ?? '0') ?? 0.0;
        return rate >= minRate && rate <= maxRate;
      }).toList();
      debugPrint("After rate filter: ${rateFilteredProviders.length}");

      // Step 6: Filter by average rating
      List<Map<String, dynamic>> ratingFilteredProviders =
          rateFilteredProviders.where((provider) {
        double rating =
            double.tryParse(provider['averageRating']?.toString() ?? '0') ??
                0.0;
        return rating >= minRating;
      }).toList();
      debugPrint("After rating filter: ${ratingFilteredProviders.length}");

      // Step 7: Filter by passions (at least one passion must match)
      List<Map<String, dynamic>> passionFilteredProviders = [];
      for (var provider in ratingFilteredProviders) {
        List<dynamic> providerPassions = provider['Passions'] ?? [];
        List<String> lowercaseProviderPassions =
            providerPassions.map((p) => p.toString().toLowerCase()).toList();

        // Check if at least one selectedPassion matches the provider's passions
        bool anyPassionMatch = false;
        for (String selectedPassion in selectedPassions) {
          bool isMatch =
              lowercaseProviderPassions.contains(selectedPassion.toLowerCase());
          debugPrint('Checking passion: $selectedPassion, Match: $isMatch');

          if (isMatch) {
            anyPassionMatch = true; // If any passion matches, set to true
            break; // Exit the loop early since we only need one match
          }
        }

        // If at least one passion matches, add the provider to the filtered list
        if (anyPassionMatch) {
          passionFilteredProviders.add(provider);
        }
      }
      debugPrint(
          "After passions filter (any match): ${passionFilteredProviders.length}");

      // Step 8: Fallback to distance filter if no providers match
      if (passionFilteredProviders.isEmpty &&
          ratingFilteredProviders.isEmpty &&
          rateFilteredProviders.isEmpty) {
        debugPrint(
            "No providers match after all filters. Showing only distance filtered providers...");
        filteredProviders =
            distanceFilteredProviders; // Only show distance-filtered providers
      } else {
        filteredProviders = passionFilteredProviders.isNotEmpty
            ? passionFilteredProviders
            : ratingFilteredProviders.isNotEmpty
                ? ratingFilteredProviders
                : rateFilteredProviders;
      }

      debugPrint("Final filtered providers: ${filteredProviders.length}");

      // Step 9: Close the loading dialog
      Navigator.of(context).pop();

      // Step 10: Navigate to FamilyAllJobsView with the filtered providers
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FamilyAllJobsView(providers: filteredProviders),
        ),
      );
    } catch (e) {
      debugPrint("Error filtering providers: $e");
      Navigator.of(context).pop(); // Close the loading dialog in case of error
    }

    notifyListeners();
  }
}
