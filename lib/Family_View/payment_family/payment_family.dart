import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Family_View/familyChat/family_chat_view.dart';

import 'package:nanny_fairy/res/components/rounded_button.dart';
import '../../res/components/colors.dart';
import '../../res/components/loading_manager.dart';
import '../../res/components/widgets/vertical_spacing.dart';
import 'package:http/http.dart' as http;
import '../../utils/utils.dart';

class PaymentFamilyView extends StatefulWidget {
  final String userName;
  final String currentUserName;
  final String familyId;
  final String currentUserProfile;
  final String profile;
  final String providerRatings;
  final String providerTotalRatings;
  final String education;
  final String horlyRate;
  const PaymentFamilyView({
    super.key,
    required this.userName,
    required this.currentUserName,
    required this.familyId,
    required this.currentUserProfile,
    required this.profile,
    required this.providerRatings,
    required this.providerTotalRatings,
    required this.education,
    required this.horlyRate,
  });

  @override
  State<PaymentFamilyView> createState() => _PaymentFamilyViewState();
}

class _PaymentFamilyViewState extends State<PaymentFamilyView> {
  bool firstButton = true;
  bool secondButton = false;
  bool thirdButton = false;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text(
          'Add Payment Details ',
          style: TextStyle(
            fontFamily: 'CenturyGothic',
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: AppColor.blackColor,
          ),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: AppColor.blackColor,
          ),
        ),
      ),
      body: SafeArea(
        child: LoadingManager(
          isLoading: _isLoading,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const VerticalSpeacing(20),
                const Text(
                  'Select Payment Type',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'CenturyGothic',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColor.blackColor,
                  ),
                ),
                const VerticalSpeacing(20.0),
                SizedBox(
                  height: 66,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            firstButton = !firstButton;
                            secondButton = false;
                          });
                        },
                        child: Center(
                          child: Container(
                            height: 66,
                            width: 135,
                            decoration: BoxDecoration(
                              color: firstButton
                                  ? AppColor.primaryColor
                                  : AppColor.secondaryBgColor,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                width: 1,
                                color: firstButton
                                    ? AppColor.blackColor
                                    : Colors.transparent,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xff1B81BC).withOpacity(
                                      0.1), // Drop shadow color with 4% opacity
                                  blurRadius: 2,
                                  offset: const Offset(1, 2),
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30.0,
                                  width: 40.0,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage('images/idle.png'),
                                          fit: BoxFit.contain)),
                                ),
                                const VerticalSpeacing(5),
                                Text(
                                  "IDLE",
                                  style: TextStyle(
                                      fontFamily: 'CenturyGothic',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: firstButton
                                          ? AppColor.whiteColor
                                          : AppColor.blackColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      InkWell(
                        onTap: () {
                          setState(() {
                            firstButton = false;
                            secondButton = !secondButton;
                          });
                        },
                        child: Center(
                          child: Container(
                            height: 66,
                            width: 135,
                            decoration: BoxDecoration(
                              color: secondButton
                                  ? AppColor.primaryColor
                                  : AppColor.secondaryBgColor,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                width: 1,
                                color: secondButton
                                    ? AppColor.blackColor
                                    : Colors.transparent,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xff1B81BC).withOpacity(
                                      0.1), // Drop shadow color with 4% opacity
                                  blurRadius: 2,
                                  offset: const Offset(1, 2),
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage('images/paypal.png'),
                                          fit: BoxFit.contain)),
                                ),
                                const VerticalSpeacing(5),
                                Text(
                                  "Paypal",
                                  style: TextStyle(
                                    fontFamily: 'CenturyGothic',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: secondButton
                                        ? AppColor.whiteColor
                                        : AppColor.blackColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalSpeacing(46.0),
                RoundedButton(
                  title: 'Pay',
                  onpress: () {
                    if (firstButton) {
                      initIdlePayment();
                    } else if (secondButton) {
                      initiatePaypalCheckout(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Payment done PopUp
  void familypaymentDonePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle,
                  color: AppColor.primaryColor, size: 150),
              const VerticalSpeacing(16),
              Text(
                'Payment Done Congratulations You\n are subscribed now',
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
              RoundedButton(
                title: 'Continue to Chat',
                onpress: () {
                  debugPrint("this is the providerName:${widget.userName}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => FamilyChatView(
                        name: widget.userName,
                        id: widget.familyId,
                        profilePic: widget.profile,
                        isSeen: true,
                        currentUserName: widget.currentUserName,
                        currentUserProfilePic: widget.currentUserProfile,
                        providerRatings: widget.providerRatings,
                        providerTotalRatings: widget.providerRatings,
                        education: widget.education,
                        horlyRate: widget.horlyRate,
                      ),
                    ),
                  );
                },
              ),
              const VerticalSpeacing(16),
            ],
          ),
        );
      },
    );
  }

