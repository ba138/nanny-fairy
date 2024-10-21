import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Family_View/findJobFamily/family_all_jobs_view.dart';
import 'package:nanny_fairy/Family_View/findJobFamily/provider_detail.dart';
import 'package:nanny_fairy/Family_View/homeFamily/home_view_family.dart';
import 'package:nanny_fairy/Family_View/homeFamily/widgets/bookCart_home_widget.dart';
import 'package:nanny_fairy/Family_View/homeFamily/widgets/home_Family_feature_widget.dart';
import 'package:nanny_fairy/Repository/family_home_ui_repository.dart';
import 'package:nanny_fairy/ViewModel/family_distance_view_model.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';

class FamilyDefaultView extends StatefulWidget {
  const FamilyDefaultView({super.key});

  @override
  State<FamilyDefaultView> createState() => _FamilyDefaultViewState();
}

class _FamilyDefaultViewState extends State<FamilyDefaultView> {
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'What are you looking for',
                style: GoogleFonts.getFont(
                  "Poppins",
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.blackColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const VerticalSpeacing(10),
        Consumer<FamilyDistanceViewModel>(
          builder: (context, familyDistanceViewModel, child) {
            return SizedBox(
              height: 120,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 16),
                    HomeFeatureContainerFamily(
                      bgColor: AppColor.lavenderColor,
                      img: 'images/cleaning.png',
                      title: 'Cleaning',
                      txColor: AppColor.creamyColor,
                      ontap: () {
                        familyDistanceViewModel.filterProvidersBySinglePassions(
                            "Cleaning",
                            familyDistance == null
                                ? 2
                                : double.parse(familyDistance!),
                            context);
                      },
                    ),
                    const SizedBox(width: 16),
                    HomeFeatureContainerFamily(
                      txColor: AppColor.creamyColor,
                      bgColor: AppColor.peachColor,
                      img: 'images/homeSitter.png',
                      title: 'Home Sitter',
                      ontap: () {
                        familyDistanceViewModel.filterProvidersBySinglePassions(
                            "Home Sitter",
                            familyDistance == null
                                ? 2
                                : double.parse(familyDistance!),
                            context);
                      },
                    ),
                    const SizedBox(width: 16),
                    HomeFeatureContainerFamily(
                      txColor: AppColor.creamyColor,
                      bgColor: const Color(0xffDDC912),
                      img: 'images/cleaning.png',
                      title: 'Elderly care',
                      ontap: () {
                        familyDistanceViewModel.filterProvidersBySinglePassions(
                            "Elderly care",
                            familyDistance == null
                                ? 2
                                : double.parse(familyDistance!),
                            context);
                      },
                    ),
                    const SizedBox(width: 16),
                    HomeFeatureContainerFamily(
                      txColor: AppColor.creamyColor,
                      bgColor: AppColor.peachColor,
                      img: 'images/homeSitter.png',
                      title: 'Animal care',
                      ontap: () {
                        familyDistanceViewModel.filterProvidersBySinglePassions(
                            "Animal care",
                            familyDistance == null
                                ? 2
                                : double.parse(familyDistance!),
                            context);
                      },
                    ),
                    const SizedBox(width: 16),
                    HomeFeatureContainerFamily(
                      txColor: AppColor.creamyColor,
                      bgColor: const Color(0xffDDC912),
                      img: 'images/cleaning.png',
                      title: 'Home work',
                      ontap: () {
                        familyDistanceViewModel.filterProvidersBySinglePassions(
                            "Home work",
                            familyDistance == null
                                ? 2
                                : double.parse(familyDistance!),
                            context);
                      },
                    ),
                    const SizedBox(width: 16),
                    HomeFeatureContainerFamily(
                      txColor: AppColor.creamyColor,
                      bgColor: AppColor.lavenderColor,
                      img: 'images/cleaning.png',
                      title: 'Music lesson',
                      ontap: () {
                        familyDistanceViewModel.filterProvidersBySinglePassions(
                            "Music lesson",
                            familyDistance == null
                                ? 2
                                : double.parse(familyDistance!),
                            context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            children: [
              const VerticalSpeacing(16.0),
              Consumer2<FamilyHomeUiRepository, FamilyDistanceViewModel>(
                builder: (context, uiState, familyDistanceController, child) {
                  return Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'What are you looking for',
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (c) => FamilyAllJobsView(
                                        providers: familyDistanceController
                                            .distanceFilteredProviders,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'See All',
                                  style: GoogleFonts.getFont(
                                    "Poppins",
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.lavenderColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const VerticalSpeacing(16.0),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2.6,
                            child: familyDistanceController
                                    .distanceFilteredProviders.isEmpty
                                ? const Text(
                                    "No Providers avaliable with in Range")
                                : SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: familyDistanceController
                                          .distanceFilteredProviders
                                          .map((provider) {
                                        try {
                                          Map<String, String> ratingsData =
                                              getRatingsAndTotalRatings(
                                                  provider);
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
                                                  builder: (c) =>
                                                      ProviderDetails(
                                                    familyId: provider['uid'],
                                                    profile:
                                                        provider['profile'],
                                                    name:
                                                        "${provider['firstName']} ${provider['lastName']}",
                                                    bio: provider['bio'],
                                                    horseRate:
                                                        provider['hoursrate'],
                                                    experience:
                                                        provider['Refernce']
                                                            ['experince'],
                                                    degree:
                                                        provider['education'],
                                                    dayButtons:
                                                        _buildDayButtons(
                                                            provider),
                                                    timeData: (provider['Time']
                                                            as Map<dynamic,
                                                                dynamic>)
                                                        .map(
                                                      (key, value) => MapEntry(
                                                        key.toString(),
                                                        value.toString(),
                                                      ),
                                                    ),
                                                    ratings: averageRating,
                                                    totalRatings: int.parse(
                                                        ratingsData[
                                                            'totalRatings']!),
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
                                            dayButtons:
                                                _buildDayButtons(provider),
                                            ratings: averageRating,
                                            totalRatings: int.parse(
                                                ratingsData['totalRatings']!),
                                            primaryButtonColor:
                                                AppColor.primaryColor,
                                          );
                                        } catch (e) {
                                          // Handle potential errors with data mapping
                                          debugPrint(
                                              'Error processing provider data: $e');
                                          return const SizedBox(); // Return an empty widget on error
                                        }
                                      }).toList(),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ],
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
