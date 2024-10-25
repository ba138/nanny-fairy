import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/ViewModel/auth_view_model.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/custom_text_field.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/utils/utils.dart';
import 'package:provider/provider.dart';
import '../../../res/components/colors.dart';

class EducationHorlyView extends StatefulWidget {
  const EducationHorlyView({super.key});

  @override
  State<EducationHorlyView> createState() => _EducationHorlyViewState();
}

class _EducationHorlyViewState extends State<EducationHorlyView> {
  TextEditingController educationController = TextEditingController();
  TextEditingController hoursRateController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    educationController.dispose();
    hoursRateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: AppColor.oceanColor,
      appBar: PreferredSize(
        preferredSize: const Size.square(70),
        child: AppBar(
          backgroundColor: Colors.transparent,
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
            'Enter your education & hours',
            style: GoogleFonts.getFont(
              "Poppins",
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColor.authCreamColor,
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColor.authCreamColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your education',
                  style: GoogleFonts.getFont(
                    "Poppins",
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColor.blackColor,
                    ),
                  ),
                ),
                const VerticalSpeacing(16.0),
                Container(
                  height: 184,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.authCreamColor,
                    borderRadius: BorderRadius.circular(12.0),
                    border:
                        Border.all(width: 0.5, color: AppColor.oceanColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.school_outlined,
                            size: 60, color: AppColor.avatarColor),
                        const VerticalSpeacing(12.0),
                        Text(
                          'Enter your Education',
                          style: GoogleFonts.getFont(
                            "Poppins",
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColor.blackColor,
                            ),
                          ),
                        ),
                        const VerticalSpeacing(16.0),
                        TextFieldCustom(

                          controller: educationController,
                          prefixIcon: const Icon(Icons.school_outlined),
                          maxLines: 1,
                          hintText: 'Enter your education',
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalSpeacing(16),
                Text(
                  'Enter your hours rate',
                  style: GoogleFonts.getFont(
                    "Poppins",
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColor.blackColor,
                    ),
                  ),
                ),
                const VerticalSpeacing(16.0),
                Container(
                  height: 184,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.authCreamColor,
                    borderRadius: BorderRadius.circular(12.0),
                    border:
                        Border.all(width: 0.5, color: AppColor.oceanColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.euro_outlined,
                            size: 60, color: AppColor.avatarColor),
                        const VerticalSpeacing(12.0),
                        Text(
                          'Enter your rate',
                          style: GoogleFonts.getFont(
                            "Poppins",
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColor.blackColor,
                            ),
                          ),
                        ),
                        const VerticalSpeacing(16.0),
                        TextFieldCustom(
                          keyboardType: TextInputType.phone,
                          controller: hoursRateController,
                          prefixIcon: const Icon(Icons.euro_outlined),
                          maxLines: 1,
                          hintText: 'Enter your rate',
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalSpeacing(46.0),
                RoundedButton(
                    title: 'Register',
                    onpress: () {
                      if (educationController.text.isNotEmpty ||
                          hoursRateController.text.isNotEmpty) {
                        authViewModel.saveEducationandHoursRate(
                          context: context,
                          education: educationController.text,
                          hoursRate: hoursRateController.text,
                        );
                      } else {
                        Utils.flushBarErrorMessage(
                            'Please Fill all the Fields', context);
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
