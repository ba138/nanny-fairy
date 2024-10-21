import 'package:flutter/material.dart';
import 'package:nanny_fairy/Repository/family_chat_repository.dart';
import 'package:nanny_fairy/Repository/provider_chat_repository.dart';

class ProvidersChatController with ChangeNotifier {
  final ProviderChatRepository providerChatRepository;

  ProvidersChatController({required this.providerChatRepository});

  List<Map<dynamic, dynamic>> _chats = [];
  List<Map<dynamic, dynamic>> _chatsList = [];

  bool _isLoading = false;

  List<Map<dynamic, dynamic>> get chats => _chats;
  List<Map<dynamic, dynamic>> get chatsList => _chatsList;

  bool get isLoading => _isLoading;

  void loadChats() {
    _isLoading = true;
    notifyListeners();

    providerChatRepository.getFamilyChatStream().listen((event) {
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

    providerChatRepository.getFamilyChatStream().listen((event) {
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
    String familyId,
    String senderName,
    String receiverName,
    String senderProfilePic,
    String receiverProfilePic,
  ) async {
    await providerChatRepository.saveDataToContactsSubcollection(
      text,
      timeSent,
      familyId,
      senderName,
      receiverName,
      senderProfilePic,
      receiverProfilePic,
    );
    loadChats(); // Reload chats after saving
  }

  updateIsSeenStatus(bool isSeen, String familyId) {
    providerChatRepository.updateSeenStatus(isSeen, familyId);
  }
}
