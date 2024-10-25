import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nanny_fairy/ViewModel/auth_view_model.dart';
import 'package:nanny_fairy/ViewModel/place_view_model.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/custom_text_field.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/utils/utils.dart';
import 'package:nanny_fairy/view/auth/signup/search_Place_screen.dart';
import 'package:nanny_fairy/view/chat/widgets/predicate_tile.dart';
import 'package:provider/provider.dart';
import '../../../res/components/colors.dart';
import '../../../res/components/widgets/rounded_check_box.dart';

class RegisterDetails extends StatefulWidget {
  const RegisterDetails({super.key});

  @override
  State<RegisterDetails> createState() => _RegisterDetailsState();
}

class _RegisterDetailsState extends State<RegisterDetails> {
  bool isChecked = false;
  bool isChecked2 = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController houseNumberController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  void _handleCheckboxChanged(bool? value) {
    setState(() {
      isChecked = value ?? false;
    });
  }

  void _handleCheckboxChanged2(bool? value) {
    setState(() {
      isChecked2 = value ?? false;
    });
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        dobController.text = formattedDate;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    houseNumberController.dispose();
    postCodeController.dispose();
    phoneController.dispose();
    dobController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final distanceViewModel =
        Provider.of<PlaceViewModel>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColor.oceanColor,
      appBar: PreferredSize(
        preferredSize: const Size.square(70),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(
              Icons.west,
              color: AppColor.authCreamColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Welcome to  new user',
            style: GoogleFonts.getFont(
              "Poppins",
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: AppColor.authCreamColor,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColor.authCreamColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VerticalSpeacing(30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: TextFieldCustom(
                            controller: firstNameController,
                            prefixIcon: const Icon(Icons.person_outline),
                            maxLines: 1,
                            hintText: 'Enter Name')),
                    const SizedBox(width: 12),
                    Expanded(
                        child: TextFieldCustom(
                            controller: lastNameController,
                            prefixIcon: const Icon(Icons.person_outline),
                            maxLines: 1,
                            hintText: 'Enter last')),
                  ],
                ),
                const VerticalSpeacing(16),
                Consumer<PlaceViewModel>(builder: (context, viewModel, child) {
                  return InkWell(
                    onTap: () {
                      viewModel.placePredictedList.clear();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => const SearchPlacesScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: AppColor.authCreamColor,
                        border: Border.all(
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: const Color(0xff1B81BC).withOpacity(
                              0.10), // Stroke color with 10% opacity
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
                        child: Row(
                          children: [
                            viewModel.providerAddress == null
                                ? const Text(
                                    'Select Your Address',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(
                                        255,
                                        95,
                                        94,
                                        94,
                                      ),
                                    ),
                                  )
                                : Text(
                                    viewModel.providerAddress!,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromARGB(255, 95, 94, 94)),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                // TextFieldCustom(
                //     controller: addressController,
                //     prefixIcon: const Icon(Icons.location_on_outlined),
                //     maxLines: 1,
                //     hintText: 'Enter Address'),
                const VerticalSpeacing(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: TextFieldCustom(
                            keyboardType: TextInputType.streetAddress,
                            controller: houseNumberController,
                            prefixIcon: const Icon(Icons.home_outlined),
                            maxLines: 1,
                            hintText: 'House Number')),
                    const SizedBox(width: 12),
                    Expanded(
                        child: TextFieldCustom(
                            keyboardType: TextInputType.phone,
                            controller: postCodeController,
                            prefixIcon: const Icon(Icons.lock_outline),
                            maxLines: 1,
                            hintText: 'Post Code')),
                  ],
                ),
                const VerticalSpeacing(16),
                TextFieldCustom(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    prefixIcon: const Icon(Icons.phone),
                    maxLines: 1,
                    hintText: 'Enter telephone number'),
                const VerticalSpeacing(16),
                GestureDetector(
                  onTap: () => selectDate(context),
                  child: AbsorbPointer(
                    absorbing: true,
                    child: TextFieldCustom(
                      controller: dobController,
                      prefixIcon: InkWell(
                        onTap: () => selectDate(context),
                        child: const Icon(Icons.calendar_month_outlined),
                      ),
                      maxLines: 1,
                      hintText: 'Date of birth',
                    ),
                  ),
                ),
                const VerticalSpeacing(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RoundedCheckbox(
                      value: isChecked,
                      onChanged: _handleCheckboxChanged,
                      activeColor: AppColor.oceanColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'I agree with the terms and condition',
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
                const VerticalSpeacing(10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RoundedCheckbox(
                      value: isChecked2,
                      onChanged: _handleCheckboxChanged2,
                      activeColor: AppColor.oceanColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'I agree with free privacy policy',
                      style: GoogleFonts.getFont(
                        "Poppins",
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors
                              .black, // Use AppColor.blackColor if defined
                        ),
                      ),
                    ),
                  ],
                ),
                const VerticalSpeacing(24.0),
                RoundedButton(
                    title: 'Register',
                    onpress: () {
                      if (isChecked && isChecked2) {
                        authViewModel.saveDetails(
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            address: distanceViewModel.providerAddress!,
                            houseNumber: houseNumberController.text,
                            postCode: postCodeController.text,
                            phoneNumber: phoneController.text,
                            dob: dobController.text,
                            context: context);
                      } else {
                        Utils.flushBarErrorMessage(
                            "Please select terms and Privacy Policy", context);
                      }
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
