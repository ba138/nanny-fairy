import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Family_View/bookFamily/widgets/book_cart_widget_family.dart';
import '../../res/components/colors.dart';
import '../../res/components/widgets/vertical_spacing.dart';

class BookedViewFamily extends StatefulWidget {
  const BookedViewFamily({super.key});

  @override
  State<BookedViewFamily> createState() => _BookedViewFamilyState();
}

class _BookedViewFamilyState extends State<BookedViewFamily> {
  final String familyId = FirebaseAuth.instance.currentUser!.uid;

  List<Map<String, dynamic>> _completedOrders = [];
  bool _isLoading = true;

  Future<void> fetchCompletedOrders() async {
    try {
      // Reference to the family's orders in the database
      DatabaseReference familyOrdersRef = FirebaseDatabase.instance
          .ref()
          .child('Family')
          .child(familyId)
          .child('Orders');

      // Fetch all orders data
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
      print('Error fetching completed orders: $e');
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
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: ListView.builder(
                    itemCount: _completedOrders.length,
                    itemBuilder: (context, index) {
                      final order = _completedOrders[index];
                      return Column(
                        children: [
                          const VerticalSpeacing(20.0),
                          BookingCartWidgetFamily(
                            primaryButtonColor: AppColor.peachColor,
                            ontapView: () {
                              // Handle tap if necessary
                            },
                            primaryButtonTxt: 'Completed',
                            profile: order['providerPic'] ?? '',
                            name: order['providerName'] ?? '',
                            totalRatings: order['providerTotalRatings'] ?? '0',
                            ratings: order['providerRatings'] ?? '0.0',
                            education: order['education'] ?? '',
                            horlyRate: order['horlyRate'] ?? '',
                          ),
                        ],
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
