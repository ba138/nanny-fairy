import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Repository/provider_chat_repository.dart';
import 'package:nanny_fairy/view/chat/widgets/chatting_widget.dart';
import 'package:nanny_fairy/view/home/dashboard/dashboard.dart';
import 'package:uuid/uuid.dart';
import '../../Repository/get_family_info_repo.dart';
import '../../Repository/get_provider_info.dart';
import '../../res/components/colors.dart';
import '../../res/components/rounded_button.dart';
import '../../utils/utils.dart';
import '../rating/add_rating.dart';

class ChatView extends StatefulWidget {
  final String profilePic;
  final String userName;
  final String familyId;
  final bool isSeen;
  final String currentUserName;
  final String currentUserProfile;
  final String familyTotalRatings;
  final String familyRatings;
  final List<String> familyPassion;

  const ChatView({
    super.key,
    required this.profilePic,
    required this.userName,
    required this.familyId,
    required this.isSeen,
    required this.currentUserName,
    required this.currentUserProfile,
    required this.familyTotalRatings,
    required this.familyRatings,
    required this.familyPassion,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  ProviderChatRepository providerChatRepository = ProviderChatRepository();
  @override
  void initState() {
    providerChatRepository.updateSeenStatus(true, widget.familyId);
    getFamilyInfoRepo.fetchCurrentFamilyInfo();
    getProviderInfoRepo.fetchCurrentFamilyInfo();
    getProviderData();

    // fetchProviderDataAndSetButtonText();
    super.initState();
  }

  final providerId = FirebaseAuth.instance.currentUser!.uid;
  final GetFamilyInfoRepo getFamilyInfoRepo = GetFamilyInfoRepo();
  final GetProviderInfoRepo getProviderInfoRepo = GetProviderInfoRepo();

  final uUid = const Uuid().v1();
  bool _isLoading = false;

  bool _isLocked = false;
  String _buttonText = 'Loading...';

  Future<Map<String, String>> getProviderData() async {
    DatabaseReference providerOrderRef = FirebaseDatabase.instance
        .ref()
        .child('Providers')
        .child(providerId)
        .child('Orders')
        .child(widget.familyId);
    final providerOrderSnapshot = await providerOrderRef.get();
    if (providerOrderSnapshot.exists) {
      final providerOrderData = providerOrderSnapshot.value;
      if (providerOrderData is Map) {
        final status = providerOrderData['status'];
        print('Status : $status');
        setState(() {
          _buttonText = status;
        });
        return {
          'status': status,
        };
      }
    }
    setState(() {
      _buttonText = "No status";
    });
    return {};
  }

  Future<void> acceptFamilyOffer() async {
    try {
      setState(() {
        _isLoading = true;
      });
      DatabaseReference familyOrderRef = FirebaseDatabase.instance
          .ref()
          .child('Family')
          .child(widget.familyId)
          .child('Orders')
          .child(providerId);
      DatabaseReference providerOrderRef = FirebaseDatabase.instance
          .ref()
          .child('Providers')
          .child(providerId)
          .child('Orders')
          .child(widget.familyId);

      // Data update for the family's order
      Map<String, dynamic> familyUpdateData = {
        'familyProfile': widget.profilePic,
        'FamilyRatings': widget.familyRatings,
        'familyTotalRatings': widget.familyTotalRatings,
        'familyPassion': widget.familyPassion,
        'status': 'Completed',
      };
      Map<String, dynamic> providerUpdateData = {
        'status': 'Completed',
      };

      // Set data for the provider's accept
      await familyOrderRef.update(providerUpdateData);
      await providerOrderRef.update(familyUpdateData);

      setState(() {
        _isLoading = false;
      });
      Utils.toastMessage('Order successfully Accept it!');
      print('Order successfully created!');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error $e');
      Utils.flushBarErrorMessage('Error $e', context);
    }
  }

  void providerAcceptPopup() {
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
                const Icon(Icons.check_circle_outline,
                    color: AppColor.primaryColor, size: 100),
                const SizedBox(height: 16),
                Text(
                  'Confirm your acceptance of this hiring offer to begin the service. The family will be notified of your decision.',
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
                          title: 'Accept',
                          onpress: () async {
                            await acceptFamilyOffer();
                            Navigator.of(context).pop();
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
            builder: (context) => const DashBoardScreen(),
          ),
          (Route<dynamic> route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
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
                        color: Colors.blue,
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
                          foregroundImage: NetworkImage(
                            widget.profilePic,
                          ),
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
                                  color: AppColor.primaryColor,
                                ) // Online status indicator color
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Text.rich(
                    TextSpan(
                      text: '${widget.userName}\n',
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
              _buttonText == "Pending"
                  ? InkWell(
                      onTap: () {
                        providerAcceptPopup();
                      },
                      child: Container(
                        height: 26,
                        width: 82,
                        color: AppColor.whiteColor,
                        child: Center(
                          child: Text(
                            _buttonText,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                  : _buttonText == "Completed"
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Rating(
                                          providerId: providerId,
                                          familyId: widget.familyId,
                                          familyProfile: widget.profilePic,
                                          familyName: widget.userName,
                                          providerProfile:
                                              widget.currentUserProfile,
                                          providerName: widget.currentUserName,
                                        )));
                            // Navigator.pushNamed(context, RoutesName.addRating);
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
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const Text('      '),
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
          child: ChatScreenWidget(
            fimalyId: widget.familyId,
            isSeen: widget.isSeen,
            senderName: widget.currentUserName,
            senderProfile: widget.currentUserProfile,
            recieverName: widget.userName,
            recieverProfile: widget.profilePic,
          ),
        ),
      ),
    );
  }
}
