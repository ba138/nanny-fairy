import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/FamilyController/family_home_controller.dart';
import 'package:nanny_fairy/Family_View/findJobFamily/provider_detail.dart';
import 'package:nanny_fairy/Family_View/homeFamily/widgets/bookCart_home_widget.dart';
import 'package:nanny_fairy/Repository/family_home_ui_repository.dart';
import 'package:nanny_fairy/ViewModel/family_distance_view_model.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:nanny_fairy/res/components/widgets/family_home_ui_enums.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';

import '../../homeFamily/widgets/day_button_widget.dart';

class FamilyJobDistanceFilterView extends StatefulWidget {
  const FamilyJobDistanceFilterView({super.key});

  @override
  State<FamilyJobDistanceFilterView> createState() =>
      _FamilyJobDistanceFilterViewState();
}

class _FamilyJobDistanceFilterViewState
    extends State<FamilyJobDistanceFilterView> {
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
    return Consumer2<FamilyHomeUiRepository, FamilyDistanceViewModel>(
      builder: (context, uiState, familyhomeController, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Distance Filtered Providers',
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
                          uiState.switchToJobDefaultSection();
                        },
                        child: Text(
                          'Clear All',
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
                  ),
                  const VerticalSpeacing(16.0),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 1.3,
                    child: familyhomeController
                            .distanceFilteredProviders.isEmpty
                        ? const Center(child: Text('No data available'))
                        : SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: familyhomeController
                                  .distanceFilteredProviders
                                  .map((provider) {
                                try {
                                  List<String> passions =
                                      (provider['FamilyPassions']
                                                  as List<dynamic>?)
                                              ?.cast<String>() ??
                                          [];
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
                                            dayButtons:
                                                _buildDayButtons(provider),
                                            timeData: (provider['Time']
                                                    as Map<dynamic, dynamic>)
                                                .map((key, value) => MapEntry(
                                                    key.toString(),
                                                    value.toString())),
                                            ratings: averageRating,
                                            totalRatings: int.parse(
                                                ratingsData['totalRatings']!),
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
                ],
              ),
            ),
          ],
        );
      },
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
