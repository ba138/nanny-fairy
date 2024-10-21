import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/custom_text_field.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/utils/utils.dart';
import 'package:nanny_fairy/view/profile/my_profile.dart';
import '../../res/components/colors.dart';

class EditProfile extends StatefulWidget {
  final Map<dynamic, dynamic> providerData;

  const EditProfile({required this.providerData, super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController hourlyRateController;
  late TextEditingController phoneController;
  late TextEditingController dobController;
  late TextEditingController emailController;
  late TextEditingController descriptionController;
  late TextEditingController skillController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
        text: widget.providerData['firstName'] +
            ' ' +
            widget.providerData['lastName']);
    addressController =
        TextEditingController(text: widget.providerData['address']);
    hourlyRateController = TextEditingController(
        text: widget.providerData['hoursrate'].toString());
    phoneController =
        TextEditingController(text: widget.providerData['phoneNumber']);
    dobController = TextEditingController(text: widget.providerData['dob']);
    emailController = TextEditingController(text: widget.providerData['email']);
    descriptionController =
        TextEditingController(text: widget.providerData['bio']);
    skillController =
        TextEditingController(text: widget.providerData['Refernce']['skill']);
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    hourlyRateController.dispose();
    phoneController.dispose();
    dobController.dispose();
    emailController.dispose();
    descriptionController.dispose();
    skillController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    try {
      final DatabaseReference providerRef =
          FirebaseDatabase.instance.ref().child('Providers');

      final userDocument =
          providerRef.child(FirebaseAuth.instance.currentUser!.uid);

      // Prepare the data to be updated
      Map<String, dynamic> updatedData = {
        'firstName': nameController.text.split(' ')[0],
        'lastName': nameController.text.split(' ').sublist(1).join(' '),
        'address': addressController.text,
        'hoursrate': hourlyRateController.text,
        'phoneNumber': phoneController.text,
        'dob': dobController.text,
        'email': emailController.text,
        'bio': descriptionController.text,
      };
      Map<String, dynamic> updateSkill = {
        'skill': skillController.text,
      };
      // Update the user's profile information in the database
      await userDocument.update(updatedData);
      await userDocument.child('Refernce').update(updateSkill);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyProfile()));
    } catch (e) {
      Utils.flushBarErrorMessage('Failed to update profile', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lavenderColor,
      appBar: PreferredSize(
        preferredSize: const Size.square(70),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.west,
                color: AppColor.creamyColor,
              )),
          title: Text(
            'Edit Profile',
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColor.creamyColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, right: 16.0, left: 16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                TextFieldCustom(
                    controller: nameController,
                    prefixIcon: const Icon(Icons.person_outline),
                    maxLines: 1,
                    hintText: 'Name'),
                const VerticalSpeacing(16.0),
                TextFieldCustom(
                    controller: addressController,
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    maxLines: 1,
                    hintText: 'Address'),
                const VerticalSpeacing(16.0),
                TextFieldCustom(
                    controller: hourlyRateController,
                    prefixIcon: const Icon(Icons.access_time_outlined),
                    maxLines: 1,
                    hintText: 'Enter hourly rate...'),
                const VerticalSpeacing(16.0),
                TextFieldCustom(
                    controller: phoneController,
                    prefixIcon: const Icon(Icons.phone),
                    maxLines: 1,
                    hintText: 'Telephone Number'),
                const VerticalSpeacing(16.0),
                TextFieldCustom(
                    controller: dobController,
                    prefixIcon: const Icon(Icons.calendar_month_outlined),
                    maxLines: 1,
                    hintText: 'Date of Birth'),
                const VerticalSpeacing(16.0),
                TextFieldCustom(
                    controller: emailController,
                    prefixIcon: const Icon(Icons.mail_outline),
                    maxLines: 1,
                    hintText: 'Email Address'),
                const VerticalSpeacing(16.0),
                TextFieldCustom(
                    controller: descriptionController,
                    prefixIcon: const Icon(Icons.border_color_outlined),
                    maxLines: 1,
                    hintText: 'Description'),
                const VerticalSpeacing(16.0),
                TextFieldCustom(
                    controller: skillController,
                    prefixIcon: const Icon(Icons.inventory_outlined),
                    maxLines: 1,
                    hintText: 'Skills...'),
                const VerticalSpeacing(16.0),
                RoundedButton(
                    buttonColor: AppColor.lavenderColor,
                    titleColor: AppColor.creamyColor,
                    title: 'Update Profile',
                    onpress: () {
                      _updateProfile();
                    }),
                const VerticalSpeacing(30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
