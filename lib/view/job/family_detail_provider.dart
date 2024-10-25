// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Repository/get_family_info_repo.dart';
import 'package:nanny_fairy/Repository/get_provider_info.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/view/chat/chat_view.dart';
import 'package:nanny_fairy/view/payment/payment.dart';
import '../../res/components/colors.dart';

class FamilyDetailProvider extends StatefulWidget {
  const FamilyDetailProvider(
      {super.key,
      this.profile,
      required this.name,
      required this.bio,
      required this.familyId,
      this.ratings,
      this.totalRatings,
      required this.passion});
  final String? profile;
  final String name;
  final String bio;
  final String familyId;
  final double? ratings;
  final int? totalRatings;
  final List<String> passion;

  @override
  State<FamilyDetailProvider> createState() => _FamilyDetailProviderState();
}

class _FamilyDetailProviderState extends State<FamilyDetailProvider> {
  GetFamilyInfoRepo getFamilyInfoRepo = GetFamilyInfoRepo();
  GetProviderInfoRepo getProviderInfoRepo = GetProviderInfoRepo();

  @override
  void initState() {
    getProviderInfoRepo.fetchCurrentFamilyInfo();
    super.initState();
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
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.profile == null
                    ? Container(
                        height: 150,
                        width: double
                            .infinity, // Fill the width of the parent container
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColor.primaryColor,
                        ),
                        child: Center(
                          child: Image.asset(
                            'images/popImg.png',
                            width: 150,
                            height: 150,
                          ),
                        ),
                      )
                    : Container(
                        height: 150,
                        width: double
                            .infinity, // Fill the width of the parent container
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColor.primaryColor,
                        ),
                        child: Center(
                          child: Image.network(
                            widget.profile!,
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
                      debugPrint("This is reciever Name:${widget.name}");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => PaymentView(
                            profile: widget.profile!,
                            userName: widget.name,
                            familyId: widget.familyId,
                            currentUserName: getProviderInfoRepo.providerName!,
                            currentUserProfile:
                                getProviderInfoRepo.providerProfile!,
                            ratings: widget.ratings.toString(),
                            totalRatings: widget.totalRatings.toString(),
                            passions: widget.passion,
                          ),
                        ),
                      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
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
          'Family Profile Detail',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 16,
                  right: 16,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                            height:
                                40), // Adjust this value to create space for the CircleAvatar
                        Text(
                          widget.name,
                          style: GoogleFonts.getFont(
                            "Poppins",
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                ),
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
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
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
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Officia irure irOfficia',
                                    style: GoogleFonts.getFont(
                                      "Poppins",
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
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
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'English, urdu',
                                    style: GoogleFonts.getFont(
                                      "Poppins",
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
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
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Officia irure irOfficia',
                                    style: GoogleFonts.getFont(
                                      "Poppins",
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // VerticalSpeacing(100),
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
                  child: widget.profile == null
                      ? const CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            'https://play-lh.googleusercontent.com/jInS55DYPnTZq8GpylyLmK2L2cDmUoahVacfN_Js_TsOkBEoizKmAl5-p8iFeLiNjtE=w526-h296-rw',
                          ),
                        )
                      : CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(widget.profile!),
                        ),
                ),
              ],
            ),
            VerticalSpeacing(MediaQuery.of(context).size.height * 0.57),
            Padding(
              padding: const EdgeInsets.only(left: 32.0, right: 32.0),
              child: RoundedButton(
                title: 'Chat With Family',
                onpress: () async {
                  var paymentInfo = await getCurrentUserPaymentInfo();
                  if (paymentInfo != null &&
                      paymentInfo['status'] == 'completed') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => ChatView(
                          profilePic: widget.profile!,
                          isSeen: false,
                          currentUserName:
                              getProviderInfoRepo.providerName.toString(),
                          userName: widget.name,
                          familyId: widget.familyId,
                          currentUserProfile:
                              getProviderInfoRepo.providerProfile.toString(),
                          familyTotalRatings: widget.totalRatings.toString(),
                          familyRatings: widget.ratings.toString(),
                          familyPassion: widget.passion,
                        ),
                      ),
                    );
                  } else {
                    showSubscribtionDialog(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<dynamic, dynamic>?> getCurrentUserPaymentInfo() async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      DatabaseReference paymentInfoRef = FirebaseDatabase.instance
          .ref()
          .child('Providers')
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
}
