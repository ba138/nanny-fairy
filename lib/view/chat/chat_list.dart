import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/ViewModel/provider_chat_view_model.dart';
import 'package:nanny_fairy/res/components/widgets/shimmer_effect.dart';
import 'package:nanny_fairy/view/chat/widgets/chat_widget.dart';
import 'package:provider/provider.dart';

import '../../res/components/colors.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = Provider.of<ProvidersChatController>(context);

    return Scaffold(
      backgroundColor: AppColor.secondaryBgColor,
      appBar: PreferredSize(
        preferredSize: const Size.square(70),
        child: AppBar(
          backgroundColor: AppColor.primaryColor,
          automaticallyImplyLeading: false,
          title: Text(
            'Message',
            style: GoogleFonts.getFont(
              "Poppins",
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: AppColor.whiteColor,
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.only(top: 30, left: 16.0, right: 16.0),
          child: StreamBuilder<List<Map<dynamic, dynamic>>>(
            stream: chatController.providerChatRepository
                .getFamilyChatStream()
                .map((event) {
              List<Map<dynamic, dynamic>> chats = [];
              if (event.snapshot.value != null) {
                Map<dynamic, dynamic> chatData =
                    event.snapshot.value as Map<dynamic, dynamic>;
                chatData.forEach((key, value) {
                  chats.add(value);
                });
              }
              return chats.reversed
                  .toList(); // Reverse the list to get descending order
            }),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerUi();
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No messages found.'));
              } else {
                final chats = snapshot.data!;
                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    bool isSeen = chat['isSeen'];

                    return ChatWidget(
                      text: chat['lastMessage'],
                      profilePic: chat['profilePic'],
                      familyId: chat['familyId'],
                      time: chat['timeSent'],
                      isSeen: isSeen,
                      username: chat['name'],
                      passions: [],
                      ratings: '',
                      totalRatings: '',
                    );
                  },
                );
              }
            },
          )),
    );
  }
}
