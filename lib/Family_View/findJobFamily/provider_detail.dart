import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Family_View/familyChat/family_chat_view.dart';
import 'package:nanny_fairy/Family_View/payment_family/payment_family.dart';
import 'package:nanny_fairy/Repository/get_family_info_repo.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import '../../res/components/colors.dart';

class ProviderDetails extends StatefulWidget {
  const ProviderDetails({
    super.key,
    required this.profile,
    required this.name,
    required this.bio,
    required this.horseRate,
    required this.experience,
    required this.degree,
    required this.dayButtons,
    required this.timeData,
    required this.familyId,
    this.ratings,
    this.totalRatings,
  });
  final String profile;
  final String name;
  final String bio;
  final String horseRate;
  final String experience;
  final String degree;
  final List<Widget> dayButtons;
  final Map<String, String> timeData;
  final String familyId;
  final double? ratings;
  final int? totalRatings;

  @override
  State<ProviderDetails> createState() => _ProviderDetailsState();
}

class _ProviderDetailsState extends State<ProviderDetails> {
  GetFamilyInfoRepo getFamilyInfoRepo = GetFamilyInfoRepo();
  @override
  void initState() {
    getFamilyInfoRepo.fetchCurrentFamilyInfo();
    fetchReviews();
    super.initState();
  }

  List<Widget> reviewCards = [];

  void fetchReviews() async {
    DatabaseReference reviewsRef = FirebaseDatabase.instance
        .ref()
        .child('Providers')
        .child(widget.familyId)
        .child('reviews');

    reviewsRef.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> reviews =
            dataSnapshot.value as Map<dynamic, dynamic>;
        List<Widget> loadedReviewCards = [];

        reviews.forEach((key, value) {
          String familyName = value['familyName'] ?? 'Unknown';
          String familyComment = value['FamilyComment'] ?? 'No comment';
          String familyProfile = value['familyProfile'] ??
              'https://newprofilepic.photo-cdn.net//assets/images/article/profile.jpg?90af0c8';
          double countRatingStars =
              double.parse(value['countRatingStars']?.toString() ?? '0.0');

          loadedReviewCards.add(buildReviewCard(
              familyName, familyComment, familyProfile, countRatingStars));
        });

        setState(() {
          reviewCards = loadedReviewCards;
        });
      } else {
        setState(() {
          reviewCards = [
            Center(
              child: Text(
                'No reviews available',
                style: GoogleFonts.getFont(
                  "Poppins",
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ];
        });
      }
    });
  }

