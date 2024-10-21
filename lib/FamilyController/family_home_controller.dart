import 'package:flutter/material.dart';
import 'package:nanny_fairy/Repository/family_home_repo.dart';
import 'package:nanny_fairy/Repository/provider_home_repository.dart';

class FamilyHomeController extends ChangeNotifier {
  final FamilyHomeRepository _familyHomeRepository;

  FamilyHomeController(this._familyHomeRepository);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<Map<dynamic, dynamic>> getPopularJobs() async {

    try {
      return await _familyHomeRepository.getPopularJobs();
    } finally {
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
