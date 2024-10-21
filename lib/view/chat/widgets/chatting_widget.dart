// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nanny_fairy/Repository/provider_chat_repository.dart';
import 'package:nanny_fairy/ViewModel/provider_chat_view_model.dart';
import '../../../res/components/colors.dart';

class ChatScreenWidget extends StatefulWidget {
  final String fimalyId;
  final bool isSeen;
  final String senderName;
  final String senderProfile;
  final String recieverName;
  final String recieverProfile;
  const ChatScreenWidget({
    super.key,
    required this.fimalyId,
    required this.isSeen,
    required this.senderName,
    required this.senderProfile,
    required this.recieverName,
    required this.recieverProfile,
  });

  @override
  State createState() => ChatScreenState();
}

class ChatMessage {
  final String text;
  final bool isSender;

  ChatMessage({required this.text, required this.isSender});
}

class ChatScreenState extends State<ChatScreenWidget> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.linearToEaseOut,
      );
    }
  }

  Widget _buildMessage(String message, String senderId) {
    var auth = FirebaseAuth.instance;
    final chatController = Provider.of<ProvidersChatController>(context);

    chatController.providerChatRepository
        .updateSeenStatus(widget.isSeen, widget.fimalyId);

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Container(
        alignment: senderId == auth.currentUser!.uid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: senderId == auth.currentUser!.uid
                ? AppColor.blossomColor
                : AppColor.blackColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatController = Provider.of<ProvidersChatController>(context);

    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder<List<Map<dynamic, dynamic>>>(
            stream: chatController.providerChatRepository
                .getFamilyChatStreamList(widget.fimalyId)
                .map((event) {
              List<Map<dynamic, dynamic>> chats = [];
              if (event.snapshot.value != null) {
                Map<dynamic, dynamic> chatData =
                    event.snapshot.value as Map<dynamic, dynamic>;
                chatData.forEach((key, value) {
                  chats.add(value);
                });

                // Convert timeSent strings to DateTime and sort the chats list
                chats.sort((a, b) {
                  try {
                    DateTime timeA = DateTime.parse(a['timeSent']);
                    DateTime timeB = DateTime.parse(b['timeSent']);
                    return timeA.compareTo(timeB); // Sort by timeSent
                  } catch (e) {
                    return 0; // Treat as equal if parsing fails
                  }
                });
              }
              return chats;
            }),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No messages found.'));
              } else {
                final chats = snapshot.data!;
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => scrollToBottom());

                return ListView.builder(
                  controller: scrollController,
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return _buildMessage(chat['message'], chat['senderId']);
                  },
                );
              }
            },
          ),
        ),
        const Divider(height: 1.0),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: _buildTextComposer(),
        ),
      ],
    );
  }

  Widget _buildTextComposer() {
    ProviderChatRepository chatController = ProviderChatRepository();

    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: AppColor.blackColor,
                  )),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.send,
              color: AppColor.blossomColor,
            ),
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                chatController.saveDataToContactsSubcollection(
                  _textController.text,
                  DateTime.now(),
                  widget.fimalyId,
                  widget.senderName,
                  widget.recieverName,
                  widget.senderProfile,
                  widget.recieverProfile,
                );
                _textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
