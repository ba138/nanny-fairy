import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/ViewModel/provider_distance_view_model.dart';
import 'package:nanny_fairy/ViewModel/provider_home_view_model.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/view/booked/widgets/booking_widget.dart';
import 'package:nanny_fairy/view/home/widgets/home_feature_widget.dart';
import 'package:nanny_fairy/view/home/widgets/provider_all_job.dart';
import 'package:nanny_fairy/view/job/family_detail_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeDefaultView extends StatefulWidget {
  const HomeDefaultView({super.key});

  @override
  State<HomeDefaultView> createState() => _HomeDefaultViewState();
}

class _HomeDefaultViewState extends State<HomeDefaultView> {
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Delay the UI-related actions until after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<ProviderHomeViewModel>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'This month',
                style: GoogleFonts.getFont(
                  "Poppins",
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.blackColor,
                  ),
                ),
              ),
              Text(
                'All reports',
                style: GoogleFonts.getFont(
                  "Poppins",
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.lavenderColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const VerticalSpeacing(10),
        SizedBox(
          height: 140,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 16),
                FutureBuilder(
                    future: homeViewModel.getPopularJobs(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: const HomeFeatureContainer(
                              txColor: AppColor.blackColor,
                              img: 'images/families.png',
                              title: '12',
                              subTitle: 'Total Families',
                              bgColor: AppColor.creamyColor,
                            ));
                      } else if (snapshot.hasData) {
                        return HomeFeatureContainer(
                          txColor: AppColor.blackColor,
                          img: 'images/families.png',
                          title: snapshot.data!.length.toString(),
                          subTitle: 'Total Families',
                          bgColor: AppColor.creamyColor,
                        );
                      } else {
                        return const HomeFeatureContainer(
                          txColor: AppColor.blackColor,
                          img: 'images/families.png',
                          title: '0',
                          subTitle: 'Total Families',
                          bgColor: AppColor.creamyColor,
                        );
                      }
                    }),
                const SizedBox(width: 16),
                FutureBuilder(
                    future: homeViewModel.getChats(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: const HomeFeatureContainer(
                              txColor: AppColor.blackColor,
                              img: 'images/families.png',
                              title: '12',
                              subTitle: 'Total Families',
                              bgColor: AppColor.creamyColor,
                            ));
                      } else if (snapshot.hasData) {
                        return HomeFeatureContainer(
                          txColor: AppColor.blackColor,
                          img: 'images/chats.png',
                          title: snapshot.data!.length.toString(),
                          subTitle: 'Total Chats',
                          bgColor: AppColor.creamyColor,
                        );
                      } else {
                        return const HomeFeatureContainer(
                          txColor: AppColor.blackColor,
                          img: 'images/chats.png',
                          title: '0',
                          subTitle: 'Total Chats',
                          bgColor: AppColor.creamyColor,
                        );
                      }
                    }),
                const SizedBox(width: 16),
                FutureBuilder(
                    future: homeViewModel.getPosts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: const HomeFeatureContainer(
                              txColor: AppColor.blackColor,
                              img: 'images/families.png',
                              title: '12',
                              subTitle: 'Total Families',
                              bgColor: AppColor.creamyColor,
                            ));
                      } else if (snapshot.hasData) {
                        return HomeFeatureContainer(
                          txColor: AppColor.blackColor,
                          img: 'images/families.png',
                          title: snapshot.data!.length.toString(),
                          subTitle: 'Total Posts',
                          bgColor: AppColor.creamyColor,
                        );
                      } else {
                        return const HomeFeatureContainer(
                          txColor: AppColor.blackColor,
                          img: 'images/families.png',
                          title: '0',
                          subTitle: 'Total Posts',
                          bgColor: AppColor.creamyColor,
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
        const VerticalSpeacing(16.0),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Consumer<ProviderDistanceViewModel>(
            builder: (context, viewModel, child) {
              final families = viewModel.distanceFilteredFamilies;
              bool isEmpty = false;
              Future.delayed(const Duration(seconds: 5), () {
                if (families.isEmpty) {
                  isEmpty = true;
                }
              });
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'popular jobs',
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
                              builder: (c) => ProviderAllJob(
                                distanceFilteredFamilies: families,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'see all',
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
                  isEmpty == false
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height / 2.7,
                          child: families.isEmpty
                              ? const Text(
                                  "No Families avaliable with in Range")
                              : SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: families.map((family) {
                                      List<String> passions =
                                          (family['FamilyPassions']
                                                  as List<dynamic>)
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
                                              builder: (c) =>
                                                  FamilyDetailProvider(
                                                name:
                                                    "${family['firstName']} ${family['lastName']}",
                                                bio: family['bio'] ?? '',
                                                profile: family['profile'],
                                                familyId: family['uid'],
                                                ratings: averageRating,
                                                totalRatings: int.parse(
                                                    ratingsData[
                                                        'totalRatings']!),
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
                                        totalRatings: int.parse(
                                            ratingsData['totalRatings']!),
                                      );
                                    }).toList(),
                                  ),
                                ),
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height / 2.6,
                          child: families.isEmpty
                              ? const Center(
                                  child: Text("No Families Found"),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: families.map((family) {
                                      List<String> passions =
                                          (family['FamilyPassions']
                                                  as List<dynamic>)
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
                                              builder: (c) =>
                                                  FamilyDetailProvider(
                                                name:
                                                    "${family['firstName']} ${family['lastName']}",
                                                bio: family['bio'] ?? '',
                                                profile: family['profile'],
                                                familyId: family['uid'],
                                                ratings: averageRating,
                                                totalRatings: int.parse(
                                                    ratingsData[
                                                        'totalRatings']!),
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
                                        totalRatings: int.parse(
                                            ratingsData['totalRatings']!),
                                      );
                                    }).toList(),
                                  ),
                                ),
                        ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
