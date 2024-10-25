// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Family_View/findJobFamily/provider_detail.dart';
import 'package:nanny_fairy/Family_View/homeFamily/home_view_family.dart';
import 'package:nanny_fairy/Family_View/homeFamily/widgets/bookCart_home_widget.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:nanny_fairy/res/components/widgets/shimmer_effect.dart';
import 'package:nanny_fairy/utils/routes/routes_name.dart';

class FamilyAllJobsView extends StatefulWidget {
  List<Map<String, dynamic>> providers;
  FamilyAllJobsView({
    super.key,
    required this.providers,
  });

  @override
  State<FamilyAllJobsView> createState() => _FamilyAllJobsViewState();
}

class _FamilyAllJobsViewState extends State<FamilyAllJobsView> {
  Map<String, String> getRatingsAndTotalRatings(Map<dynamic, dynamic> value) {
    String ratings = value != null && value['countRatingStars'] != null
        ? value['countRatingStars'].toString()
        : 'N/A';
    String totalRatings =
        value['reviews'] != null ? value['reviews'].length.toString() : '0';

    return {
      'ratings': ratings,
      'totalRatings': totalRatings,
    };
  }

  double calculateAverageRating(Map<dynamic, dynamic> reviews) {
    if (reviews.isEmpty) return 0.0;
    double totalRating = 0.0;
    reviews.forEach((key, review) {
      totalRating += review['countRatingStars'] ?? 0.0;
    });
    return totalRating / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.west,
            color: AppColor.blackColor,
          ),
          onPressed: () {
            // distanceViewModel.distanceFilteredFamilies.clear();
            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.dashboardFamily,
              (route) => false,
            );
          },
        ),
        title: Text(
          'All Jobs',
          style: GoogleFonts.getFont(
            "Poppins",
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: AppColor.blackColor,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: widget.providers.isEmpty
                ? const ShimmerUi()
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: widget.providers.map((provider) {
                        try {
                          Map<String, String> ratingsData =
                              getRatingsAndTotalRatings(provider);
                          Map<dynamic, dynamic> reviews =
                              provider['reviews'] ?? {};
                          double averageRating =
                              calculateAverageRating(reviews);

                          return BookingCartWidgetHome(
                            primaryButtonTxt: 'View',
                            ontapView: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => ProviderDetails(
                                    familyId: provider['uid'],
                                    profile: provider['profile'],
                                    name:
                                        "${provider['firstName']} ${provider['lastName']}",
                                    bio: provider['bio'],
                                    horseRate: provider['hoursrate'],
                                    experience: provider['Refernce']
                                        ['experince'],
                                    degree: provider['education'],
                                    dayButtons: _buildDayButtons(provider),
                                    timeData: (provider['Time']
                                            as Map<dynamic, dynamic>)
                                        .map((key, value) => MapEntry(
                                            key.toString(), value.toString())),
                                    ratings: averageRating,
                                    totalRatings:
                                        int.parse(ratingsData['totalRatings']!),
                                  ),
                                ),
                              );
                            },
                            profile: provider['profile'],
                            name:
                                "${provider['firstName']} ${provider['lastName']}",
                            degree: provider['education'],
                            skill: '',
                            hoursRate: provider['hoursrate'],
                            dayButtons: _buildDayButtons(provider),
                            ratings: averageRating,
                            totalRatings:
                                int.parse(ratingsData['totalRatings']!),
                            primaryButtonColor: AppColor.primaryColor,
                          );
                        } catch (e) {
                          // Handle potential errors with data mapping
                          print('Error processing provider data: $e');
                          return const SizedBox(); // Return an empty widget on error
                        }
                      }).toList(),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDayButtons(Map<dynamic, dynamic> provider) {
    Map<String, dynamic> availabilityMap =
        Map<String, dynamic>.from(provider['Availability'] ?? {});
    Set<String> daysSet = {};

    availabilityMap.forEach((timeOfDay, daysMap) {
      if (daysMap is Map) {
        daysMap.forEach((day, isAvailable) {
          if (isAvailable && !daysSet.contains(day)) {
            daysSet.add(day.substring(0, 1).toUpperCase());
          }
        });
      }
    });

    return daysSet.map((dayAbbreviation) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: DayButtonFamily(day: dayAbbreviation),
      );
    }).toList();
  }
}
