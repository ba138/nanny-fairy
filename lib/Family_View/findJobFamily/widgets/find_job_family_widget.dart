import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/utils/routes/routes_name.dart';
import '../../../../res/components/colors.dart';

class FindJobsFamilyWidget extends StatefulWidget {
  const FindJobsFamilyWidget({super.key});

  @override
  State<FindJobsFamilyWidget> createState() => _FindJobsFamilyWidgetState();
}

class _FindJobsFamilyWidgetState extends State<FindJobsFamilyWidget> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        height: 88,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.boxFillColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: ListTile(
            leading: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://www.shutterstock.com/image-photo/family-selfie-portrait-grandparents-children-260nw-2352440117.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            title: Text(
              'Hassnain',
              style: GoogleFonts.getFont(
                "Poppins",
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.blackColor,
                ),
              ),
            ),
            subtitle: Text(
              'Family\n⭐ 4.8 (456 Reviews)',
              style: GoogleFonts.getFont(
                "Poppins",
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColor.grayColor,
                ),
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$45',
                  style: GoogleFonts.getFont(
                    "Poppins",
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColor.grayColor,
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.jobViewFamily);
                  },
                  child: Container(
                    height: 30,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColor.primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        'View',
                        style: GoogleFonts.getFont(
                          "Poppins",
                          textStyle: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
