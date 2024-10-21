import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Repository/home_ui_repostory.dart';
import 'package:nanny_fairy/res/components/widgets/job_enum.dart';
import 'package:nanny_fairy/res/components/widgets/job_searchbar.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/view/filter/widgets/job_filter_popup.dart';
import 'package:nanny_fairy/view/job/widgets/job_default_section.dart';
import 'package:nanny_fairy/view/job/widgets/job_filter_section.dart';
import 'package:nanny_fairy/view/job/widgets/job_search_section.dart';
import 'package:nanny_fairy/view/job/widgets/provider_job_distance_section.dart';
import 'package:provider/provider.dart';
import '../../res/components/colors.dart';

class JobView extends StatefulWidget {
  const JobView({super.key});

  @override
  State<JobView> createState() => _JobViewState();
}

class _JobViewState extends State<JobView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.secondaryBgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                    height: 150,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColor.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Jobs',
                          style: GoogleFonts.getFont(
                            "Poppins",
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ))),
                Positioned(
                  top: 125, // Adjust this value as needed
                  left: (MediaQuery.of(context).size.width - 320) /
                      2, // Center horizontally
                  child: JobSearchbar(
                    onTapFilter: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const JobFilterPopup()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const VerticalSpeacing(50),
            Consumer<HomeUiSwithchRepository>(
              builder: (context, uiState, _) {
                Widget selectedWidget;

                switch (uiState.selectedJobType) {
                  case JobUIType.SearchSection:
                    selectedWidget = const JobSearchSection();
                    break;
                  case JobUIType.DefaultSection:
                    selectedWidget = const JobDefaultSection();
                    break;
                  case JobUIType.FilterSection:
                    selectedWidget = const JobFilterSection();
                    break;
                  case JobUIType.DistanceSection:
                    selectedWidget = const ProviderJobDistanceSection();
                    break;
                }

                return selectedWidget;
              },
            ),
          ],
        ),
      ),
    );
  }
}
