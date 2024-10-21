import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final bool loading;
  final VoidCallback onpress;
  Color? buttonColor;
  Color? titleColor;

  RoundedButton({
    super.key,
    required this.title,
    required this.onpress,
    this.loading = false,
    this.buttonColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpress,
      child: Container(
        height: 46.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: buttonColor ?? AppColor.oceanColor,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
                  color: AppColor.creamyColor,
                )
              : Text(
                  title,
                  style: GoogleFonts.getFont(
                    "Poppins",
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: titleColor ?? AppColor.authCreamColor,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
