import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/FamilyController/family_community_controller.dart';
import 'package:nanny_fairy/Repository/get_family_info_repo.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/custom_text_field.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';

import '../../res/components/colors.dart';
import '../../res/components/widgets/image_picker.dart';
import '../../utils/utils.dart';

class UploadComunityPostFamily extends StatefulWidget {
  const UploadComunityPostFamily({super.key});

  @override
  State<UploadComunityPostFamily> createState() =>
      _UploadComunityPostFamilyState();
}

class _UploadComunityPostFamilyState extends State<UploadComunityPostFamily> {
  // popUp
  void showCommunityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.creamyColor,
          icon: const Icon(Icons.check_circle,
              color: AppColor.lavenderColor, size: 120),
          title: Text(
            'Congratulation you\nupload your Post',
            style: GoogleFonts.getFont(
              "Poppins",
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColor.blackColor,
              ),
            ),
          ),
          content: RoundedButton(
            title: 'Continue',
            onpress: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  File? post;
  void pickPost() async {
    File? img = await pickFrontImg(
      context,
    );
    setState(
      () {
        post = img;
      },
    );
  }

  final GetFamilyInfoRepo getFamilyInfoRepo = GetFamilyInfoRepo();
  @override
  void initState() {
    getFamilyInfoRepo.fetchCurrentFamilyInfo();
    super.initState();
  }

  final bool status = false;

  @override
  Widget build(BuildContext context) {
    final communityContrillerFamily =
        Provider.of<FamilyCommunityController>(context);
    return Scaffold(
      backgroundColor: AppColor.lavenderColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Upload Your Post',
          style: GoogleFonts.getFont(
            "Poppins",
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppColor.creamyColor,
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.west,
              color: AppColor.creamyColor,
            )),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.creamyColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                  children: [
                    const VerticalSpeacing(25),
                    post == null
                        ? Container(
                            height: 192,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/community.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  pickPost();
                                },
                                child: const CircleAvatar(
                                  backgroundColor: AppColor.lavenderColor,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.photo_camera,
                                      color: AppColor.creamyColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 192,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(
                                  post!,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  pickPost();
                                },
                                child: const CircleAvatar(
                                  backgroundColor: AppColor.lavenderColor,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.photo_camera,
                                      color: AppColor.creamyColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    const VerticalSpeacing(16.0),
                    TextFieldCustom(
                        shadowColor: AppColor.lavenderColor,
                        controller: titleController,
                        maxLines: 1,
                        hintText: 'Your title...'),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor.creamyColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: AppColor.lavenderColor.withOpacity(
                              0.10), // Stroke color with 10% opacity
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.lavenderColor.withOpacity(
                                0.1), // Drop shadow color with 4% opacity
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
                          controller: contentController,
                          decoration: const InputDecoration(
                            hintText: 'Your Content...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const VerticalSpeacing(30.0),
                    RoundedButton(
                      buttonColor: AppColor.lavenderColor,
                      titleColor: AppColor.whiteColor,
                      title: 'Continue',
                      onpress: () {
                        if (titleController.text.isNotEmpty ||
                            contentController.text.isNotEmpty) {
                          communityContrillerFamily.uploadPostFamily(
                            context,
                            post,
                            titleController.text,
                            contentController.text,
                            getFamilyInfoRepo.familyProfile!,
                            getFamilyInfoRepo.familyName!,
                            status,
                          );
                        } else {
                          Utils.flushBarErrorMessage(
                              "Please upload post", context);
                        }
                        // showCommunityDialog(context);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
