import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/res/components/toggle_widget.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';
import '../../FamilyController/get_family_info_controller.dart';
import '../../res/components/colors.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    // Fetch users when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetFamilyInfoController>(context, listen: false)
          .getFamilyInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final getProviderInfo = Provider.of<GetFamilyInfoController>(context);

    return Scaffold(
      backgroundColor: AppColor.creamyColor,
      appBar: AppBar(
        backgroundColor: AppColor.creamyColor,
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
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                color: AppColor.creamyColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: AppColor.lavenderColor
                      .withOpacity(0.10), // Stroke color with 10% opacity
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.lavenderColor
                        .withOpacity(0.1), // Drop shadow color with 4% opacity
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
              ],
            ),
            const VerticalSpeacing(10.0),
            Container(
              height: 146,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.creamyColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: AppColor.lavenderColor
                      .withOpacity(0.10), // Stroke color with 10% opacity
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.lavenderColor
                        .withOpacity(0.1), // Drop shadow color with 10% opacity
                    blurRadius: 2,
                    offset: const Offset(1, 2),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                child: SingleChildScrollView(
                  // Added SingleChildScrollView here
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
                          future: getProviderInfo.getFamilyInfo(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
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
                            }
                            return const Center(
                              child: Text('No email'),
                            );
                          }),
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
            ),
          ],
        ),
      ),
    );
  }
}
