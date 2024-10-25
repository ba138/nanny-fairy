import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors.dart';

class CardButton extends StatelessWidget {
  const CardButton(
      {super.key,
      required this.title,
      required this.color,
      required this.onTap});
  final String title;
  final Color color;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: color,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.getFont(
                  "Poppins",
                  textStyle: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w400,
                    color: AppColor.creamyColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
