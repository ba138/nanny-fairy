// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/FamilyController/get_family_info_controller.dart';
import 'package:nanny_fairy/Family_View/profileFamily/widgets/edit_profile_family.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';
import '../../res/components/colors.dart';

class MyProfileFamily extends StatefulWidget {
  const MyProfileFamily({super.key});

  @override
  State<MyProfileFamily> createState() => _MyProfileFamilyState();
}

class _MyProfileFamilyState extends State<MyProfileFamily> {
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
    final getFamilyInfo = Provider.of<GetFamilyInfoController>(context);
    return Scaffold(
      backgroundColor: AppColor.lavenderColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Your Profile Details',
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
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final familyData = await getFamilyInfo
                  .getFamilyInfo(); // Await the Future to complete
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileFamily(
                    familyData: familyData,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.border_color_outlined,
              color: AppColor.creamyColor,
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColor.creamyColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: FutureBuilder<Map<dynamic, dynamic>>(
                future: getFamilyInfo.getFamilyInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    Map<dynamic, dynamic> family =
                        snapshot.data as Map<dynamic, dynamic>;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileItem(
                          icon: Icons.person,
                          label: 'Name',
                          value:
                              "${family['firstName'] ?? 'Name'} ${family['lastName'] ?? 'Name'}",
                        ),
                        const Divider(),
                        const VerticalSpeacing(10.0),
                        ProfileItem(
                          icon: Icons.location_on,
                          label: 'Address',
                          value: family['address'] ?? 'address',
                        ),
                        const Divider(),
                        const VerticalSpeacing(10.0),
                        ProfileItem(
                          icon: Icons.phone,
                          label: 'Telephone Number',
                          value: family['phoneNumber'] ?? 'phone',
                        ),
                        const Divider(),
                        const VerticalSpeacing(10.0),
                        ProfileItem(
                          icon: Icons.cake,
                          label: 'Date of Birth',
                          value: family['dob'] ?? 'dob',
                        ),
                        const Divider(),
                        const VerticalSpeacing(10.0),
                        ProfileItem(
                          icon: Icons.email,
                          label: 'Email Address',
                          value: family['email'] ?? 'email',
                        ),
                        const Divider(),
                        const VerticalSpeacing(10.0),
                        ProfileItem(
                          icon: Icons.description,
                          label: 'Description',
                          value: family['bio'] ?? 'bio',
                        ),
                        const VerticalSpeacing(16.0),
                      ],
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              )),
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColor.lavenderColor,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.getFont(
                    "Poppins",
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColor.blackColor,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: GoogleFonts.getFont(
                    "Poppins",
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.blackColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
