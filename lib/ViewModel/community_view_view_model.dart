import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nanny_fairy/Repository/community_repo_provider.dart';

class CommunityViewViewModel extends ChangeNotifier {
  final CommunityRepoProvider _communityRepoProvider;

  CommunityViewViewModel(this._communityRepoProvider);

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> get posts => _posts;

  Future<void> uploadPostProvider(
    BuildContext context,
    File? post,
    String title,
    String content,
    String providerName,
    String providerProfile,
    bool status,

    // String postId,
  ) async {
    _setLoading(true);
    try {
      await _communityRepoProvider.uploadCommunityPost(
          context, post, title, content, providerName, providerProfile, status);
    } catch (e) {
      debugPrint('Error uploading Post: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchProviderPosts() async {
    _setLoading(true);
    try {
      List<Map<String, dynamic>> posts =
          await _communityRepoProvider.getCommunityPosts();
      _setPosts(posts);
    } catch (e) {
      debugPrint('Error fetching posts: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  void _setPosts(List<Map<String, dynamic>> posts) {
    _posts = posts;
    notifyListeners();
  }

  Future<int> fetchTotalComments(String postId) async {
    return await _communityRepoProvider.getTotalComments(postId);
  }
}
