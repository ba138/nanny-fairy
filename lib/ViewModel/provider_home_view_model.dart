import 'package:flutter/material.dart';
import 'package:nanny_fairy/Repository/provider_home_repository.dart';

class ProviderHomeViewModel extends ChangeNotifier {
  final ProviderHomeRepository _providerHomeRepository;

  ProviderHomeViewModel(this._providerHomeRepository);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<Map<dynamic, dynamic>> getPopularJobs() async {
    try {
      return await _providerHomeRepository.getPopularJobs();
    } finally {}
  }

  Future<Map<dynamic, dynamic>> getChats() async {
    try {
      return await _providerHomeRepository.getChats();
    } finally {}
  }

  Future<Map<dynamic, dynamic>> getCurrentUser() async {
    try {
      return await _providerHomeRepository.getCurrentUser();
    } finally {}
  }

  Future<Map<dynamic, dynamic>> getPosts() async {
    try {
      return await _providerHomeRepository.getPosts();
    } finally {}
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
