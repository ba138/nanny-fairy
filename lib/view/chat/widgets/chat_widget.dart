// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nanny_fairy/Repository/get_provider_info.dart';

import 'package:nanny_fairy/view/chat/chat_view.dart';

import '../../../res/components/colors.dart';

class ChatWidget extends StatelessWidget {
  final String text;
  final String profilePic;
  final String familyId;
  final String time;
  final bool isSeen;
  final String username;
  final List<String> passions;
  final String ratings;
  final String totalRatings;

  const ChatWidget({
    super.key,
    required this.text,
    required this.profilePic,
    required this.familyId,
    required this.time,
    required this.isSeen,
    required this.username,
    required this.passions,
    required this.ratings,
    required this.totalRatings,
  });

  @override
  Widget build(BuildContext context) {
    GetProviderInfoRepo getProviderInfoRepo = GetProviderInfoRepo();
    getProviderInfoRepo.fetchCurrentFamilyInfo();
    String formatTime(String time) {
      try {
        // Parse the time string to DateTime
        DateTime parsedTime = DateTime.parse(time);
        // Format the DateTime to the desired format
        return DateFormat('hh:mm a').format(parsedTime);
      } catch (e) {
        // Handle the error, e.g., return a default value or the original string
        return "Invalid time";
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          // Navigator.pushNamed(context, RoutesName.chatView);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => ChatView(
                profilePic: profilePic,
                userName: username,
                familyId: familyId,
                isSeen: isSeen,
                currentUserName: getProviderInfoRepo.providerName!,
                currentUserProfile: getProviderInfoRepo.providerProfile!,
                familyTotalRatings: ratings,
                familyRatings: totalRatings,
                familyPassion: passions,
              ),
            ),
          );
        },
        child: Container(
          height: 93,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              strokeAlign: BorderSide.strokeAlignCenter,
              color: const Color(0xff1B81BC)
                  .withOpacity(0.10), // Stroke color with 10% opacity
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff1B81BC)
                    .withOpacity(0.1), // Drop shadow color with 4% opacity
                blurRadius: 2,
                offset: const Offset(1, 2),
                spreadRadius: 1,
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: const NetworkImage(
                  'https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg'),
              foregroundImage: NetworkImage(profilePic),
            ),
            title: Text(
              username,
              style: GoogleFonts.getFont(
                "Poppins",
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColor.blackColor,
                ),
              ),
            ),
            subtitle: SizedBox(
              width: 30,
              child: Text(
                text.length > 30 ? '${text.substring(0, 35)}...' : text,
                style: GoogleFonts.getFont(
                  "Poppins",
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSeen ? FontWeight.w400 : FontWeight.w600,
                    color: isSeen ? AppColor.grayColor : AppColor.blackColor,
                  ),
                ),
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatTime(time),
                  style: GoogleFonts.getFont(
                    "Poppins",
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.blackColor,
                    ),
                  ),
                ),
                isSeen == false
                    ? Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: AppColor.chatLavenderColor),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
