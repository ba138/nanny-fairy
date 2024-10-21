// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nanny_fairy/res/components/common_firebase_storge.dart';
import 'package:nanny_fairy/utils/routes/routes_name.dart';
import 'package:nanny_fairy/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  var databaseReference = FirebaseDatabase.instance.ref();

  Future<void> createAccount({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    // Show loading indicator
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
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Remove the loading indicator
      Navigator.of(context).pop();
      // Show success message or navigate to another screen
      Utils.toastMessage('Account created successfully!');
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.registerDetails,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      // Remove the loading indicator
      Navigator.of(context).pop();
      // Show error message
      debugPrint(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create account: ${e.message}'),
        ),
      );
    }
  }

  Future<void> loginAccount({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    // Show loading indicator
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
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Remove the loading indicator
      Navigator.of(context).pop();
      // Show success message or navigate to another screen
      Utils.toastMessage('successfully LogIn!');
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.dashboard,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      // Remove the loading indicator
      Navigator.of(context).pop();
      // Show error message
      debugPrint(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to login account: ${e.message}'),
        ),
      );
    }
  }

  Future<void> saveDetails({
    required String firstName,
    required String lastName,
    required String address,
    required String houseNumber,
    required String postCode,
    required String phoneNumber,
    required String dob,
    required BuildContext context,
  }) async {
    // Check if any field is empty
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        address.isEmpty ||
        houseNumber.isEmpty ||
        postCode.isEmpty ||
        phoneNumber.isEmpty ||
        dob.isEmpty) {
      // Show a toast message
      Utils.flushBarErrorMessage("Please fill in all fields", context);

      return;
    }

    // Show loading indicator
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
      final userId = _firebaseAuth.currentUser?.uid;
      final email = _firebaseAuth.currentUser?.email;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final userRef = databaseReference.child('Providers').child(userId);

      await userRef.set({
        'firstName': firstName,
        'lastName': lastName,
        'address': address,
        'houseNumber': houseNumber,
        'postCode': postCode,
        'phoneNumber': phoneNumber,
        'dob': dob,
        "uid": userId,
        "email": email,
      });

      // Remove the loading indicator
      Navigator.of(context).pop();

      // Show success message
      Utils.toastMessage('Details saved successfully!');
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.selectPassion,
        (route) => false,
      );
    } catch (e) {
      // Remove the loading indicator
      Navigator.of(context).pop();
      Utils.flushBarErrorMessage("Failed to save details", context);
      debugPrint(e.toString());
      // Show error message
    }
  }

  Future<void> savePassion(
      List<String> passionList, BuildContext context) async {
    // Show loading indicator
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
      final userId = _firebaseAuth.currentUser?.uid;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final userRef =
          databaseReference.child('Providers').child(userId).child('Passions');

      await userRef.set(passionList);

      // Close the loading indicator
      Navigator.of(context).pop();

      Utils.toastMessage('Passions saved successfully!');

      Navigator.pushNamed(
        context,
        RoutesName.availabilityView,
      );
    } catch (e) {
      // Close the loading indicator
      Navigator.of(context).pop();

      // Handle any errors that occur during save
      debugPrint('Error saving passions: $e');
      Utils.flushBarErrorMessage('Failed to save passions', context);
    }
  }

  saveEducationAndHoursrate(String education, hourRate, BuildContext context) {
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
      final userId = _firebaseAuth.currentUser!.uid;
      final userRef = databaseReference.child('Providers').child(userId);
      userRef.update({
        "education": education,
        "hoursrate": hourRate,
      });
      Navigator.of(context).pop();

      Utils.toastMessage('Education and Hours Rate saved successfully!');
      Navigator.pushNamed(
        context,
        RoutesName.selectPreference,
      );
    } catch (e) {
      Navigator.of(context).pop();

      // Handle any errors that occur during save
      debugPrint('Error saving passions: $e');
      Utils.flushBarErrorMessage(
          'Failed to save education and hours Rate', context);
    }
  }

  saveRefernce(
      String experince, job, skill, land, phone, BuildContext context) {
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
      final userId = _firebaseAuth.currentUser!.uid;

      databaseReference.child('Providers').child(userId).child('Refernce').set({
        "experince": experince,
        "job": job,
        "skill": skill,
        "land": land,
        "phoneNumber": phone,
      });
      Navigator.of(context).pop();
      debugPrint('Refenrence saved successfully!');

      Utils.toastMessage('Refenrence saved successfully!');
      Navigator.pushNamed(
        context,
        RoutesName.uploadId,
      );
    } catch (e) {
      Navigator.of(context).pop();

      // Handle any errors that occur during save
      debugPrint('Error saving refernce: $e');
      Utils.flushBarErrorMessage('Failed to save Refernce', context);
    }
  }

  saveIdImages(
    BuildContext context,
    File? frontPic,
    File? backImage,
    String status,
  ) async {
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
      var uuid = const Uuid().v1();
      final userId = _firebaseAuth.currentUser!.uid;
      final userRef =
          databaseReference.child('Providers').child(userId).child("IdPics");
      final userRefData = databaseReference.child('Providers').child(userId);
      String frontUrl = "";
      String backUrl = "";

      if (frontPic != null) {
        CommonFirebaseStorage commonStorage = CommonFirebaseStorage();
        frontUrl = await commonStorage.storeFileFileToFirebase(
          'Id/$uuid+1',
          frontPic,
        );
      } else {
        Utils.flushBarErrorMessage("Please pick The Id Front Pic", context);
        Navigator.pop(context);
        return;
      }
      if (backImage != null) {
        CommonFirebaseStorage commonStorage = CommonFirebaseStorage();
        backUrl = await commonStorage.storeFileFileToFirebase(
          'Id/$uuid',
          backImage,
        );
      } else {
        Utils.flushBarErrorMessage("Please pick The Id Back Pic", context);
        Navigator.pop(context);
        return;
      }
      userRef.set({
        "frontPic": frontUrl,
        "backPic": backUrl,
      });
      userRefData.update({
        "status": 'Unverified',
      });
      Navigator.of(context).pop();
      Utils.toastMessage('Images saved successfully!');
      debugPrint(userId);
      Navigator.pushNamed(
        context,
        RoutesName.uploadImg,
      );
    } catch (e) {
      Navigator.of(context).pop();
      // Handle any errors that occur during save
      debugPrint('Error saving images: $e');
      Utils.flushBarErrorMessage('Failed to save Images', context);
    }
  }

  saveProfileAndBio(
    BuildContext context,
    File? profile,
    String bio,
  ) async {
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
      var uuid = const Uuid().v1();
      final userId = _firebaseAuth.currentUser!.uid;
      final userRef = databaseReference.child('Providers').child(userId);

      String profileUrl =
          'https://nakedsecurity.sophos.com/wp-content/uploads/sites/2/2013/08/facebook-silhouette_thumb.jpg';

      if (profile != null) {
        CommonFirebaseStorage commonStorage = CommonFirebaseStorage();
        profileUrl = await commonStorage.storeFileFileToFirebase(
          'Profile/$uuid',
          profile,
        );
      } else {
        Utils.flushBarErrorMessage("Please pick The Profile Pic", context);
        Navigator.pop(context);
        return;
      }

      userRef.update({
        "profile": profileUrl,
        "bio": bio,
      });
      Navigator.of(context).pop();
      Utils.toastMessage('Images saved successfully!');
      debugPrint(userId);
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.dashboard,
        (route) => false,
      );
    } catch (e) {
      Navigator.of(context).pop();

      // Handle any errors that occur during save
      debugPrint('Error saving images: $e');
      Utils.flushBarErrorMessage('Failed to save Images', context);
    }
  }
}
