import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nanny_fairy/view/home/home_view.dart';
import 'package:nanny_fairy/view/home/widgets/provider_all_job.dart';

class ProviderDistanceRepository extends ChangeNotifier {
  List<Map<String, dynamic>> _distanceFilteredFamilies = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get distanceFilteredFamilies =>
      _distanceFilteredFamilies;

  Future<List<Map<String, dynamic>>> fetchFamiliesData() async {
    final databaseReference = FirebaseDatabase.instance.ref().child('Family');
    DatabaseEvent snapshot = await databaseReference.once();

    final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (data == null) {
      return [];
    }

    List<Map<String, dynamic>> familyList = [];
    data.forEach((key, value) {
      if (value is Map<dynamic, dynamic>) {
        familyList.add(Map<String, dynamic>.from(value));
      }
    });

    return familyList;
  }

  Future<void> fetchFamiliesFromFirebaseData() async {
    final databaseReference = FirebaseDatabase.instance.ref().child('Family');
    DatabaseEvent snapshot = await databaseReference.once();

    final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

    _distanceFilteredFamilies.clear();

    if (data == null) {
      return;
    }

    data.forEach((key, value) {
      if (value is Map<dynamic, dynamic>) {
        // Check if the 'bio' field exists, is not null, and is not empty
        if (value.containsKey('bio') &&
            value['bio'] != null &&
            value['bio'].toString().isNotEmpty &&
            value.containsKey('status') &&
            value['status'] != "Unverified" &&
            value['status'] != null &&
            value['status'].toString().isNotEmpty) {
          _distanceFilteredFamilies.add(Map<String, dynamic>.from(value));
        }
      }
    });

    // Optionally notify listeners if this data is being used to update the UI
    notifyListeners();
  }

  Future<String?> getProviderAddress() async {
    var auth = FirebaseAuth.instance;
    final databaseReference = FirebaseDatabase.instance
        .ref()
        .child('Providers')
        .child(auth.currentUser?.uid ?? '')
        .child('address');

    try {
      DatabaseEvent snapshot = await databaseReference.once();
      final address = snapshot.snapshot.value as String?;

      return address;
    } catch (e) {
      debugPrint('Error fetching provider address: $e');
      return null;
    }
  }

  Future<void> filterFamiliesByDistance(
      double maxDistanceKm, BuildContext context) async {
    // Show the loading dialog
    _showLoadingDialog(context);

    try {
      _distanceFilteredFamilies.clear();

      List<Map<String, dynamic>> families = await fetchFamiliesData();
      String? providerAddress = await getProviderAddress();

      if (providerAddress == null) {
        Navigator.of(context).pop(); // Close the dialog
        return;
      }

      for (var family in families) {
        String? familyAddress = family['address'] as String?;

        if (familyAddress == null ||
            family['bio'] == null ||
            family["status"] == "Unverified" ||
            family['status'] == null) {
          continue;
        }

        double distance = await getDistanceInKm(providerAddress, familyAddress);

        if (distance <= maxDistanceKm) {
          _distanceFilteredFamilies.add(family);
        }
      }

      debugPrint("This is length of list: ${_distanceFilteredFamilies.length}");
      Navigator.of(context).pop(); // Close the dialog when done
      notifyListeners();
    } catch (e) {
      debugPrint('Error filtering families: $e');
      Navigator.of(context).pop(); // Close the dialog on error
    }
  }

// Show Loading Dialog
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dialog from closing on tap outside
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> filterFamiliesByPassion(
      String passion, BuildContext context) async {
    try {
      // Create a temporary set to store unique families filtered by passion
      Set<Map<String, dynamic>> filteredByPassion = {};

      // Iterate through the already distance-filtered families
      for (var family in _distanceFilteredFamilies) {
        List<dynamic>? familyPassions =
            family['FamilyPassions'] as List<dynamic>?;

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
      _distanceFilteredFamilies = filteredByPassion.toList();

      // Notify listeners once filtering is complete
      notifyListeners();

      debugPrint(
          "Filtered families by passion: ${_distanceFilteredFamilies.length}");
    } catch (e) {
      debugPrint('Error filtering families by passion: $e');
    }
  }

  Future<double> getDistanceInKm(String origin, String destination) async {
    String encodedOrigin = Uri.encodeComponent(origin);
    String encodedDestination = Uri.encodeComponent(destination);

    String url = 'https://maps.googleapis.com/maps/api/distancematrix/json'
        '?origins=$encodedOrigin'
        '&destinations=$encodedDestination'
        '&units=metric'
        '&key=AIzaSyCBUyZVjnq9IGxH9Zu6ACNRIJXtkfZ2iuQ';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['rows'] != null &&
          jsonResponse['rows'].isNotEmpty &&
          jsonResponse['rows'][0]['elements'] != null &&
          jsonResponse['rows'][0]['elements'].isNotEmpty &&
          jsonResponse['rows'][0]['elements'][0]['status'] == 'OK') {
        var distance =
            jsonResponse['rows'][0]['elements'][0]['distance']['value'];
        return distance / 1000;
      } else {
        throw Exception('No valid data found in the API response.');
      }
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }

