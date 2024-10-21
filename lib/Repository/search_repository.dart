import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:nanny_fairy/Models/search_model.dart';

class SearchRepository extends ChangeNotifier {
  final DatabaseReference _familyRef =
      FirebaseDatabase.instance.ref().child('Family');
  List<SearchModel> _users = [];
  List<SearchModel> _filteredUsers = [];
  bool _isLoading = true;

  List<SearchModel> get users => _users;
  List<SearchModel> get filteredUsers => _filteredUsers;
  bool get isLoading => _isLoading;

  // Fetch users from Firebase and assign to the list
  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      DatabaseEvent snapshot = await _familyRef.once();
      if (snapshot.snapshot.value != null) {
        final Map<dynamic, dynamic> data =
            snapshot.snapshot.value as Map<dynamic, dynamic>;
        List<SearchModel> fetchedUsers = [];
        data.forEach((key, value) {
          fetchedUsers.add(SearchModel.fromMap(value, key));
        });
        _users = fetchedUsers;
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
    print("This is the query : $query");

    if (query.isEmpty) {
      _filteredUsers = _users;
    } else {
      _filteredUsers = _users
          .where((user) => user.passions.any((passion) {
                final passionLower = passion.toLowerCase();
                final queryLower = query.toLowerCase();
                final match = passionLower.contains(queryLower);
                print(
                    "Checking passion: $passionLower, Query: $queryLower, Match: $match");
                return match;
              }))
          .toList();
    }
    print(
        "Filtered Users: ${_filteredUsers.map((user) => user.passions).toList()}");
    notifyListeners();
  }
}
