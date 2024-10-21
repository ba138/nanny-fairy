// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Family_View/familyChat/widgets/family_chat_screen_widget.dart';
import 'package:nanny_fairy/Family_View/homeFamily/dashboard_family/dashboard_family.dart';
import 'package:nanny_fairy/Repository/get_family_info_repo.dart';
import 'package:nanny_fairy/Repository/get_provider_info.dart';
import 'package:nanny_fairy/res/components/loading_manager.dart';
import 'package:nanny_fairy/utils/utils.dart';
import 'package:uuid/uuid.dart';
import '../../res/components/colors.dart';
import '../../res/components/rounded_button.dart';
import '../familyRating/family_rating.dart';

class FamilyChatView extends StatefulWidget {
  final String name;
  final String id;
  final String profilePic;
  final bool isSeen;
  final String currentUserName;
  final String currentUserProfilePic;
  final String providerRatings;
  final String providerTotalRatings;
  final String education;
  final String horlyRate;
  const FamilyChatView({
    super.key,
    required this.name,
    required this.id,
    required this.profilePic,
    required this.isSeen,
    required this.currentUserName,
    required this.currentUserProfilePic,
    required this.providerRatings,
    required this.providerTotalRatings,
    required this.education,
    required this.horlyRate,
  });

  @override
  State<FamilyChatView> createState() => _FamilyChatViewState();
}

class _FamilyChatViewState extends State<FamilyChatView> {
  final GetFamilyInfoRepo getFamilyInfoRepo = GetFamilyInfoRepo();
  final GetProviderInfoRepo getProviderInfoRepo = GetProviderInfoRepo();
  @override
  void initState() {
    getFamilyInfoRepo.fetchCurrentFamilyInfo();
    getProviderInfoRepo.fetchCurrentFamilyInfo();
    _initializeButtonText();
    super.initState();
  }

  final uUid = const Uuid().v1();
  final familyId = FirebaseAuth.instance.currentUser!.uid;
  bool _isLoading = false;
  String _buttonText = 'Hire';
  bool _isLocked = false;
  Future<void> _initializeButtonText() async {
    try {
      // Fetch the status from the provider's order data
      String? status = await fetchProviderOrderStatus();

      // Update _buttonText based on the fetched status
      setState(() {
        _buttonText = status ?? 'Hire';
      });
    } catch (e) {
      // Handle errors
      setState(() {
        _buttonText = 'Error';
      });
      print('Error initializing button text: $e');
    }
  }

  Future<String?> fetchProviderOrderStatus() async {
    String? status;

    try {
      // Reference to provider's order in the database
      DatabaseReference providerOrderRef = FirebaseDatabase.instance
          .ref()
          .child('Providers')
          .child(widget.id)
          .child('Orders')
          .child(familyId);

      // Fetch the provider's order data
      DataSnapshot snapshot = await providerOrderRef.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic> providerData =
            snapshot.value as Map<dynamic, dynamic>;
        status = providerData['status'] as String?;
      }
    } catch (e) {
      print('Error fetching provider order status: $e');
    }

