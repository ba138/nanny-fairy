import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nanny_fairy/Repository/family_chat_repository.dart';
import 'package:nanny_fairy/ViewModel/family_chat_view_model.dart';
import '../../../res/components/colors.dart';

class FamilyChatScreenWidget extends StatefulWidget {
  final String id;
  final bool isSeen;
  final String currentUserName;
  final String currentUserProfile;
  final String providerName;
  final String providerProfilePic;
  final String providerRating;
  final String providerTotalRating;
  final String education;
  final String hourlyRate;

  const FamilyChatScreenWidget({
    super.key,
    required this.id,
    required this.isSeen,
    required this.currentUserName,
    required this.currentUserProfile,
    required this.providerName,
    required this.providerProfilePic,
    required this.providerRating,
    required this.providerTotalRating,
    required this.education,
    required this.hourlyRate,
  });

  @override
  State createState() => ChatScreenState();
}

class ChatMessage {
  final String text;
  final bool isSender;

  ChatMessage({required this.text, required this.isSender});
}

class ChatScreenState extends State<FamilyChatScreenWidget> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // void _handleSubmitted(String text) {
  //   _textController.clear();
  //   ChatMessage message = ChatMessage(
  //       text: text,
  //       isSender: true); // You can modify this to determine sender/receiver.
  //   setState(() {
  //     _messages.insert(0, message);
  //   });
  // }

  Widget _buildMessage(String message, String senderId) {
    final chatController = Provider.of<FamilyChatController>(context);
    chatController.familyChatRepository
        .updateSeenStatus(widget.isSeen, widget.id);
    var auth = FirebaseAuth.instance;
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

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.linearToEaseOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatController = Provider.of<FamilyChatController>(context);

    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder<List<Map<dynamic, dynamic>>>(
            stream: chatController.familyChatRepository
                .getFamilyChatStreamList(widget.id)
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

                // Scroll to bottom only when new data is received
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  scrollToBottom();
                });

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
    FamilyChatRepository familyChatRepository = FamilyChatRepository();

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
              color: AppColor.chatLavenderColor,
            ),
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                familyChatRepository.saveDataToContactsSubcollection(
                    _textController.text,
                    DateTime.now(),
                    widget.id,
                    widget.currentUserName,
                    widget.providerName,
                    widget.currentUserProfile,
                    widget.providerProfilePic,
                    widget.providerRating,
                    widget.providerTotalRating,
                    widget.education,
                    widget.hourlyRate);
                _textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
