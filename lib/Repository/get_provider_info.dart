import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class GetProviderInfoRepo {
  final DatabaseReference _providerRef =
      FirebaseDatabase.instance.ref().child('Providers');
  String? providerName;
  String? providerProfile;
  String? senderId;

  Future<Map<dynamic, dynamic>> getProvider() async {
    DatabaseEvent snapshot =
        await _providerRef.child(FirebaseAuth.instance.currentUser!.uid).once();
    return snapshot.snapshot.value as Map<dynamic, dynamic>;
  }

  Future<void> fetchCurrentFamilyInfo() async {
    DatabaseEvent snapshot =
        await _providerRef.child(FirebaseAuth.instance.currentUser!.uid).once();
    final data = snapshot.snapshot.value as Map<dynamic, dynamic>;

    String? firstName = data['firstName'];
    String? lastName = data['lastName'];
    providerName =
        (firstName != null && lastName != null) ? '$firstName $lastName' : null;

    providerProfile = data['profile'];
    senderId = FirebaseAuth.instance.currentUser!.uid;
  }
}
