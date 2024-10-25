import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/FamilyController/family_auth_controller.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';

class SelectPassionFamilyView extends StatefulWidget {
  const SelectPassionFamilyView({
    super.key,
  });

  @override
  State<SelectPassionFamilyView> createState() =>
      _SelectPassionFamilyViewState();
}

class _SelectPassionFamilyViewState extends State<SelectPassionFamilyView> {
  final List<String> labels = [
    'Kinderoppas',
    'Thuiszorg',
    'Schoonmaakdiensten',
    'Tuinonderhoud',
    'Huisoppas',
    'Dierenoppas',
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
    final authViewModelFamily = Provider.of<FamilyAuthController>(context);
    return Scaffold(
      backgroundColor: AppColor.oceanColor,
      appBar: PreferredSize(
        preferredSize: const Size.square(50),
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
            'Selecteer de Diensten die Je Biedt',
            style: GoogleFonts.getFont(
              "Poppins",
              textStyle: const TextStyle(
                fontSize: 16,
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
          color: AppColor.authCreamColor,
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
                'Kies de Diensten die Je Aanbiedt',
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
                                ? AppColor.oceanColor
                                : AppColor.authCreamColor,
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
                title: 'Opslaan',
                onpress: () {
                  if (labels.isNotEmpty) {
                    authViewModelFamily.savePassion(
                        passionList: selectedLabels, context: context);
                  } else {
                    Utils.flushBarErrorMessage(
                        "Selecteer de diensten", context);
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
