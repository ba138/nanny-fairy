import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nanny_fairy/res/components/loading_manager.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/custom_text_field.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/utils/routes/routes_name.dart';
import 'package:nanny_fairy/utils/utils.dart';
import 'package:uuid/uuid.dart';
import '../../res/components/colors.dart';

class Rating extends StatefulWidget {
  Rating({
    super.key,
    required this.providerId,
    required this.familyId,
    required this.familyProfile,
    required this.familyName,
    this.providerComment,
    this.countRatingStars,
    required this.providerProfile,
    required this.providerName,
  });
  final String providerId;
  final String familyId;
  final String familyProfile;
  final String providerProfile;
  final String familyName;
  final String providerName;
  String? providerComment;
  double? countRatingStars;

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  TextEditingController commentController = TextEditingController();
  double? countRatingStars = 0.0;
  var uuid = const Uuid().v1();
  bool _isLoading = false;

  // Function to submit review
  Future<void> submitReview() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // make review data to store
      final reviewData = {
        'providerId': widget.providerId,
        'familyId': widget.familyId,
        'nodeId': uuid,
        'familyName': widget.familyName,
        'providerProfile': widget.providerProfile,
        'familyProfile': widget.familyProfile,
        'providerName': widget.providerName,
        'providerComment': commentController.text.isNotEmpty
            ? commentController.text
            : widget.providerComment,
        'countRatingStars': countRatingStars ?? 0.0,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Reference to the Realtime Database
      DatabaseReference ref = FirebaseDatabase.instance
          .ref()
          .child('Family')
          .child(widget.familyId)
          .child('reviews')
          .child(uuid);

      // Store the data in the database
      await ref.set(reviewData);
      Utils.toastMessage('SuccessFully Submit Review');
      await Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.dashboard, (routes) => false);
    } catch (error) {
      Utils.flushBarErrorMessage('Error submitting review: $error', context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColor.blackColor,
            )),
        title: const Text(
          "Submit Review",
          style: TextStyle(
            fontFamily: 'CenturyGothic',
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: AppColor.blackColor,
          ),
        ),
      ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const VerticalSpeacing(20),
                  Card(
                    color: AppColor.whiteColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(widget.familyProfile),
                          ),
                          const VerticalSpeacing(16),
                          Text(
                            widget.familyName,
                            style: const TextStyle(
                              fontFamily: 'CenturyGothic',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: AppColor.blackColor,
                            ),
                          ),
                          const VerticalSpeacing(25),
                          const Text(
                            "How would you rate the quality of this Products",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'CenturyGothic',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColor.blackColor,
                            ),
                          ),
                          const VerticalSpeacing(25),
                          RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            allowHalfRating: true,
                            glowColor: Colors.amber,
                            itemCount: 5,
                            itemSize: 55,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star_rate_rounded,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              countRatingStars = rating;
                            },
                          ),
                          const VerticalSpeacing(25),
                          const Text(
                            "Leave your valuable comments",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: 'CenturyGothic',
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: AppColor.blackColor,
                            ),
                          ),
                          SizedBox(
                            height: 120,
                            width: double.infinity,
                            child: TextFieldCustom(
                              controller: commentController,
                              maxLines: 6,
                              hintText: "Additional comments...",
                            ),
                          ),
                          const VerticalSpeacing(30),
                          RoundedButton(
                            title: 'Submit Review',
                            onpress: () async {
                              await submitReview();
                            },
                          ),
                          const VerticalSpeacing(40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