  // popUp
  void showSubscribtionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.whiteColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.zero,
            ),
          ),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width *
                0.8, // Set width to 80% of screen width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 150,
                  width:
                      double.infinity, // Fill the width of the parent container
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                    color: AppColor.primaryColor,
                  ),
                  child: Center(
                    child: Image.asset(
                      'images/popImg.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
                const VerticalSpeacing(16),
                Text(
                  'Agree to Subscription of\n€2/month',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    "Poppins",
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColor.blackColor,
                    ),
                  ),
                ),
                const VerticalSpeacing(30),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: RoundedButton(
                    title: 'Subscribe and Chat',
                    onpress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentFamilyView(
                                    userName: widget.name,
                                    currentUserName:
                                        getFamilyInfoRepo.familyName.toString(),
                                    familyId: widget.familyId,
                                    currentUserProfile: getFamilyInfoRepo
                                        .familyProfile
                                        .toString(),
                                    profile: widget.profile,
                                    providerRatings: widget.ratings.toString(),
                                    providerTotalRatings:
                                        widget.totalRatings.toString(),
                                    education: widget.degree,
                                    horlyRate: widget.horseRate,
                                  )));
                      // print(
                      //     'profile:${widget.profile}: userName:${widget.name}:familyId: ${widget.familyId}: currentUserName:${getFamilyInfoRepo.familyName!}:Family profile${getFamilyInfoRepo.familyProfile} ');
                    },
                  ),
                ),
                const VerticalSpeacing(16),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isExpanded = false;

  void _toggleViewMore() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.west,
            color: AppColor.whiteColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Provider Profile Detail',
          style: GoogleFonts.getFont(
            "Poppins",
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: AppColor.whiteColor,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 90),
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          widget.name,
                          style: GoogleFonts.getFont(
                            "Poppins",
                            textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColor.blackColor),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.ratings} (${widget.totalRatings} Reviews)',
                              style: GoogleFonts.getFont(
                                "Poppins",
                                textStyle: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.blackColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.bio,
                          style: GoogleFonts.getFont(
                            "Poppins",
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColor.grayColor,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Officia irure ir',
                                    style: GoogleFonts.getFont(
                                      "Poppins",
                                      textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor),
                                    ),
                                  ),
                                  Text(
                                    'Officia irure irOfficia',
                                    style: GoogleFonts.getFont(
                                      "Poppins",
                                      textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.blackColor),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Language spoken',
                                    style: GoogleFonts.getFont(
                                      "Poppins",
                                      textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor),
                                    ),
                                  ),
                                  Text(
                                    'English, urdu',
                                    style: GoogleFonts.getFont(
                                      "Poppins",
                                      textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.blackColor),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Officia irure ir',
                                    style: GoogleFonts.getFont(
                                      "Poppins",
                                      textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor),
                                    ),
                                  ),
                                  Text(
                                    'Officia irure irOfficia',
                                    style: GoogleFonts.getFont(
                                      "Poppins",
                                      textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.blackColor),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const VerticalSpeacing(16),
                        const Divider(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Skill & Experience',
                              style: GoogleFonts.getFont(
                                "Poppins",
                                textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.blackColor),
                              ),
                            ),
                            const VerticalSpeacing(10),
                            Row(
                              children: [
                                SkillContainerWidget(
                                    title: '${widget.horseRate}€',
                                    subTitle: 'Hours'),
                                const SizedBox(width: 16),
                                SkillContainerWidget(
                                    title: widget.experience,
                                    subTitle: 'Experience'),
                                const SizedBox(width: 16),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColor.avatarColor,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(
                                      children: [
                                        const Icon(Icons.school_outlined,
                                            color: AppColor.whiteColor),
                                        Text(
                                          widget.degree,
                                          style: GoogleFonts.getFont(
                                            "Poppins",
                                            textStyle: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //Availability portion
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                    height: 16), // Added spacing from the top
                                Text(
                                  'Availability',
                                  style: GoogleFonts.getFont(
                                    "Poppins",
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.blackColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Lorem ipsum dolor sit amet c',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColor.grayColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: widget
                                      .dayButtons, // Use the day buttons here
                                ),
                              ],
                            ),
                            const VerticalSpeacing(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: _toggleViewMore,
                                      child: Text(
                                        'View More',
                                        style: GoogleFonts.getFont(
                                          "Poppins",
                                          textStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            if (_isExpanded)
                              Container(
                                height: 216,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: AppColor.whiteColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 16),
                                      const VerticalSpeacing(16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Morning',
                                            style: GoogleFonts.getFont(
                                              "Poppins",
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: AppColor.blackColor,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${widget.timeData['MorningStart']} to ${widget.timeData['MorningEnd']}',
                                            style: GoogleFonts.getFont(
                                              "Poppins",
                                              textStyle: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: AppColor.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      const VerticalSpeacing(16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Afternoon',
                                            style: GoogleFonts.getFont(
                                              "Poppins",
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: AppColor.blackColor,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${widget.timeData['AfternoonStart']} to ${widget.timeData['AfternoonEnd']}',
                                            style: GoogleFonts.getFont(
                                              "Poppins",
                                              textStyle: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: AppColor.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      const VerticalSpeacing(16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Evening',
                                            style: GoogleFonts.getFont(
                                              "Poppins",
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: AppColor.blackColor,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${widget.timeData['EveningStart']} to ${widget.timeData['EveningEnd']}',
                                            style: GoogleFonts.getFont(
                                              "Poppins",
                                              textStyle: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: AppColor.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            const Divider(),
                            const VerticalSpeacing(16),
                            //Family rating Portion
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Family Ratings',
                                  style: GoogleFonts.getFont(
                                    "Poppins",
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                // Text(
                                //   'More Review',
                                //   style: GoogleFonts.getFont(
                                //     "Poppins",
                                //     textStyle: const TextStyle(
                                //       fontSize: 14,
                                //       fontWeight: FontWeight.w400,
                                //       color: AppColor.primaryColor,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            const VerticalSpeacing(16.0),
                            SizedBox(
                              height: 90,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: ScrollPhysics(),
                                child: Row(
                                  children: reviewCards,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const VerticalSpeacing(26),
                        RoundedButton(
                            title: 'Chat With Provider',
                            onpress: () async {
                              var paymentInfo =
                                  await getCurrentUserPaymentInfo();
                              if (paymentInfo != null &&
                                  paymentInfo['status'] == 'completed') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => FamilyChatView(
                                            profilePic: widget.profile,
                                            isSeen: false,
                                            currentUserName: getFamilyInfoRepo
                                                .familyName
                                                .toString(),
                                            name: widget.name,
                                            id: widget.familyId,
                                            currentUserProfilePic:
                                                getFamilyInfoRepo.familyProfile
                                                    .toString(),
                                            providerRatings:
                                                widget.ratings.toString(),
                                            providerTotalRatings:
                                                widget.totalRatings.toString(),
                                            education: widget.degree,
                                            horlyRate: widget.horseRate,
                                          )),
                                );
                              } else {
                                showSubscribtionDialog(context);
                              }
                            }),
                        const VerticalSpeacing(40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: MediaQuery.of(context).size.width / 2 - 40,
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                widget.profile,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<dynamic, dynamic>?> getCurrentUserPaymentInfo() async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      DatabaseReference paymentInfoRef = FirebaseDatabase.instance
          .ref()
          .child('Family')
          .child(currentUserId)
          .child('paymentInfo');

      // Fetch the payment info data from Firebase
      DatabaseEvent event = await paymentInfoRef.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        // Cast snapshot value to a Map
        return snapshot.value as Map<dynamic, dynamic>?;
      } else {
        print("No payment info found for the current user.");
        return null;
      }
    } catch (e) {
      print("Error fetching payment info: $e");
      return null;
    }
  }

  Widget buildReviewCard(String familyName, String familyComment,
      String familyProfile, double countRatingStars) {
    return Container(
      margin: const EdgeInsets.only(right: 10), // Space between cards
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 12.0),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(familyProfile),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  familyName,
                  style: GoogleFonts.getFont(
                    "Poppins",
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 90,
                  child: Text(
                    familyComment.length > 30
                        ? '${familyComment.substring(0, 30)}...'
                        : familyComment,
                    style: GoogleFonts.getFont(
                      "Poppins",
                      textStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 20,
            ),
            Text(
              countRatingStars.toString(),
              style: GoogleFonts.getFont(
                "Poppins",
                textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SkillContainerWidget extends StatelessWidget {
  const SkillContainerWidget(
      {super.key, required this.title, required this.subTitle});
  final String title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColor.avatarColor, borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.getFont(
                "Poppins",
                textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              subTitle,
              style: GoogleFonts.getFont(
                "Poppins",
                textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
