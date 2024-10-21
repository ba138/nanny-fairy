import 'package:flutter/material.dart';
import 'package:nanny_fairy/ViewModel/provider_home_view_model.dart';
import 'package:nanny_fairy/view/booked/widgets/booking_widget.dart';
import 'package:nanny_fairy/view/job/family_detail_provider.dart';
import 'package:provider/provider.dart';

class JobDefaultSection extends StatefulWidget {
  const JobDefaultSection({super.key});

  @override
  State<JobDefaultSection> createState() => _JobDefaultSectionState();
}

class _JobDefaultSectionState extends State<JobDefaultSection> {
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
    final homeViewModel = Provider.of<ProviderHomeViewModel>(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: FutureBuilder(
            future: homeViewModel.getPopularJobs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                Map<dynamic, dynamic> bookings =
                    snapshot.data as Map<dynamic, dynamic>;
                List<Widget> bookingWidgets = [];

                bookings.forEach(
                  (key, value) {
                    List<String> passions =
                        (value['FamilyPassions'] as List<dynamic>)
                            .cast<String>();
                    Map<String, String> ratingsData =
                        getRatingsAndTotalRatings(value);
                    Map<dynamic, dynamic> reviews = value['reviews'] ?? {};
                    double averageRating = calculateAverageRating(reviews);

                    bookingWidgets.add(
                      BookingCartWidget(
                        primaryButtonTxt: 'View',
                        ontapView: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => FamilyDetailProvider(
                                name:
                                    " ${value['firstName']} ${value['lastName']}",
                                bio: value['bio'] ?? '',
                                profile: value['profile'],
                                familyId: value['uid'],
                                ratings: averageRating,
                                totalRatings: int.parse(
                                  ratingsData['totalRatings']!,
                                ),
                                passion: passions,
                              ),
                            ),
                          );
                        },
                        name: "${value['firstName']} ${value['lastName']}",
                        profilePic: value['profile'],
                        passion: passions,
                        ratings: averageRating,
                        totalRatings: int.parse(ratingsData['totalRatings']!),
                      ),
                    );
                  },
                );

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
      ),
    );
  }
}
