import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Repository/home_ui_repostory.dart';
import 'package:nanny_fairy/ViewModel/filter_view_model.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:nanny_fairy/res/components/widgets/job_enum.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/view/booked/widgets/booking_widget.dart';
import 'package:nanny_fairy/view/job/family_detail_provider.dart';
import 'package:provider/provider.dart';

class JobFilterSection extends StatefulWidget {
  const JobFilterSection({super.key});

  @override
  State<JobFilterSection> createState() => _JobFilterSectionState();
}

class _JobFilterSectionState extends State<JobFilterSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: Consumer<HomeUiSwithchRepository>(
              builder: (context, uiState, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Jobs',
                  style: GoogleFonts.getFont(
                    "Poppins",
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColor.blackColor,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    uiState.switchToJobType(JobUIType.DefaultSection);
                  },
                  child: Text(
                    'Clear Filter',
                    style: GoogleFonts.getFont(
                      "Poppins",
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
        Consumer<FilteredViewModel>(
          builder: (context, filteredViewModel, child) {
            return Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                children: [
                  const VerticalSpeacing(16.0),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.6,
                    child: filteredViewModel.filteredUsers.isEmpty
                        ? const Center(child: Text('No results found'))
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredViewModel.filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user =
                                  filteredViewModel.filteredUsers[index];
                              List<String> passions = user.passions;

                              return BookingCartWidget(
                                primaryButtonTxt: 'View',
                                ontapView: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (c) => FamilyDetailProvider(
                                        name:
                                            "${user.firstName} ${user.lastName}",
                                        bio: user.bio,
                                        profile: user.profile,
                                        familyId: user.uid,
                                        ratings: user.averageRating,
                                        totalRatings: user.totalRatings,
                                        passion: passions,
                                      ),
                                    ),
                                  );
                                },
                                name: "${user.firstName} ${user.lastName}",
                                profilePic: user.profile,
                                passion: passions,
                                ratings: user.averageRating,
                                totalRatings: user.totalRatings,
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
