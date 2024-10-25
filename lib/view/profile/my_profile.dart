import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';
import '../../ViewModel/get_provider_info_view_model.dart';
import '../../res/components/colors.dart';
import 'edit_profile.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetProviderInfoViewModel>(context, listen: false)
          .getProviderInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final getProviderInfo = Provider.of<GetProviderInfoViewModel>(context);
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
              final providerData = await getProviderInfo
                  .getProviderInfo(); // Await the Future to complete
              if (providerData.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfile(
                      providerData: providerData,
                    ),
                  ),
                );
              }
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
              future: getProviderInfo.getProviderInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  Map<dynamic, dynamic> provider =
                      snapshot.data as Map<dynamic, dynamic>;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileItem(
                        icon: Icons.person,
                        label: 'Name',
                        value:
                            "${provider['firstName']} ${provider['lastName']}",
                      ),
                      const Divider(),
                      const VerticalSpeacing(10.0),
                      ProfileItem(
                        icon: Icons.location_on,
                        label: 'Address',
                        value: provider['address'],
                      ),
                      const Divider(),
                      const VerticalSpeacing(10.0),
                      ProfileItem(
                        icon: Icons.phone,
                        label: 'Telephone Number',
                        value: provider['phoneNumber'],
                      ),
                      const Divider(),
                      const VerticalSpeacing(10.0),
                      ProfileItem(
                        icon: Icons.cake,
                        label: 'Date of Birth',
                        value: provider['dob'],
                      ),
                      const Divider(),
                      const VerticalSpeacing(10.0),
                      ProfileItem(
                        icon: Icons.email,
                        label: 'Email Address',
                        value: provider['email'],
                      ),
                      const Divider(),
                      const VerticalSpeacing(10.0),
                      ProfileItem(
                        icon: Icons.description,
                        label: 'Description',
                        value: provider['bio'] ?? 'null',
                      ),
                      const Divider(),
                      const VerticalSpeacing(10.0),
                      ProfileItem(
                        icon: Icons.euro_outlined,
                        label: 'Hourly Rate',
                        value: '€${provider['hoursrate']}',
                      ),
                      const Divider(),
                      const VerticalSpeacing(10.0),
                      ProfileItem(
                        icon: Icons.star_outline,
                        label: 'Skills',
                        value: provider['Refernce']['skill'],
                      ),
                      const VerticalSpeacing(16.0),
                    ],
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
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
