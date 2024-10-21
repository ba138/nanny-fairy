import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nanny_fairy/view/rating/widget/rating_card.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../res/components/colors.dart';
import '../../res/components/widgets/vertical_spacing.dart';
import '../../utils/utils.dart';

class TotalRatingScreen extends StatefulWidget {
  const TotalRatingScreen({
    super.key,
  });

  @override
  State<TotalRatingScreen> createState() => _TotalRatingScreenState();
}

class _TotalRatingScreenState extends State<TotalRatingScreen> {
  List<Map<String, dynamic>> reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> fetchReviews() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child('Providers')
        .child(currentUserId)
        .child('reviews');

    try {
      final snapshot = await ref.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedReviews = [];
        Map<dynamic, dynamic> reviewsData =
            snapshot.value as Map<dynamic, dynamic>;
        reviewsData.forEach((key, value) {
          loadedReviews.add(Map<String, dynamic>.from(value));
        });

        setState(() {
          reviews = loadedReviews;
        });
      }
    } catch (error) {
      Utils.flushBarErrorMessage('Error fetching reviews: $error', context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.creamyColor,
      appBar: AppBar(
        backgroundColor: AppColor.lavenderColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColor.creamyColor,
          ),
        ),
        title: const Text(
          "Reviews",
          style: TextStyle(
            fontFamily: 'CenturyGothic',
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: AppColor.creamyColor,
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : reviews.isEmpty
                ? const Center(child: Text('No reviews available.'))
                : Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    color: AppColor.lavenderColor,
                                    child: Center(
                                      child: Text(
                                        calculateAverageRating(reviews)
                                            .toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontFamily: 'CenturyGothic',
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.creamyColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const VerticalSpeacing(10),
                                  Text(
                                    "${reviews.length} reviews",
                                    style: const TextStyle(
                                      fontFamily: 'CenturyGothic',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.blackColor,
                                    ),
                                  ),
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: AppColor.peachColor,
                                        size: 18,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: AppColor.peachColor,
                                        size: 18,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: AppColor.peachColor,
                                        size: 18,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: AppColor.peachColor,
                                        size: 18,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: AppColor.peachColor,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Add your star rating rows here as before
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "5 stars",
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothic',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor,
                                        ),
                                      ),
                                      LinearPercentIndicator(
                                        animation: true,
                                        animationDuration: 1000,
                                        width: 160,
                                        percent: 0.8,
                                        progressColor: AppColor.lavenderColor,
                                        backgroundColor: Colors.grey.shade300,
                                      ),
                                      const Text(
                                        "200",
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothic',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "4 stars",
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothic',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor,
                                        ),
                                      ),
                                      LinearPercentIndicator(
                                        animation: true,
                                        animationDuration: 1000,
                                        width: 160,
                                        percent: 0.7,
                                        progressColor: AppColor.lavenderColor,
                                        backgroundColor: Colors.grey.shade300,
                                      ),
                                      const Text(
                                        "150",
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothic',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "3 stars ",
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothic',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor,
                                        ),
                                      ),
                                      LinearPercentIndicator(
                                        animation: true,
                                        animationDuration: 1000,
                                        width: 160,
                                        percent: 0.6,
                                        progressColor: AppColor.lavenderColor,
                                        backgroundColor: Colors.grey.shade300,
                                      ),
                                      const Text(
                                        "90",
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothic',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "2 stars",
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothic',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor,
                                        ),
                                      ),
                                      LinearPercentIndicator(
                                        animation: true,
                                        animationDuration: 1000,
                                        width: 160,
                                        percent: 0.5,
                                        progressColor: AppColor.lavenderColor,
                                        backgroundColor: Colors.grey.shade300,
                                      ),
                                      const Text(
                                        "30",
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothic',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "1 stars",
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothic',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor,
                                        ),
                                      ),
                                      LinearPercentIndicator(
                                        animation: true,
                                        animationDuration: 1000,
                                        width: 160,
                                        percent: 0.4,
                                        progressColor: AppColor.lavenderColor,
                                        backgroundColor: Colors.grey.shade300,
                                      ),
                                      const Text(
                                        "10",
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothic',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(),
                          ...reviews.map((review) {
                            return ReviewCard(
                              imgUrl: review['providerProfile'] ?? '',
                              profilePic: review['familyProfile'] ?? '',
                              name: review['providerName'] ?? 'Unknown',
                              rating: (review['countRatingStars'] ?? 0.0)
                                  .toString(),
                              time: review['timestamp'] ?? 'Unknown',
                              comment: review['FamilyComment'] ?? 'No comment',
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  double calculateAverageRating(List<Map<String, dynamic>> reviews) {
    if (reviews.isEmpty) return 0.0;
    double totalRating = 0.0;
    for (var review in reviews) {
      totalRating += review['countRatingStars'] ?? 0.0;
    }
    return totalRating / reviews.length;
  }
}
