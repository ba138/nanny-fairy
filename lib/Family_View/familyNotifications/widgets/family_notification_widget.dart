import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../res/components/colors.dart';

class FamilyNotificationsWidget extends StatelessWidget {
  const FamilyNotificationsWidget(
      {super.key,
      required this.providerName,
      required this.notificationDetail});

  final String providerName;
  final String notificationDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.creamyColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          strokeAlign: BorderSide.strokeAlignCenter,
          color: AppColor.lavenderColor
              .withOpacity(0.10), // Stroke color with 10% opacity
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.lavenderColor
                .withOpacity(0.1), // Drop shadow color with 4% opacity
            blurRadius: 2,
            offset: const Offset(1, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: AppColor.lavenderColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Center(
            child: Icon(
              Icons.notifications,
              color: AppColor.creamyColor,
            ),
          ),
        ),
        title: Text(
          providerName,
          style: GoogleFonts.getFont(
            "Poppins",
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColor.blackColor,
            ),
          ),
        ),
        subtitle: Text(
          notificationDetail,
          style: GoogleFonts.getFont(
            "Poppins",
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColor.grayColor,
            ),
          ),
        ),
      ),
    );
  }
}