    return status;
  }

  Future<void> hiringProvider() async {
    try {
      setState(() {
        _isLoading = true;
        _isLocked = true;
      });

      String familyId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to provider's order in the database
      DatabaseReference providerOrderRef = FirebaseDatabase.instance
          .ref()
          .child('Providers')
          .child(widget.id)
          .child('Orders')
          .child(familyId);

      // Reference to family's order in the database
      DatabaseReference familyOrderRef = FirebaseDatabase.instance
          .ref()
          .child('Family')
          .child(familyId)
          .child('Orders')
          .child(widget.id);

      // Data for the provider's order
      Map<String, dynamic> providerData = {
        'providerId': widget.id,
        'orderId': familyId,
        'providerName': widget.name,
        'providerPic': widget.profilePic,
        'providerRatings': widget.providerRatings,
        'providerTotalRatings': widget.providerTotalRatings,
        'education': widget.education,
        'horlyRate': widget.horlyRate,
        'status': 'Pending',
      };

      // Data for the family's order
      Map<String, dynamic> familyData = {
        'familyId': familyId,
        'orderId': widget.id,
        'familyName': widget.currentUserName,
        'familyProfile': widget.currentUserProfilePic,
        'status': 'Pending', // Set status to Pending
      };

      // Set data for the provider's order
      await providerOrderRef.set(familyData);

      // Set data for the family's order
      await familyOrderRef.set(providerData);

      setState(() {
        _buttonText = 'Pending'; // Update button text after creating order
        _isLoading = false;
        _isLocked = false;
      });

      Utils.toastMessage(
          'Order successfully created! Waiting for provider response.');
      print('Order successfully created!');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLocked = false;
      });
      print('Error: $e');
      Utils.flushBarErrorMessage('Error: $e', context);
    }
  }

  void familyHiringPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_outlined,
                    color: AppColor.chatLavenderColor, size: 100),
                const SizedBox(height: 16),
                Text(
                  'Confirm hiring this provider to start the service and notify them of your choice.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    "Poppins",
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColor.blackColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: RoundedButton(
                          title: 'Confirm',
                          onpress: () async {
                            Navigator.of(context).pop();
                            await hiringProvider();
                            setState(() {
                              _buttonText = 'Pending';
                              _isLocked = true;
                            });
                            print(
                                " providerId: ${widget.id}, providerName: ${widget.name}");
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: RoundedButton(
                          title: 'Cancel',
                          onpress: () {
                            Navigator.of(context).pop(); // Dismiss the dialog
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const DashBoardFamilyScreen(),
          ),
          (Route<dynamic> route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColor.chatLavenderColor,
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColor.chatLavenderColor,
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: const NetworkImage(
                            'https://user-images.githubusercontent.com/22866157/40578885-e3bf4e8e-6139-11e8-8be4-92fc3149f6f0.jpg',
                          ),
                          foregroundImage: NetworkImage(widget
                              .profilePic), // Set your profile image path here
                        ),
                        Positioned(
                          bottom: 0,
                          right: -2,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                              border: Border.all(
                                width: 2,
                                color: AppColor.chatLavenderColor,
                              ), // Online status indicator color
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Text.rich(
                    TextSpan(
                      text: '${widget.name}\n',
                      style: GoogleFonts.getFont(
                        "Poppins",
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.whiteColor,
                        ),
                      ),
                      children: [
                        TextSpan(
                          text: 'Online',
                          style: GoogleFonts.getFont(
                            "Poppins",
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              _buttonText == "Hire"
                  ? InkWell(
                      onTap: _isLocked
                          ? null
                          : () {
                              familyHiringPopup();
                            },
                      child: Container(
                        height: 26,
                        width: 82,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: AppColor.whiteColor,
                        ),
                        child: Center(
                          child: Text(
                            _buttonText,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColor.chatLavenderColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                  : _buttonText == "Pending"
                      ? InkWell(
                          onTap: _isLocked
                              ? null
                              : () {
                                  Utils.toastMessage(
                                      'Please wait provider response');
                                },
                          child: Container(
                            height: 26,
                            width: 82,
                            color: AppColor.creamyColor,
                            child: Center(
                              child: Text(
                                _buttonText,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColor.chatLavenderColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )
                      : _buttonText == "Completed"
                          ? InkWell(
                              onTap: () {
                                final familyId =
                                    FirebaseAuth.instance.currentUser!.uid;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FamilyRating(
                                      providerId: widget.id,
                                      familyId: familyId,
                                      familyProfile: widget.profilePic,
                                      familyName: widget.name,
                                      providerProfile:
                                          widget.currentUserProfilePic,
                                      providerName: widget.currentUserName,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 26,
                                width: 82,
                                color: AppColor.whiteColor,
                                child: const Center(
                                  child: Text(
                                    'Write Review',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColor.chatLavenderColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const Text('    '),
            ],
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
            ),
          ),
          child: FamilyChatScreenWidget(
            id: widget.id,
            isSeen: widget.isSeen,
            currentUserName: widget.currentUserName,
            currentUserProfile: widget.currentUserProfilePic,
            providerName: widget.name,
            providerProfilePic: widget.profilePic,
            providerRating: widget.providerRatings,
            providerTotalRating: widget.providerTotalRatings,
            education: widget.education,
            hourlyRate: widget.horlyRate,
          ),
        ),
      ),
    );
  }
}
