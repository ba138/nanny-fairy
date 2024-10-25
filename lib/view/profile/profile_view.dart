import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/ViewModel/get_provider_info_view_model.dart';
import 'package:nanny_fairy/utils/routes/routes_name.dart';
import 'package:nanny_fairy/view/profile/widgets/profile_widgets.dart';
import 'package:provider/provider.dart';
import '../../res/components/colors.dart';
import '../../res/components/widgets/vertical_spacing.dart';
import '../rating/rating.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final double tHeight = 150.0;
  final double top = 130.0;
  String defaultProfile =
      'https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg';
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
    return Scaffold(
      backgroundColor: AppColor.creamyColor,
      appBar: AppBar(
        backgroundColor: AppColor.lavenderColor,
        elevation: 0.0,
        title: const Text(
          'Profile ',
          style: TextStyle(
            fontFamily: 'CenturyGothic',
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: AppColor.creamyColor,
          ),
        ),
        centerTitle: true,
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.transparent,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                _buildCoverBar(),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 24.0, right: 24.0),
                  child: _buildProfile(context),
                ),
              ],
            ),
            const VerticalSpeacing(16.0),
            _buildProfileFeatures(),
          ],
        ),
      ),
    );
  }

  _buildCoverBar() {
    return Container(
      height: tHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        color: AppColor.lavenderColor,
      ),
    );
  }

  _buildProfile(BuildContext context) {
    final getProviderInfo = Provider.of<GetProviderInfoViewModel>(context);
    return Column(
      children: [
        FutureBuilder<Map<dynamic, dynamic>>(
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
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    foregroundImage: NetworkImage(provider['profile'] ??
                        'https://play-lh.googleusercontent.com/jInS55DYPnTZq8GpylyLmK2L2cDmUoahVacfN_Js_TsOkBEoizKmAl5-p8iFeLiNjtE=w526-h296-rw'),
                    backgroundImage: const NetworkImage(
                        'https://play-lh.googleusercontent.com/jInS55DYPnTZq8GpylyLmK2L2cDmUoahVacfN_Js_TsOkBEoizKmAl5-p8iFeLiNjtE=w526-h296-rw'),
                  ),
                  const VerticalSpeacing(16),
                  Text(
                    "${provider['firstName']} ${provider['lastName']}",
                    style: GoogleFonts.getFont(
                      "Poppins",
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.creamyColor,
                      ),
                    ),
                  ),
                ],
              ));
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ],
    );
  }

  _buildProfileFeatures() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: AppColor.creamyColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          strokeAlign: BorderSide.strokeAlignCenter,
          color: const Color(0xff1B81BC)
              .withOpacity(0.10), // Stroke color with 10% opacity
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1B81BC)
                .withOpacity(0.1), // Drop shadow color with 4% opacity
            blurRadius: 2,
            offset: const Offset(1, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              children: [
                ProfileWidgets(
                  ontap: () {
                    Navigator.pushNamed(context, RoutesName.myProfile);
                  },
                  tColor: const Color(0xff40C269),
                  bColor: const Color(0xffCDFF9D),
                  icon: Icons.person_outline,
                  trIcon: Icons.arrow_forward_ios,
                  title: 'My Profile',
                ),
                const Divider(),
                ProfileWidgets(
                  ontap: () {
                    Navigator.pushNamed(context, RoutesName.notificationsView);
                  },
                  tColor: const Color(0xff46C5CA),
                  bColor: const Color(0xff6DF5FC),
                  icon: Icons.notifications_outlined,
                  trIcon: Icons.arrow_forward_ios,
                  title: 'Notifications',
                ),
                const Divider(),
                ProfileWidgets(
                    ontap: () {
                      Navigator.pushNamed(context, RoutesName.settingsFamily);
                    },
                    tColor: const Color(0xffA24ABF),
                    bColor: const Color(0xffDF9EF5),
                    icon: Icons.settings_outlined,
                    trIcon: Icons.arrow_forward_ios,
                    title: 'Settings'),
                const Divider(),
                ProfileWidgets(
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => const TotalRatingScreen(),
                      ),
                    );
                  },
                  tColor: const Color(0xffEC4091),
                  bColor: const Color(0xffFF9CCB),
                  icon: Icons.star,
                  trIcon: Icons.arrow_forward_ios,
                  title: 'Ratings',
                ),
                const Divider(),
                ProfileWidgets(
                  ontap: () async {
                    // Log out the current user
                    await FirebaseAuth.instance.signOut();
                    // Navigate to the login view and remove all previous routes
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RoutesName.loginOrSignup,
                      (Route<dynamic> route) => false,
                    );
                  },
                  tColor: const Color(0xffEC4091),
                  bColor: const Color(0xffFF9CCB),
                  icon: Icons.logout_outlined,
                  trIcon: Icons.arrow_forward_ios,
                  title: 'Log Out',
                ),
                const Divider(),
                const VerticalSpeacing(60.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
