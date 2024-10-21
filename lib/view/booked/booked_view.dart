import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/utils/utils.dart';
import 'package:nanny_fairy/view/home/dashboard/widgets/bokkingFamilyCard.dart';
import '../../res/components/colors.dart';

class BookedView extends StatefulWidget {
  const BookedView({super.key});

  @override
  State<BookedView> createState() => _BookedViewState();
}

class _BookedViewState extends State<BookedView> {
  final String providerId = FirebaseAuth.instance.currentUser!.uid;

  List<Map<String, dynamic>> _completedOrders = [];
  bool _isLoading = true;

  Future<void> fetchCompletedOrders() async {
    try {
      DatabaseReference familyOrdersRef = FirebaseDatabase.instance
          .ref()
          .child('Providers')
          .child(providerId)
          .child('Orders');
      DataSnapshot snapshot = await familyOrdersRef.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> completedOrders = [];
        Map<dynamic, dynamic> ordersData =
            snapshot.value as Map<dynamic, dynamic>;

        // Iterate through all orders to find completed ones
        ordersData.forEach((key, value) {
          Map<dynamic, dynamic> orderData = value as Map<dynamic, dynamic>;

          if (orderData['status'] == 'Completed') {
            completedOrders.add(orderData.cast<String, dynamic>());
          }
        });

        setState(() {
          _completedOrders = completedOrders;
        });
      }
    } catch (e) {
      Utils.flushBarErrorMessage(
          'Error fetching completed orders: $e', context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCompletedOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.creamyColor,
      appBar: PreferredSize(
        preferredSize: const Size.square(70),
        child: AppBar(
          backgroundColor: AppColor.lavenderColor,
          automaticallyImplyLeading: false,
          title: Text(
            'Completed Booked',
            style: GoogleFonts.getFont(
              "Poppins",
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: AppColor.creamyColor,
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _completedOrders.isNotEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 20),
                  child: ListView.builder(
                    itemCount: _completedOrders.length,
                    itemBuilder: (context, index) {
                      final order = _completedOrders[index];
                      List<String> passion = [];
                      if (order.containsKey('familyPassion') &&
                          order['familyPassion'] is List) {
                        passion = List<String>.from(order['familyPassion']);
                      } else {
                        order.forEach((key, value) {
                          if (int.tryParse(key) != null) {
                            passion.add(value.toString());
                          }
                        });
                      }
                      return BookingFamilyCard(
                        primaryButtonTxt: 'Completed',
                        ontapView: () {
                          // Handle tap if necessary
                        },
                        name: order['familyName'] ?? '',
                        passion: passion,
                        profilePic: order['familyProfile'] ?? '',
                        ratings: order['FamilyRatings'] ?? '',
                        totalRatings: order['familyTotalRatings'] ?? '',
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text(
                    'No Completed Orders Found',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
    );
  }
}