  Future<void> filterUsersByMultiplePassionsAndTotalRating(double maxDistance,
      BuildContext context, List<String> passions, double rating) async {
    try {
      // Show the loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Clear the list first to reset the state
      _distanceFilteredFamilies.clear();

      // Filter families by distance first
      await filterFamiliesByDistance(
          providerDistance == null
              ? maxDistance
              : double.parse(providerDistance!),
          context);

      if (_distanceFilteredFamilies.isEmpty) {}

      if (passions.isEmpty) {
        // If no passions are provided, filter by rating only
        _distanceFilteredFamilies.retainWhere((family) {
          Map<dynamic, dynamic> reviews = family['reviews'] ?? {};
          double averageRating = calculateAverageRating(reviews);

          return averageRating >= rating;
        });

        // Close the loading dialog
        Navigator.of(context).pop();
        notifyListeners();
        return;
      }

      // List to store families that match the passions and rating
      List<Map<String, dynamic>> matchedFamilies = [];

      // Apply the passion and rating filters on the distance-filtered families
      for (var family in _distanceFilteredFamilies) {
        List<dynamic>? familyPassions =
            family['FamilyPassions'] as List<dynamic>?;

        if (familyPassions == null || familyPassions.isEmpty) {
          continue; // Skip families with no passions
        }

        // Check if the family has any matching passions
        bool passionMatches = familyPassions.any((passion) {
          bool match = passions.any((query) =>
              passion.toString().toLowerCase().contains(query.toLowerCase()));

          return match;
        });

        // Check if the family's rating meets the required threshold
        Map<dynamic, dynamic> reviews = family['reviews'] ?? {};
        double averageRating = calculateAverageRating(reviews);

        // If both the passions and rating match, add the family to the matched list
        if (passionMatches && averageRating >= rating) {
          matchedFamilies.add(family);
        }
      }

      // Update the filtered families list with the matched families
      _distanceFilteredFamilies.clear();
      _distanceFilteredFamilies.addAll(matchedFamilies);

      // Close the loading dialog
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => ProviderAllJob(
            distanceFilteredFamilies: _distanceFilteredFamilies,
          ),
        ),
      );

      // Notify listeners after filtering
      notifyListeners();
    } catch (e) {
      // Close the loading dialog in case of error
      Navigator.of(context).pop();

      debugPrint('Error filtering families by passion and rating: $e');
      notifyListeners();
    }
  }

  double calculateAverageRating(Map<dynamic, dynamic> reviews) {
    if (reviews.isEmpty) {
      return 0.0; // No reviews, no rating
    }

    double totalRating = 0.0;
    reviews.forEach((key, review) {
      if (review['countRatingStars'] != null) {
        totalRating += review['countRatingStars'];
      }
    });

    return totalRating / reviews.length; // Average rating
  }
}
