import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Repository/home_ui_repostory.dart';
import 'package:nanny_fairy/ViewModel/family_search_view_model.dart';
import 'package:nanny_fairy/ViewModel/search_view_model.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:nanny_fairy/res/components/widgets/job_enum.dart';
import 'package:nanny_fairy/view/booked/widgets/booking_widget.dart';
import 'package:nanny_fairy/view/job/family_detail_provider.dart';
import 'package:provider/provider.dart';

class JobSearchSection extends StatefulWidget {
  const JobSearchSection({super.key});

  @override
  State<JobSearchSection> createState() => _JobSearchViewState();
}

class _JobSearchViewState extends State<JobSearchSection> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FamilySearchViewModel>(context, listen: false).fetchUsers();
    });

    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final viewModel =
        Provider.of<FamilySearchViewModel>(context, listen: false);
    viewModel.searchUsersByPassion(searchController.text);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Find Jobs',
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
                      'Clear Jobs',
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
          // SizedBox(height: 16.0),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Consumer<SearchViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (viewModel.users.isEmpty) {
                  return const Center(child: Text('No results found'));
                } else {
                  return ListView.builder(
                    itemCount: viewModel.users.length,
                    itemBuilder: (context, index) {
                      final user = viewModel.users[index];
                      List<String> passions = user.passions;

                      return BookingCartWidget(
                        primaryButtonTxt: 'View',
                        ontapView: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => FamilyDetailProvider(
                                name: "${user.firstName} ${user.lastName}",
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
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
