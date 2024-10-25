import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/view/notifications/widgets/notifications_widget.dart';
import '../../res/components/colors.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final String providerId = FirebaseAuth.instance.currentUser!.uid;

  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;

  Future<void> fetchOrders() async {
    try {
      // Reference to the family's orders in the database
      DatabaseReference familyOrdersRef = FirebaseDatabase.instance
          .ref()
          .child('Providers')
          .child(providerId)
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
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: Text(
          'Notifications',
          style: GoogleFonts.getFont(
            "Poppins",
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppColor.whiteColor,
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
              color: AppColor.whiteColor,
            )),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: _orders.map((order) {
                    String familyName = order['familyName'] ?? 'Unknown family';
                    String status = order['status'];
                    String notificationDetail;

                    if (status == 'Pending') {
                      notificationDetail =
                          'You received an offer from $familyName.';
                    } else if (status == 'Completed') {
                      notificationDetail =
                          'You accepted the offer by $familyName.';
                    } else {
                      notificationDetail = 'Status: $status';
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: NotificationsWidget(
                        providerName: familyName,
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
