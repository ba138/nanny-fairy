import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/ViewModel/provider_distance_view_model.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:nanny_fairy/res/components/widgets/shimmer_effect.dart';
import 'package:nanny_fairy/utils/routes/routes_name.dart';
import 'package:nanny_fairy/view/booked/widgets/booking_widget.dart';
import 'package:nanny_fairy/view/job/family_detail_provider.dart';
import 'package:provider/provider.dart';

class ProviderAllJob extends StatefulWidget {
  List<Map<String, dynamic>> distanceFilteredFamilies = [];
  ProviderAllJob({super.key, required this.distanceFilteredFamilies});

  @override
  State<ProviderAllJob> createState() => _ProviderAllJobState();
}

class _ProviderAllJobState extends State<ProviderAllJob> {
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

  Future<bool> _onWillPop() async {
    final distanceViewModel =
        Provider.of<ProviderDistanceViewModel>(context, listen: false);

    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.dashboard,
      (route) => false,
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final distanceViewModel =
        Provider.of<ProviderDistanceViewModel>(context, listen: false);
    // ignore: deprecated_member_use
    return WillPopScope(

      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColor.creamyColor,
        appBar: AppBar(
          backgroundColor: AppColor.creamyColor,
          leading: IconButton(
            icon: const Icon(
              Icons.west,
              color: AppColor.blackColor,
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.dashboard,
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
              child: widget.distanceFilteredFamilies.isEmpty
                  ? const ShimmerUi()
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: widget.distanceFilteredFamilies.map((family) {
                          List<String> passions =
                              (family['FamilyPassions'] as List<dynamic>)
                                  .cast<String>();
                          Map<String, String> ratingsData =
                              getRatingsAndTotalRatings(family);
                          Map<dynamic, dynamic> reviews =
                              family['reviews'] ?? {};
                          double averageRating =
                              calculateAverageRating(reviews);

                          return BookingCartWidget(
                            primaryButtonTxt: 'View',
                            ontapView: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => FamilyDetailProvider(
                                    name:
                                        "${family['firstName']} ${family['lastName']}",
                                    bio: family['bio'] ?? '',
                                    profile: family['profile'],
                                    familyId: family['uid'],
                                    ratings: averageRating,
                                    totalRatings:
                                        int.parse(ratingsData['totalRatings']!),
                                    passion: passions,
                                  ),
                                ),
                              );
                            },
                            name:
                                "${family['firstName']} ${family['lastName']}",
                            profilePic: family['profile'],
                            passion: passions,
                            ratings: averageRating,
                            totalRatings:
                                int.parse(ratingsData['totalRatings']!),
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
