import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/FamilyController/family_auth_controller.dart';
import 'package:nanny_fairy/ViewModel/family_distance_view_model.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';
import '../../../res/components/colors.dart';
import '../../res/components/widgets/image_picker.dart';
import '../../utils/utils.dart';

class UploadImageFamily extends StatefulWidget {
  const UploadImageFamily({super.key});

  @override
  State<UploadImageFamily> createState() => _UploadImageFamilyState();
}

class _UploadImageFamilyState extends State<UploadImageFamily> {
  TextEditingController bioController = TextEditingController();
  File? profilePic;
  bool _isWordCountValid = true;
  void pickProfile() async {
    File? img = await pickFrontImg(
      context,
    );
    setState(
      () {
        profilePic = img;
      },
    );
  }

  int _wordCount(String text) {
    if (text.trim().isEmpty) {
      return 0;
    }
    return text.trim().split(RegExp(r'\s+')).length;
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<FamilyAuthController>(context);

    return Scaffold(
      backgroundColor: AppColor.oceanColor,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColor.authCreamColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VerticalSpeacing(MediaQuery.of(context).size.height * 0.5),
                    Text(
                      'Write an introduction to yourself',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont(
                        "Poppins",
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColor.blackColor,
                        ),
                      ),
                    ),
                    const VerticalSpeacing(10),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor.authCreamColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: !_isWordCountValid
                              ? Colors.red
                              : AppColor.authCreamColor,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff1B81BC).withOpacity(0.1),
                            blurRadius: 2,
                            offset: const Offset(1, 2),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextField(
                          maxLines: 10,
                          controller: bioController,
                          onChanged: (value) {
                            setState(() {
                              int wordCount = _wordCount(value);
                              // Valid if word count is between 50 and 60
                              _isWordCountValid =
                                  wordCount >= 20 && wordCount <= 30;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Type...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !_isWordCountValid,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 10.0),
                        child: Text(
                          'Please enter less than 20 words',
                          style: GoogleFonts.getFont(
                            "Poppins",
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const VerticalSpeacing(40),
                    RoundedButton(
                        title: 'Continue',
                        onpress: () {
                          bool isValid =
                              _isWordCountValid && profilePic != null;
                          if (bioController.text.isNotEmpty && isValid) {
                            Provider.of<FamilyDistanceViewModel>(context,
                                    listen: false)
                                .fetchProviderDataFromFiebase();
                            authViewModel.saveProfileAndBio(
                                context, profilePic, bioController.text);
                          } else {
                            Utils.flushBarErrorMessage(
                              "Please complete the form correctly.",
                              context,
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
          // Top container that acts as AppBar
          Container(
            color: AppColor.oceanColor,
            height: 250,
            child: Column(
              children: [
                const SizedBox(height: 50),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.west,
                        color: AppColor.authCreamColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 50),
                    Text(
                      'Upload Image',
                      style: GoogleFonts.getFont(
                        "Poppins",
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: AppColor.authCreamColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          // Positioned CircleAvatar on top of all
          Positioned(
            top: 190,
            left: MediaQuery.of(context).size.width / 2 - 60,
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                  color: AppColor.avatarColor,
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(width: 4, color: AppColor.authCreamColor)),
              child: Center(
                child: profilePic == null
                    ? Image.asset(
                        'images/profile.png',
                        fit: BoxFit.cover,
                        color: AppColor.authCreamColor,
                      )
                    : Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          image: DecorationImage(
                            image: FileImage(
                              profilePic!,
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
              ),
            ),
          ),
          Positioned(
            top: 280,
            left: MediaQuery.of(context).size.width / 2 - 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColor.oceanColor),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        pickProfile();
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        size: 18,
                        color: AppColor.authCreamColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5.0),
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColor.oceanColor),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        pickProfile();
                      },
                      icon: const Icon(
                        Icons.save_as_outlined,
                        size: 18,
                        color: AppColor.authCreamColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
