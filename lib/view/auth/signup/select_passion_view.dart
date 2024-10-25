import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/ViewModel/auth_view_model.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/utils/utils.dart';
import 'package:provider/provider.dart';

class SelectPassionView extends StatefulWidget {
  const SelectPassionView({super.key});

  @override
  State<SelectPassionView> createState() => _SelectPassionViewState();
}

class _SelectPassionViewState extends State<SelectPassionView> {
  final List<String> labels = [
    'Animal care',
    'Home sitter',
    'Elderly care',
    'Homework',
    'Cleaning',
    'Music lesson',
  ];
  final List<String> selectedLabels = [];

  void _handleTap(String label) {
    setState(() {
      if (selectedLabels.contains(label)) {
        selectedLabels.remove(label);
      } else {
        selectedLabels.add(label);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: PreferredSize(
        preferredSize: const Size.square(70),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(
              Icons.west,
              color: AppColor.whiteColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Select your preference',
            style: GoogleFonts.getFont(
              "Poppins",
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: AppColor.whiteColor,
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VerticalSpeacing(26),
              Text(
                'Register as a provider',
                style: GoogleFonts.getFont(
                  "Poppins",
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColor.blackColor,
                  ),
                ),
              ),
              const VerticalSpeacing(10),
              Expanded(
                child: ListView.builder(
                  itemCount: labels.length,
                  itemBuilder: (context, index) {
                    final label = labels[index];
                    final isSelected = selectedLabels.contains(label);
                    return Column(
                      children: [
                        Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColor.primaryColor
                                : AppColor.whiteColor,
                            borderRadius: BorderRadius.circular(6),
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
                          child: GestureDetector(
                            onTap: () => _handleTap(label),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    label,
                                    style: GoogleFonts.getFont(
                                      "Poppins",
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    isSelected ? Icons.check : Icons.add,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColor.blackColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const VerticalSpeacing(16.0),
                      ],
                    );
                  },
                ),
              ),
              RoundedButton(
                title: 'Register',
                onpress: () {
                  if (labels.isNotEmpty) {
                    authViewModel.savePassion(
                        passionList: selectedLabels, context: context);
                  } else {
                    Utils.flushBarErrorMessage(
                        "Please Select the Passion", context);
                  }
                },
              ),
              const VerticalSpeacing(30)
            ],
          ),
        ),
      ),
    );
  }
}
