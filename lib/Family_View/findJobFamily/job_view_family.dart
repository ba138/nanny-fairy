import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Family_View/findJobFamily/widgets/famil_job_default_section.dart';
import 'package:nanny_fairy/Family_View/findJobFamily/widgets/family_job_distance_view.dart';
import 'package:nanny_fairy/Family_View/findJobFamily/widgets/family_job_filter_section.dart';
import 'package:nanny_fairy/Family_View/findJobFamily/widgets/family_job_search_seaction.dart';
import 'package:nanny_fairy/Repository/family_home_ui_repository.dart';
import 'package:nanny_fairy/res/components/widgets/family_job_enums.dart';
import 'package:nanny_fairy/res/components/widgets/family_job_search_bar.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/view/filter/widgets/family_job_filter_popup.dart';
import 'package:provider/provider.dart';
import '../../res/components/colors.dart';

class JobViewFamily extends StatefulWidget {
  const JobViewFamily({super.key});

  @override
  State<JobViewFamily> createState() => _JobViewFamilyState();
}

class _JobViewFamilyState extends State<JobViewFamily> {
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
                          'Providers',
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
                    ),
                  ),
                ),
                Positioned(
                  top: 110, // Adjust this value as needed
                  left: (MediaQuery.of(context).size.width - 320) /
                      2, // Center horizontally
                  child: FamilySearchBar(
                    onTapFilter: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => const FamilyJobFilterPopup(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const VerticalSpeacing(20),
            Consumer<FamilyHomeUiRepository>(
              builder: (context, uiState, _) {
                Widget selectedWidget;

                switch (uiState.selectedFamilyJobType) {
                  case FamilyJobEnums.DefaultSection:
                    selectedWidget = const FamilyJobDefaultSection();
                    break;
                  case FamilyJobEnums.FilterSection:
                    selectedWidget = const FamilyJobFilterSection();
                    break;
                  case FamilyJobEnums.SearchSection:
                    selectedWidget = const FamilyJobSearchSeaction();
                    break;
                  case FamilyJobEnums.DistanceFilter:
                    selectedWidget = const FamilyJobDistanceFilterView();
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

class DayButtonFamily extends StatefulWidget {
  final String day;

  const DayButtonFamily({
    super.key,
    required this.day,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DayButtonFamilyState createState() => _DayButtonFamilyState();
}

class _DayButtonFamilyState extends State<DayButtonFamily> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.transparent,
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Text(
          widget.day,
          style: const TextStyle(
            fontSize: 8,
            color: AppColor.blackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
