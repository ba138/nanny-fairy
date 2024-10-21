import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nanny_fairy/ViewModel/family_distance_view_model.dart';
import 'package:nanny_fairy/ViewModel/provider_distance_view_model.dart';
import 'package:nanny_fairy/utils/routes/routes_name.dart';
import 'package:provider/provider.dart';
import '../../res/components/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('Providers');

  @override
  void initState() {
    super.initState();
    checkUserSession();
  }

  Future<void> checkUserSession() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;
      final isProvider = await checkIfUserIsProvider(userId);
      final isFamily = await checkIfUserIsFamily(userId);

      if (isProvider) {
        // Check if bio exists in the Providers collection
        final hasBio = await checkIfBioExists(userId, 'Providers');
        if (hasBio) {
          // Navigate to the
          //Provider Dashboard
          Provider.of<ProviderDistanceViewModel>(context, listen: false)
              .fetchFamiliesFromFirebaseData();
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.dashboard,
            (Route<dynamic> route) => false,
          );
        } else {
          // Navigate to loginOrSignup if bio is not available
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.loginOrSignup,
            (Route<dynamic> route) => false,
          );
        }
      } else if (isFamily) {
        // Check if bio exists in the Family collection
        final hasBio = await checkIfBioExists(userId, 'Family');
        if (hasBio) {
          Provider.of<FamilyDistanceViewModel>(context, listen: false)
              .fetchProviderDataFromFiebase();
          // Navigate to the Family Dashboard
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.dashboardFamily,
            (Route<dynamic> route) => false,
          );
        } else {
          // Navigate to loginOrSignup if bio is not available
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.loginOrSignup,
            (Route<dynamic> route) => false,
          );
        }
      } else {
        // If user is neither in Providers nor Family, navigate to loginOrSignup
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.loginOrSignup,
          (Route<dynamic> route) => false,
        );
      }
    } else {
      // If the user is not logged in, navigate to loginOrSignup after 5 seconds
      Timer(const Duration(seconds: 5), () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.loginOrSignup,
          (Route<dynamic> route) => false,
        );
      });
    }
  }

  Future<bool> checkIfUserIsProvider(String id) async {
    final snapshot = await _dbRef.orderByChild('uid').equalTo(id).once();
    return snapshot.snapshot.exists;
  }

  Future<bool> checkIfUserIsFamily(String id) async {
    final familyRef = FirebaseDatabase.instance.ref().child('Family');
    final snapshot = await familyRef.orderByChild('uid').equalTo(id).once();
    return snapshot.snapshot.exists;
  }

  Future<bool> checkIfBioExists(String id, String collection) async {
    final collectionRef = FirebaseDatabase.instance.ref().child(collection);
    final snapshot = await collectionRef.child(id).once();

    if (snapshot.snapshot.exists) {
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;
      return data != null && data.containsKey('bio');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.authCreamColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/splash.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
