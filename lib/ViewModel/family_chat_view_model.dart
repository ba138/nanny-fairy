import 'package:flutter/material.dart';
import 'package:nanny_fairy/Repository/family_chat_repository.dart';

class FamilyChatController with ChangeNotifier {
  final FamilyChatRepository familyChatRepository;

  FamilyChatController({required this.familyChatRepository});

  List<Map<dynamic, dynamic>> _chats = [];
  List<Map<dynamic, dynamic>> _chatsList = [];

  bool _isLoading = false;

  List<Map<dynamic, dynamic>> get chats => _chats;
  List<Map<dynamic, dynamic>> get chatsList => _chatsList;

  bool get isLoading => _isLoading;

  void loadChats() {
    _isLoading = true;
    notifyListeners();

    familyChatRepository.getFamilyChatStream().listen((event) {
      _chats = [];
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> chatData =
            event.snapshot.value as Map<dynamic, dynamic>;
        chatData.forEach((key, value) {
          _chats.add(value);
        });
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  void loadChatsList() {
    _isLoading = true;
    notifyListeners();

    familyChatRepository.getFamilyChatStream().listen((event) {
      _chatsList = [];
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> chatData =
            event.snapshot.value as Map<dynamic, dynamic>;
        chatData.forEach((key, value) {
          _chatsList.add(value);
        });
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> saveChat(
    String text,
    DateTime timeSent,
    String providerId,
    String senderName,
    String receiverName,
    String senderProfilePic,
    String receiverProfilePic,
    String providerRating,
    String providerTotalRating,
    String education,
    String hourlyRate,
  ) async {
    await familyChatRepository.saveDataToContactsSubcollection(
      text,
      timeSent,
      providerId,
      senderName,
      receiverName,
      senderProfilePic,
      receiverProfilePic,
      providerRating,
      providerTotalRating,
      education,
      hourlyRate,
    );
    loadChats(); // Reload chats after saving
  }

  updateIsSeenStatus(bool isSeen, String providerId) {
    familyChatRepository.updateSeenStatus(isSeen, providerId);
  }
}
