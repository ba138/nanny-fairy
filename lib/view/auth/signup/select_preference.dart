import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/ViewModel/auth_view_model.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/custom_text_field.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/utils/utils.dart';
import 'package:provider/provider.dart';
import '../../../res/components/colors.dart';

class SelectPreference extends StatefulWidget {
  const SelectPreference({super.key});

  @override
  State<SelectPreference> createState() => _SelectPreferenceState();
}

class _SelectPreferenceState extends State<SelectPreference> {
  TextEditingController experinceController = TextEditingController();
  TextEditingController jobController = TextEditingController();

  TextEditingController landController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  String _btn2SelectedVal = "Kinderoppas";
  static const menuItems = <String>[
    'Kinderoppas',
    'Thuiszorg',
    'Schoonmaakdiensten',
    'Tuinonderhoud',
    'Huisoppas',
    'Dierenoppas',
  ];
  final List<DropdownMenuItem<String>> _dropDownMenuItems = menuItems
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(color: AppColor.blackColor),
          ),
        ),
      )
      .toList();
  @override
  void dispose() {
    super.dispose();
    experinceController.dispose();
    jobController.dispose();
    landController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: AppColor.authCreamColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.west,
            color: AppColor.blackColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Referentie',
          style: GoogleFonts.getFont(
            "Poppins",
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: AppColor.blackColor,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            children: [
              const VerticalSpeacing(30.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldCustom(
                    controller: experinceController,
                    prefixIcon: const Icon(Icons.school_outlined),
                    maxLines: 1,
                    hintText: 'Vul uw ervaring in',
                  ),
                  const VerticalSpeacing(16.0),
                  Text(
                    'Referentie',
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
                  Text(
                    'Naam',
                    style: GoogleFonts.getFont(
                      "Poppins",
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.blackColor,
                      ),
                    ),
                  ),
                  TextFieldCustom(
                    controller: jobController,
                    maxLines: 1,
                    hintText: 'Functie',
                  ),
                  Text(
                    'Thuiszorg',
                    style: GoogleFonts.getFont(
                      "Poppins",
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.blackColor,
                      ),
                    ),
                  ),
                  const VerticalSpeacing(10),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.authCreamColor,
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
                      padding: const EdgeInsets.only(left: 8, right: 8.0),
                      child: DropdownButton(
                        dropdownColor: AppColor.authCreamColor,
                        isExpanded: true,
                        icon: const Icon(Icons.expand_more),
                        underline: const SizedBox(),
                        value: _btn2SelectedVal,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _btn2SelectedVal = newValue;
                            });
                          }
                        },
                        items: _dropDownMenuItems,
                      ),
                    ),
                  ),
                  const VerticalSpeacing(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: TextFieldCustom(
                        keyboardType: TextInputType.phone,
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 10),
                            Text(
                              '+31',
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
                        maxLines: 1,
                        controller: landController,
                        hintText: 'Telefoonnummer',
                      )),
                      const SizedBox(width: 10.0),
                      Expanded(
                          child: TextFieldCustom(
                        keyboardType: TextInputType.phone,
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 10),
                            Text(
                              '+31',
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
                        maxLines: 1,
                        controller: phoneController,
                        hintText: 'Mobiel nummer',
                      )),
                    ],
                  ),
                  const VerticalSpeacing(60.0),
                  RoundedButton(
                      title: 'Opslaan',
                      onpress: () {
                        if (experinceController.text.isNotEmpty ||
                            jobController.text.isNotEmpty ||
                            landController.text.isNotEmpty ||
                            phoneController.text.isNotEmpty) {
                          authViewModel.savePrefernce(
                            context: context,
                            experince: experinceController.text,
                            job: jobController.text,
                            skill: _btn2SelectedVal,
                            land: landController.text,
                            phoneNumber: phoneController.text,
                          );
                        } else {
                          Utils.flushBarErrorMessage(
                              'Vul alle velden in', context);
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
