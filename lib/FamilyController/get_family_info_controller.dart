import 'package:flutter/material.dart';
import 'package:nanny_fairy/Repository/get_family_info_repo.dart';

class GetFamilyInfoController extends ChangeNotifier {
  final GetFamilyInfoRepo _getFamilyInfoRepo;

  GetFamilyInfoController(this._getFamilyInfoRepo);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<Map<dynamic, dynamic>> getFamilyInfo() async {
    try {
      return await _getFamilyInfoRepo.getFamily();
    } finally {}
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
