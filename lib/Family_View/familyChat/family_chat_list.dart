import 'package:flutter/material.dart';
import 'package:nanny_fairy/ViewModel/family_chat_view_model.dart';
import 'package:nanny_fairy/res/components/widgets/shimmer_effect.dart';
import 'package:provider/provider.dart';
import '../../res/components/colors.dart';
import 'package:nanny_fairy/Family_View/familyChat/widgets/family_chat_widget.dart';

class FamilyChatList extends StatelessWidget {
  const FamilyChatList({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = Provider.of<FamilyChatController>(context);

    return Scaffold(
      backgroundColor: AppColor.secondaryBgColor,
      appBar: PreferredSize(
        preferredSize: const Size.square(70),
        child: AppBar(
          backgroundColor: AppColor.primaryColor,
          automaticallyImplyLeading: false,
          title: const Text(
            'Message',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: AppColor.whiteColor,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 16.0, right: 16.0),
        child: StreamBuilder<List<Map<dynamic, dynamic>>>(
          stream: chatController.familyChatRepository
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
            return chats;
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
                  // bool isSeen = chat['isSeen'];
                  return FamilyChatWidget(
                    senderName: chat['name'],
                    senderProfiel: chat['profilePic'],
                    providerId: chat['Provider'],
                    timesend: chat['timeSent'], // Convert back to DateTime
                    text: chat['lastMessage'],
                    isSeen: chat['isSeen'],
                    providerRating: chat['providerRatings'],
                    providerTotalRating: chat['providerTotalRatings'],
                    education: chat['education'],
                    hourlyRating: chat['horlyRate'],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
