import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Family_View/findJobFamily/widgets/find_job_family_widget.dart';
import 'package:nanny_fairy/view/job/widgets/find_job.dart';
import '../../res/components/colors.dart';
import '../../res/components/widgets/vertical_spacing.dart';

class FindJobFamilyView extends StatelessWidget {
  const FindJobFamilyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryBgColor,
      appBar: PreferredSize(
        preferredSize: const Size.square(70),
        child: AppBar(
          backgroundColor: AppColor.primaryColor,
          automaticallyImplyLeading: false,
          title: Text(
            'Home',
            style: GoogleFonts.getFont(
              "Poppins",
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: AppColor.whiteColor,
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: ListView(
          children: const [
            Column(
              children: [
                VerticalSpeacing(20.0),
                FindJobsFamilyWidget(),
                FindJobsFamilyWidget(),
                FindJobsFamilyWidget(),
                FindJobsFamilyWidget(),
                FindJobsFamilyWidget(),
                FindJobsFamilyWidget(),
                FindJobsFamilyWidget(),
                FindJobsFamilyWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}