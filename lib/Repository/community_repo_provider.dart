import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nanny_fairy/view/home/dashboard/dashboard.dart';
import 'package:uuid/uuid.dart';
import '../res/components/common_firebase_storge.dart';
import '../utils/utils.dart';

class CommunityRepoProvider {
  final FirebaseAuth _firebaseAuth;

  CommunityRepoProvider({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  var databaseReference = FirebaseDatabase.instance.ref();
// upload family post
  uploadCommunityPost(
    BuildContext context,
    File? post,
    String title,
    String content,
    String providerName,
    String providerProfile,
    bool status,
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
          databaseReference.child('ProviderCommunityPosts').child(uuid);

      String postUrl =
          'https://nakedsecurity.sophos.com/wp-content/uploads/sites/2/2013/08/facebook-silhouette_thumb.jpg';

      if (post != null) {
        CommonFirebaseStorage commonStorage = CommonFirebaseStorage();
        postUrl = await commonStorage.storeFileFileToFirebase(
          'ProviderCommunityPosts/$uuid',
          post,
        );
      } else {
        Utils.flushBarErrorMessage("Please pick The Profile Pic", context);
        Navigator.pop(context);
        return;
      }

      userRef.update({
        "postId": uuid,
        "post": postUrl,
        "title": title,
        "content": content,
        "userId": userId,
        "providerName": providerName,
        "providerProfile": providerProfile,
        "status": status,
        "timePost": DateTime.now().toUtc().toIso8601String()
      });
      Navigator.of(context).pop();
      Utils.toastMessage('Images saved successfully!');
      debugPrint(userId);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const DashBoardScreen()));
      // Navigator.pushNamedAndRemoveUntil(
      //   context,
      //   RoutesName.dashboard,
      //   (route) => false,
      // );
    } catch (e) {
      Navigator.of(context).pop();

      // Handle any errors that occur during save
      debugPrint('Error saving images: $e');
      Utils.flushBarErrorMessage('Failed to save Images', context);
    }
  }

  Future<void> addComment(String postId, String comment, String userId) async {
    try {
      final commentsRef = databaseReference
          .child('ProviderCommunityPosts')
          .child(postId)
          .child('comments');

      final newCommentRef = commentsRef.push();
      await newCommentRef.set({
        'commentId': newCommentRef.key,
        'userId': userId,
        'comment': comment,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Error adding comment: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getComments(String postId) async {
    List<Map<String, dynamic>> commentsList = [];

    try {
      final commentsRef = FirebaseDatabase.instance
          .ref()
          .child('ProviderCommunityPosts')
          .child(postId)
          .child('comments');

      DatabaseEvent event = await commentsRef.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        final commentsMap = snapshot.value as Map<dynamic, dynamic>;
        commentsMap.forEach((key, value) {
          commentsList.add({
            'commentId': key,
            'userId': value['userId'],
            'comment': value['comment'],
            'timestamp': value['timestamp'],
          });
        });
      }
    } catch (e) {
      debugPrint('Error fetching comments: $e');
    }

    return commentsList;
  }

  // get family posts
  Future<List<Map<String, dynamic>>> getCommunityPosts() async {
    try {
      final snapshot =
          await databaseReference.child('ProviderCommunityPosts').get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> posts = [];
        for (var post in snapshot.children) {
          posts.add({
            "status": post.child('status').value ?? '',
            "post": post.child('post').value ?? '',
            "title": post.child('title').value ?? '',
            "content": post.child('content').value ?? '',
            "userId": post.child('userId').value ?? '',
            "postId": post.child('postId').value ?? '',
          });
        }
        return posts;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching posts: $e');
      return [];
    }
  }

  Future<int> getTotalComments(String postId) async {
    try {
      final commentsRef = databaseReference
          .child('ProviderCommunityPosts')
          .child(postId)
          .child('comments');

      DatabaseEvent event = await commentsRef.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        return snapshot.children.length;
      } else {
        return 0;
      }
    } catch (e) {
      debugPrint('Error fetching total comments: $e');
      return 0;
    }
  }
}
