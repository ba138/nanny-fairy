import 'package:firebase_database/firebase_database.dart';

class FamilyHomeRepository {
  final DatabaseReference _bookingRef =
  FirebaseDatabase.instance.ref().child('Providers');

  Future<Map<dynamic, dynamic>> getPopularJobs() async {
    DatabaseEvent snapshot = await _bookingRef.once();
    return snapshot.snapshot.value as Map<dynamic, dynamic>;
  }
}
