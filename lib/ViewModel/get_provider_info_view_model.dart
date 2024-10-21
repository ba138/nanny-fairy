import 'package:flutter/material.dart';
import 'package:nanny_fairy/Repository/get_provider_info.dart';

class GetProviderInfoViewModel extends ChangeNotifier {
  final GetProviderInfoRepo _getProviderInfoRepo;

  GetProviderInfoViewModel(this._getProviderInfoRepo);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<Map<dynamic, dynamic>> getProviderInfo() async {
    try {
      return await _getProviderInfoRepo.getProvider();
    } finally {}
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
