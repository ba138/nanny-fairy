import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/FamilyController/family_auth_controller.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';
import '../../../res/components/colors.dart';
import '../../res/components/widgets/image_picker.dart';

class UploadIdFamily extends StatefulWidget {
  const UploadIdFamily({super.key});

  @override
  State<UploadIdFamily> createState() => _UploadIdFamilyState();
}

class _UploadIdFamilyState extends State<UploadIdFamily> {
  File? frontImage;
  void idFrontPic() async {
    File? img = await pickFrontImg(
      context,
    );
    setState(
      () {
        frontImage = img;
      },
    );
  }

  File? backImage;

  void idBackPic() async {
    File? img = await pickFrontImg(
      context,
    );
    setState(
      () {
        backImage = img;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<FamilyAuthController>(context);

    return Scaffold(
      backgroundColor: AppColor.authCreamColor,
      appBar: PreferredSize(
        preferredSize: const Size.square(70),
        child: AppBar(
          backgroundColor: AppColor.oceanColor,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(
              Icons.west,
              color: AppColor.authCreamColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Id Details',
            style: GoogleFonts.getFont(
              "Poppins",
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: AppColor.authCreamColor,
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          children: [
            const VerticalSpeacing(20.0),
            Container(
              height: 193,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.authCreamColor,
                borderRadius: BorderRadius.circular(6),
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
              child: frontImage != null
                  ? Container(
                      height: 130,
                      width: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(
                            frontImage!,
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              idFrontPic();
                            },
                            child: Container(
                              height: 56,
                              width: 56,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  color: AppColor.oceanColor),
                              child: const Center(
                                child: Icon(
                                  Icons.image,
                                  color: AppColor.authCreamColor,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'please upload id front picture',
                            style: GoogleFonts.getFont(
                              "Poppins",
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: AppColor.blackColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            const VerticalSpeacing(20.0),
            Container(
              height: 193,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColor.authCreamColor,
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
              child: backImage != null
                  ? Container(
                      height: 130,
                      width: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(
                            backImage!,
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: InkWell(
                              onTap: () {
                                idBackPic();
                              },
                              child: Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28),
                                    color: AppColor.oceanColor),
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    color: AppColor.authCreamColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'please upload id back picture',
                            style: GoogleFonts.getFont(
                              "Poppins",
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: AppColor.blackColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            const VerticalSpeacing(46.0),
            RoundedButton(
                title: 'Continue',
                onpress: () {
                  authController.saveIdImages(
                      context, frontImage, backImage, 'Unverified');
                }),
          ],
        ),
      ),
    );
  }
}
