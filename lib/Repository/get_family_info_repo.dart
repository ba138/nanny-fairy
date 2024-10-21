import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class GetFamilyInfoRepo {
  final DatabaseReference _familyRef =
      FirebaseDatabase.instance.ref().child('Family');
  String? familyName;
  String? familyProfile;
  String? senderId;

  // Existing function to get family data
  Future<Map<dynamic, dynamic>> getFamily() async {
    DatabaseEvent snapshot =
        await _familyRef.child(FirebaseAuth.instance.currentUser!.uid).once();
    return snapshot.snapshot.value as Map<dynamic, dynamic>;
  }

  // New function to fetch and assign current family info
  Future<void> fetchCurrentFamilyInfo() async {
    try {
      DatabaseEvent snapshot = await _familyRef.child(FirebaseAuth.instance.currentUser!.uid).once();

      // Check if snapshot has a value
      if (snapshot.snapshot.value == null) {
        debugPrint('No data found for the current user.');
        return;
      }

      // Safely cast the snapshot value to a map
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) {
        debugPrint('Data is not a map or is null.');
        return;
      }

      String? firstName = data['firstName'] as String?;
      String? lastName = data['lastName'] as String?;
      familyName = (firstName != null && lastName != null) ? '$firstName $lastName' : null;

      familyProfile = data['profile'] as String?;
      senderId = FirebaseAuth.instance.currentUser!.uid;

      debugPrint('credential: $senderId, $familyName, $familyProfile');
    } catch (e) {
      debugPrint('Error fetching family info: $e');
    }
  }

}
