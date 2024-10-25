import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../res/components/colors.dart';
import '../../../res/components/widgets/vertical_spacing.dart';

class HomeFeatureContainer extends StatelessWidget {
  const HomeFeatureContainer(
      {super.key,
      required this.img,
      required this.title,
      required this.subTitle, required this.bgColor, required this.txColor});
  final String img;
  final String title;
  final String subTitle;
  final Color bgColor;
  final Color txColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 139,
      width: 147,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: bgColor,
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
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 46,
              width: 66,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(img),
                ),
              ),
            ),
            const VerticalSpeacing(10),
            Text(
              title,
              style: GoogleFonts.getFont(
                "Poppins",
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.lavenderColor,
                ),
              ),
            ),
            Text(
              subTitle,
              style: GoogleFonts.getFont(
                "Poppins",
                textStyle:  TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: txColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
