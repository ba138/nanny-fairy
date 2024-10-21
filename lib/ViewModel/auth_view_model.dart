import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nanny_fairy/Repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> createAccount({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _setLoading(true);
    try {
      await _authRepository.createAccount(
        email: email,
        password: password,
        context: context,
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loginAccount({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _setLoading(true);
    try {
      await _authRepository.loginAccount(
        email: email,
        password: password,
        context: context,
      );
    } finally {
      _setLoading(false);
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
    _setLoading(true);
    try {
      await _authRepository.saveDetails(
        firstName: firstName,
        lastName: lastName,
        address: address,
        houseNumber: houseNumber,
        postCode: postCode,
        phoneNumber: phoneNumber,
        dob: dob,
        context: context,
      );
    } catch (e) {
      debugPrint('Error saving details: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> savePassion({
    required List<String> passionList,
    required BuildContext context,
  }) async {
    _setLoading(true);
    try {
      await _authRepository.savePassion(
        passionList,
        context,
      );
    } catch (e) {
      debugPrint('Error saving details: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveEducationandHoursRate(
      {required BuildContext context,
      required String education,
      required String hoursRate}) async {
    _setLoading(true);
    try {
      await _authRepository.saveEducationAndHoursrate(
        education,
        hoursRate,
        context,
      );
    } catch (e) {
      debugPrint('Error saving details: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> savePrefernce(
      {required BuildContext context,
      required String experince,
      required String job,
      required String skill,
      required String land,
      required String phoneNumber}) async {
    _setLoading(true);
    try {
      await _authRepository.saveRefernce(
        experince,
        job,
        skill,
        land,
        phoneNumber,
        context,
      );
    } catch (e) {
      debugPrint('Error saving details: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveIdImages(
    BuildContext context,
    File? frontPic,
    File? backPic,
    String status,
  ) async {
    _setLoading(true);
    try {
      await _authRepository.saveIdImages(context, frontPic, backPic, status);
    } catch (e) {
      debugPrint('Error saving details: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveProfileAndBio(
    BuildContext context,
    File? profile,
    String bio,
  ) async {
    _setLoading(true);
    try {
      await _authRepository.saveProfileAndBio(context, profile, bio);
    } catch (e) {
      debugPrint('Error saving details: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
