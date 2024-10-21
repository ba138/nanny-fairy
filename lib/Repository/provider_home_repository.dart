import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ProviderHomeRepository {
  final DatabaseReference _bookingRef =
      FirebaseDatabase.instance.ref().child('Family');

  Future<Map<dynamic, dynamic>> getPopularJobs() async {
    DatabaseEvent snapshot = await _bookingRef.once();
    return snapshot.snapshot.value as Map<dynamic, dynamic>;
  }

  Future<Map<dynamic, dynamic>> getChats() async {
    DatabaseEvent snapshot = await FirebaseDatabase.instance
        .ref()
        .child('Providers')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("chats")
        .once();
    return snapshot.snapshot.value as Map<dynamic, dynamic>;
  }

  final DatabaseReference _providerRef =
      FirebaseDatabase.instance.ref().child('Providers');

  Future<Map<dynamic, dynamic>> getCurrentUser() async {
    DatabaseEvent snapshot =
        await _providerRef.child(FirebaseAuth.instance.currentUser!.uid).once();
    return snapshot.snapshot.value as Map<dynamic, dynamic>;
  }

  Future<Map<dynamic, dynamic>> getPosts() async {
    Query query = FirebaseDatabase.instance
        .ref()
        .child('ProviderCommunityPosts')
        .orderByChild('userId')
        .equalTo(FirebaseAuth.instance.currentUser!.uid);
    DatabaseEvent snapshot = await query.once();
    return snapshot.snapshot.value as Map<dynamic, dynamic>;
  }
}