// save payment info
  Future<void> savePaymentInfo(String provider, bool status) async {
    final databaseRef = FirebaseDatabase.instance.ref();
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final paymentInfo = {
      'Payment': provider,
      'status': status ? 'completed' : 'failed',
      'timestamp': DateTime.now().toIso8601String(),
    };

    await databaseRef
        .child('Family')
        .child(userId)
        .child('paymentInfo')
        .set(paymentInfo);
  }

// Stripe payment
  Future<void> initIdlePayment() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.post(
          Uri.parse(
              "https://us-central1-nanny-fairy.cloudfunctions.net/stripePaymentIntentRequest"),
          body: {
            'email': 'email',
            'amount': '200',
            'address': 'address',
            'postal_code': 'postalCode',
            'city': 'city',
            'state': 'state',
            'name': 'name',
          });
      final jsonResponse = jsonDecode(
        response.body,
      );
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: jsonResponse['paymentIntent'],
        merchantDisplayName: 'Buying services',
        customerId: jsonResponse['customer'],
        customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
      ));
      await Stripe.instance.presentPaymentSheet();
      familypaymentDonePopup();
      await savePaymentInfo('Stripe', true); // Save payment success in Firebase
    } catch (e) {
      if (e is StripeException) {
        Utils.flushBarErrorMessage("Payment Cancelled", context);
      } else {
        Utils.flushBarErrorMessage("Problem in Payment", context);
      }
      await savePaymentInfo(
          'Stripe', false); // Save payment failure in Firebase
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// Get cloud function api to get success and cancel paypal payment
  Future<Map<String, String>> getPaymentUrls() async {
    final response = await http.get(Uri.parse(
        'https://us-central1-nanny-fairy.cloudfunctions.net/generatePaymentLinks'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);
      print(
          '///////////////////////API Response body: ${response.body}...................');

      // Check if the expected keys exist
      if (decoded.containsKey('returnURL') &&
          decoded.containsKey('cancelURL')) {
        return decoded.map((key, value) => MapEntry(key, value.toString()));
      } else {
        throw Exception('Missing expected keys in response');
      }
    } else {
      throw Exception('Failed to load payment URLs');
    }
  }

// Paypal payment
  void initiatePaypalCheckout(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    final urls = await getPaymentUrls();
    final returnUrl = urls['returnURL'];
    final cancelUrl = urls['cancelURL'];

    await Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckout(
        sandboxMode: true,
        clientId:
            "ARYGRC3LcGd2zaEJTN8Dman7ZZemJ2Q_Rw8VK_IZ3gPPmRl3XXHcUAgsI3QHhagrMufwfXjxrAegvq4Y",
        secretKey:
            "EIG_TvBPTVeNzFBmhpirGoVavcdxWhc7iiMI85-uFEn505KYJI5US5LN5JYXe0pehdexQqm9zYvUZ_KK",
        returnURL: returnUrl,
        cancelURL: cancelUrl,
        transactions: const [
          {
            "amount": {
              "total": '2',
              "currency": "EUR",
              "details": {
                "subtotal": '2',
                "shipping": '0',
                "shipping_discount": 0
              }
            },
            "description": "1 Year Subscription",
            "item_list": {
              "items": [
                {
                  "name": "1 Year Subscription",
                  "quantity": 1,
                  "price": '2',
                  "currency": "EUR"
                }
              ],
            }
          }
        ],
        note: "EUR",
        onSuccess: (Map params) async {
          await savePaymentInfo('PayPal', true);
          familypaymentDonePopup();
          setState(() {
            _isLoading = false;
          });
        },
        onError: (error) async {
          await savePaymentInfo('PayPal', false);
          Utils.flushBarErrorMessage("Payment Error: $error", context);
          setState(() {
            _isLoading = false;
          });
        },
        onCancel: () async {
          await savePaymentInfo('PayPal', false);
          Utils.flushBarErrorMessage("Payment Cancelled", context);
          setState(() {
            _isLoading = false;
          });
        },
      ),
    ));
  }
}
