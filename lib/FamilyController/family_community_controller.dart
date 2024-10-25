import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nanny_fairy/Repository/auth_repository.dart';

import '../Repository/community_repo_family.dart';

class FamilyCommunityController extends ChangeNotifier {
  final CommunityRepoFamily _communityRepoFamily;

  FamilyCommunityController(this._communityRepoFamily);

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> get posts => _posts;

  Future<void> uploadPostFamily(
      BuildContext context,
      File? post,
      String title,
      String content,
      String familyProfile,
      String familyName,
      bool status) async {
    _setLoading(true);
    try {
      await _communityRepoFamily.uploadFamilyPost(
          context, post, title, content, familyProfile, familyName, status);
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

  Future<void> fetchFamilyPosts() async {
    _setLoading(true);
    try {
      List<Map<String, dynamic>> posts =
          await _communityRepoFamily.getFamilyPosts();
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
    return await _communityRepoFamily.getTotalComments(postId);
  }
}
