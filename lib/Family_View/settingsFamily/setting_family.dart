import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/res/components/toggle_widget.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/view/settings/edit_availability.dart';
import 'package:provider/provider.dart';
import '../../FamilyController/family_home_controller.dart';
import '../../ViewModel/get_provider_info_view_model.dart';
import '../../res/components/colors.dart';
import '../../res/components/widgets/shimmer_effect.dart';

class SettingsFamilyView extends StatefulWidget {
  const SettingsFamilyView({super.key});

  @override
  State<SettingsFamilyView> createState() => _SettingsFamilyViewState();
}

class _SettingsFamilyViewState extends State<SettingsFamilyView> {
  @override
  void initState() {
    super.initState();
    // Fetch users when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetProviderInfoViewModel>(context, listen: false)
          .getProviderInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final familyhomeController = Provider.of<FamilyHomeController>(context);
    final getProviderInfo = Provider.of<GetProviderInfoViewModel>(context);
    return Scaffold(
      backgroundColor: AppColor.secondaryBgColor,
      appBar: AppBar(
        backgroundColor: AppColor.secondaryBgColor,
        title: Text(
          'Settings',
          style: GoogleFonts.getFont(
            "Poppins",
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppColor.blackColor,
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
              color: AppColor.blackColor,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditAvailabilityView()));
              },
              child: Container(
                height: 28,
                width: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColor.primaryColor),
                child: const Center(
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VerticalSpeacing(16.0),
              Container(
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: const Color(0xff1B81BC)
                        .withOpacity(0.10), // Stroke color with 10% opacity
                    width: 1,
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
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Availability',
                                style: GoogleFonts.getFont(
                                  "Poppins",
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.blackColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Officia irure irure an',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColor.grayColor,
                                ),
                              ),
                            ],
                          ),
                          // Container(
                          //   height: 28,
                          //   width: 45,
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(4),
                          //       color: AppColor.primaryColor),
                          //   child: const Center(
                          //     child: Text(
                          //       'Edit',
                          //       style: TextStyle(
                          //         fontSize: 16,
                          //         color: AppColor.whiteColor,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 50,
                        child: FutureBuilder(
                          future: familyhomeController.getPopularJobs(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const ShimmerUi();
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('Availability Empty...'));
                            } else if (snapshot.hasData) {
                              Map<dynamic, dynamic> bookings =
                                  snapshot.data as Map<dynamic, dynamic>;
                              List<Widget> bookingWidgets = [];
                              String currentUserUID =
                                  FirebaseAuth.instance.currentUser!.uid;

                              bookings.forEach((key, value) {
                                if (value['uid'] == currentUserUID) {
                                  // Filter by current user UID
                                  if (value['Availability'] is Map) {
                                    Map<String, dynamic> availabilityMap =
                                        Map<String, dynamic>.from(
                                            value['Availability']);
                                    Set<String> daysSet = {};

                                    availabilityMap
                                        .forEach((timeOfDay, daysMap) {
                                      if (daysMap is Map) {
                                        daysMap.forEach((day, isAvailable) {
                                          if (isAvailable &&
                                              !daysSet.contains(day)) {
                                            daysSet.add(day
                                                .substring(0, 1)
                                                .toUpperCase());
                                          }
                                        });
                                      }
                                    });

                                    List<Widget> dayButtons =
                                        daysSet.map((dayAbbreviation) {
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: DayButtonProvider(
                                            day: dayAbbreviation),
                                      );
                                    }).toList();

                                    bookingWidgets.add(
                                      Row(
                                        children:
                                            dayButtons, // Use the day buttons here
                                      ),
                                    );
                                  } else {
                                    const Center(
                                        child: Text('Invalid data format'));
                                  }
                                }
                              });

                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 50),
                                  child: Column(
                                    children: bookingWidgets,
                                  ),
                                ),
                              );
                            } else {
                              return const Center(
                                  child: Text('No data available'));
                            }
                          },
                        ),
                      ),
                      const VerticalSpeacing(10),
                    ],
                  ),
                ),
              ),
              const VerticalSpeacing(16.0),
              Container(
                height: 216,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: const Color(0xff1B81BC).withOpacity(0.10),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff1B81BC).withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(1, 2),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FutureBuilder(
                    future: familyhomeController.getPopularJobs(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('Availability Empty...'));
                      } else if (snapshot.hasData) {
                        Map<dynamic, dynamic> bookings =
                            snapshot.data as Map<dynamic, dynamic>;
                        String currentUserUID =
                            FirebaseAuth.instance.currentUser!.uid;

                        Map<String, String> timeData = {};

                        bookings.forEach((key, value) {
                          if (value['uid'] == currentUserUID) {
                            // Filter by current user UID
                            if (value['Time'] is Map) {
                              timeData =
                                  (value['Time'] as Map<dynamic, dynamic>).map(
                                      (key, value) => MapEntry(
                                          key.toString(), value.toString()));
                            }
                          }
                        });

                        return Column(
                          children: [
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Timing',
                                  style: GoogleFonts.getFont(
                                    "Poppins",
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.blackColor,
                                    ),
                                  ),
                                ),
                                // Container(
                                //   height: 28,
                                //   width: 45,
                                //   decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(4),
                                //       color: AppColor.primaryColor),
                                //   child: const Center(
                                //     child: Text(
                                //       'Edit',
                                //       style: TextStyle(
                                //         fontSize: 16,
                                //         color: AppColor.whiteColor,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            const VerticalSpeacing(16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  '${timeData['MorningStart']} to ${timeData['MorningEnd']}',
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
                            Divider(),
                            VerticalSpeacing(16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  '${timeData['AfternoonStart']} to ${timeData['AfternoonEnd']}',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  '${timeData['EveningStart']} to ${timeData['EveningEnd']}',
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
                        );
                      }
                      return const Center(
                        child: Text('format exception'),
                      );
                    },
                  ),
                ),
              ),
              const VerticalSpeacing(16.0),
              Text(
                'Notification',
                style: GoogleFonts.getFont(
                  "Poppins",
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColor.blackColor,
                  ),
                ),
              ),
              const VerticalSpeacing(16.0),
              Container(
                height: 146,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: const Color(0xff1B81BC)
                        .withOpacity(0.10), // Stroke color with 10% opacity
                    width: 1,
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
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: GoogleFonts.getFont(
                          "Poppins",
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColor.blackColor,
                          ),
                        ),
                      ),
                      const VerticalSpeacing(16.0),
                      const ToggleWidget(title: 'promotioneel'),
                      const VerticalSpeacing(16.0),
                      const ToggleWidget(title: 'Status updates over bookigen'),
                    ],
                  ),
                ),
              ),
              const VerticalSpeacing(24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Account',
                    style: GoogleFonts.getFont(
                      "Poppins",
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColor.blackColor,
                      ),
                    ),
                  ),
                  // Text(
                  //   'Deactivr of verwijderen',
                  //   style: GoogleFonts.getFont(
                  //     "Poppins",
                  //     textStyle: const TextStyle(
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w400,
                  //       color: AppColor.primaryColor,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const VerticalSpeacing(10.0),
              Container(
                height: 146,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: const Color(0xff1B81BC)
                        .withOpacity(0.10), // Stroke color with 10% opacity
                    width: 1,
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
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VerticalSpeacing(16.0),
                      Text(
                        'email address',
                        style: GoogleFonts.getFont(
                          "Poppins",
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColor.blackColor,
                          ),
                        ),
                      ),
                      FutureBuilder<Map<dynamic, dynamic>>(
                        future: getProviderInfo.getProviderInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Text('waiting...'),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            Map<dynamic, dynamic> provider =
                                snapshot.data as Map<dynamic, dynamic>;
                            return Text(
                              provider['email'],
                              style: GoogleFonts.getFont(
                                "Poppins",
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.blackColor,
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                                child: Text('No data available'));
                          }
                        },
                      ),
                      const VerticalSpeacing(16.0),
                      Text(
                        'watchwood',
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
                        '***********',
                        style: GoogleFonts.getFont(
                          "Poppins",
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColor.blackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DayButtonProvider extends StatefulWidget {
  final String day;

  const DayButtonProvider({
    super.key,
    required this.day,
  });

  @override
  _DayButtonProviderState createState() => _DayButtonProviderState();
}

class _DayButtonProviderState extends State<DayButtonProvider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.transparent,
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Text(
          widget.day.toString(),
          style: const TextStyle(
            fontSize: 8,
            color: AppColor.blackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
