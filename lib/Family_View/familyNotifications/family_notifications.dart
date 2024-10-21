import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Family_View/familyNotifications/widgets/family_notification_widget.dart';
import '../../res/components/colors.dart';

class FamilyNotificationsView extends StatefulWidget {
  const FamilyNotificationsView({super.key});

  @override
  State<FamilyNotificationsView> createState() =>
      _FamilyNotificationsViewState();
}

class _FamilyNotificationsViewState extends State<FamilyNotificationsView> {
  final String familyId = FirebaseAuth.instance.currentUser!.uid;

  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;

  Future<void> fetchOrders() async {
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
        List<Map<String, dynamic>> orders = [];
        Map<dynamic, dynamic> ordersData =
            snapshot.value as Map<dynamic, dynamic>;

        // Iterate through all orders
        ordersData.forEach((key, value) {
          Map<dynamic, dynamic> orderData = value as Map<dynamic, dynamic>;
          orders.add(orderData.cast<String, dynamic>());
        });

        setState(() {
          _orders = orders;
        });
      }
    } catch (e) {
      print('Error fetching orders: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.creamyColor,
      appBar: AppBar(
        backgroundColor: AppColor.lavenderColor,
        title: Text(
          'Notifications',
          style: GoogleFonts.getFont(
            "Poppins",
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppColor.creamyColor,
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.west,
              color: AppColor.creamyColor,
            )),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(
                  child: Text('Empty Notifications...'),
                )
              : Padding(
                  padding:
                      const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: _orders.map((order) {
                        String providerName =
                            order['providerName'] ?? 'Unknown Provider';
                        String status = order['status'];
                        String notificationDetail;
                        if (status == 'Pending') {
                          notificationDetail =
                              'Your request has been sent to $providerName.';
                        } else if (status == 'Completed') {
                          notificationDetail =
                              'Your request has been accepted by $providerName.';
                        } else {
                          notificationDetail = 'Status: $status';
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: FamilyNotificationsWidget(
                            providerName: providerName,
                            notificationDetail: notificationDetail,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
    );
  }
}
