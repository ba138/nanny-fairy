import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FamilyChatRepository {
  final DatabaseReference firestore = FirebaseDatabase.instance.ref();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> saveDataToContactsSubcollection(
    String text,
    DateTime timeSent,
    String providerId,
    String senderName,
    String receiverName,
    String senderProfilePic,
    String receiverProfilePic,
    String providerRating,
    String providerTotalRatings,
    String education,
    String hourlyRate,
  ) async {
    try {
      int timestamp = timeSent.millisecondsSinceEpoch;

      // Update the last message and time in both the Providers and Family nodes
      Map<String, dynamic> receiverChatContact = {
        "name": senderName,
        "profilePic": senderProfilePic,
        "timeSent": DateTime.now().toUtc().toIso8601String(),
        "lastMessage": text,
        "familyId": auth.currentUser!.uid,
        "isSeen": false,
      };

      Map<String, dynamic> senderChatContact = {
        "name": receiverName,
        "profilePic": receiverProfilePic,
        "timeSent": DateTime.now().toUtc().toIso8601String(),
        "lastMessage": text,
        "Provider": providerId,
        "isSeen": true,
        'orderId': auth.currentUser!.uid,
        'providerRatings': providerRating,
        'providerTotalRatings': providerTotalRatings,
        'education': education,
        'horlyRate': hourlyRate,
        'status': 'Pending',
      };

      // Use update instead of set to avoid overwriting the entire node
      await firestore
          .child("Providers")
          .child(providerId)
          .child("chats")
          .child(auth.currentUser!.uid)
          .update(receiverChatContact);

      await firestore
          .child("Family")
          .child(auth.currentUser!.uid)
          .child("chats")
          .child(providerId)
          .update(senderChatContact);

      // Now save the message to the messages node
      await saveMessageToDatabase(
          text, timestamp, providerId, auth.currentUser!.uid);
      print(
          '..............$senderChatContact: receivercontect : $receiverChatContact');
    } catch (e) {
      print("Failed to save contact: $e");
    }
  }

  Stream<DatabaseEvent> getFamilyChatStream() {
    String userId = auth.currentUser!.uid;
    DatabaseReference familyChatRef =
        firestore.child("Family").child(userId).child("chats");

    return familyChatRef.orderByChild("timeSent").onValue;
  }

  Stream<DatabaseEvent> getFamilyChatStreamList(String providerId) {
    String userId = auth.currentUser!.uid;
    DatabaseReference familyChatRef = firestore
        .child("Family")
        .child(userId)
        .child("chats")
        .child(providerId)
        .child("messages");

    return familyChatRef.orderByChild("timeSent").onValue;
  }

  Future<void> saveMessageToDatabase(
      String text, int timeSent, String providerId, String familyId) async {
    try {
      var uuid = const Uuid().v1();
      print("Generated UUID: $uuid");

      // Save the message to the messages node for both the Providers and Family nodes
      await firestore
          .child("Providers")
          .child(providerId)
          .child("chats")
          .child(auth.currentUser!.uid)
          .child("messages")
          .child(uuid)
          .set({
        "message": text,
        "timeSent": DateTime.now().toUtc().toIso8601String(),
        'senderId': auth.currentUser!.uid,
        "messageId": uuid,
      });

      await firestore
          .child("Family")
          .child(auth.currentUser!.uid)
          .child("chats")
          .child(providerId)
          .child("messages")
          .child(uuid)
          .set({
        "message": text,
        "timeSent": DateTime.now().toUtc().toIso8601String(),
        'senderId': auth.currentUser!.uid,
        "messageId": uuid,
      });

      print("Message saved successfully.");
    } catch (e) {
      print("Failed to save message: $e");
    }
  }

  void updateSeenStatus(bool isSeen, String providerId) {
    try {
      if (isSeen == false) {
        firestore
            .child("Family")
            .child(auth.currentUser!.uid)
            .child("chats")
            .child(providerId)
            .update({"isSeen": true});
      } else {
        return;
      }
    } catch (e) {
      debugPrint("this error is in is seen status : $e");
    }
  }
}
