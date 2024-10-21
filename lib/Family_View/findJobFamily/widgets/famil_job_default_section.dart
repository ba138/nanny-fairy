import 'package:flutter/material.dart';
import 'package:nanny_fairy/FamilyController/family_home_controller.dart';
import 'package:nanny_fairy/Family_View/homeFamily/widgets/bookCart_home_widget.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:nanny_fairy/res/components/widgets/shimmer_effect.dart';
import 'package:provider/provider.dart';

import '../provider_detail.dart';

class FamilyJobDefaultSection extends StatefulWidget {
  const FamilyJobDefaultSection({super.key});

  @override
  State<FamilyJobDefaultSection> createState() =>
      _FamilyJobDefaultSectionState();
}

class _FamilyJobDefaultSectionState extends State<FamilyJobDefaultSection> {
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
    final familyhomeController = Provider.of<FamilyHomeController>(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: FutureBuilder(
          future: familyhomeController.getPopularJobs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ShimmerUi();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              Map<dynamic, dynamic> bookings =
                  snapshot.data as Map<dynamic, dynamic>;
              List<Widget> bookingWidgets = [];

              bookings.forEach((key, value) {
                if (value['Availability'] is Map) {
                  Map<String, dynamic> availabilityMap =
                      Map<String, dynamic>.from(value['Availability']);
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

                  List<Widget> dayButtons = daysSet.map((dayAbbreviation) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: DayButtonFamily(day: dayAbbreviation),
                    );
                  }).toList();
                  Map<String, String> ratingsData =
                      getRatingsAndTotalRatings(value);
                  Map<dynamic, dynamic> reviews = value['reviews'] ?? {};
                  double averageRating = calculateAverageRating(reviews);

                  bookingWidgets.add(
                    BookingCartWidgetHome(
                      primaryButtonColor: AppColor.primaryColor,
                      primaryButtonTxt: 'View',
                      ontapView: () {
                        Map<String, String> timeData =
                            (value['Time'] as Map<dynamic, dynamic>).map(
                                (key, value) =>
                                    MapEntry(key.toString(), value.toString()));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => ProviderDetails(
                              familyId: value['uid'],
                              profile: value['profile'],
                              name:
                                  "${value['firstName']} ${value['lastName']}",
                              bio: value['bio'],
                              horseRate: value['hoursrate'],
                              experience: value['Refernce']['experince'],
                              degree: value['education'],
                              dayButtons: dayButtons,
                              timeData: timeData,
                              ratings: averageRating,
                              totalRatings:
                                  int.parse(ratingsData['totalRatings']!),
                            ),
                          ),
                        );
                      },
                      profile: value['profile'],
                      name: "${value['firstName']} ${value['lastName']}",
                      degree: value['education'],
                      skill: '',
                      hoursRate: value['hoursrate'],
                      dayButtons: dayButtons,
                      ratings: averageRating,
                      totalRatings: int.parse(ratingsData['totalRatings']!),
                    ),
                  );
                } else {
                  const Center(child: Text('Invalid data format'));
                }
              });
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: bookingWidgets,
                ),
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
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
