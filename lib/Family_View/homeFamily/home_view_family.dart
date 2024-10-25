import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/FamilyController/get_family_info_controller.dart';
import 'package:nanny_fairy/Family_View/homeFamily/widgets/family_default_view.dart';
import 'package:nanny_fairy/Repository/family_home_ui_repository.dart';
import 'package:nanny_fairy/ViewModel/family_distance_view_model.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:nanny_fairy/res/components/widgets/family_search_bar.dart';
import 'package:nanny_fairy/res/components/widgets/family_home_ui_enums.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/routes/routes_name.dart';

String? familyDistance;

class HomeViewFamily extends StatefulWidget {
  const HomeViewFamily({super.key});

  @override
  State<HomeViewFamily> createState() => _HomeViewFamilyState();
}

class _HomeViewFamilyState extends State<HomeViewFamily> {
  final bool _hasFetchedProviders = false;

  @override
  void initState() {
    super.initState();

    // Adding a 2-second delay before executing the code
    Future.delayed(const Duration(seconds: 2), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_hasFetchedProviders) {
          // Provider.of<GetFamilyInfoController>(context, listen: false)
          //     .getFamilyInfo();

          // Provider.of<FamilyDistanceViewModel>(context, listen: false)
          //     .filterProvidersByDistance(
          //         familyDistance == null ? 2 : double.parse(familyDistance!),
          //         context)
          //     .then((_) {
          //   if (mounted) {
          //     setState(() {
          //       _hasFetchedProviders = true;
          //     });
          //   }
          // }).catchError((e) {
          //   debugPrint("Error filtering providers: $e");
          // });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final familyHomeView = Provider.of<GetFamilyInfoController>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 179,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: FutureBuilder<Map<dynamic, dynamic>>(
                    future: familyHomeView.getFamilyInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: ListTile(
                              leading: const CircleAvatar(
                                radius: 40,
                                backgroundImage: const NetworkImage(
                                    'https://play-lh.googleusercontent.com/jInS55DYPnTZq8GpylyLmK2L2cDmUoahVacfN_Js_TsOkBEoizKmAl5-p8iFeLiNjtE=w526-h296-rw'),
                              ),
                              title: Text(
                                'WellCome',
                                style: GoogleFonts.getFont(
                                  "Poppins",
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.whiteColor,
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                "Name",
                                style: GoogleFonts.getFont(
                                  "Poppins",
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        Map<dynamic, dynamic> family =
                            snapshot.data as Map<dynamic, dynamic>;
                        return Center(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 40,
                              foregroundImage: NetworkImage(family['profile'] ??
                                  'https://play-lh.googleusercontent.com/jInS55DYPnTZq8GpylyLmK2L2cDmUoahVacfN_Js_TsOkBEoizKmAl5-p8iFeLiNjtE=w526-h296-rw'),
                              backgroundImage: const NetworkImage(
                                  'https://play-lh.googleusercontent.com/jInS55DYPnTZq8GpylyLmK2L2cDmUoahVacfN_Js_TsOkBEoizKmAl5-p8iFeLiNjtE=w526-h296-rw'),
                            ),
                            title: Text(
                              'WellCome',
                              style: GoogleFonts.getFont(
                                "Poppins",
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.whiteColor,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              "${family['firstName'] ?? 'Name'} ${family['lastName'] ?? 'Name'}",
                              style: GoogleFonts.getFont(
                                "Poppins",
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.whiteColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const Center(child: Text('No data available'));
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 135,
                  left: (MediaQuery.of(context).size.width - 320) /
                      2, // Center horizontally
                  child: FamilySearchBarProvider(
                    onTapFilter: () {
                      Navigator.pushNamed(
                          context, RoutesName.filterPopUpFamily);
                    },
                  ),
                ),
              ],
            ),
            const VerticalSpeacing(20.0),
            Consumer2<FamilyHomeUiRepository, FamilyDistanceViewModel>(
              builder: (context, uiState, familyDistanceViewModel, _) {
                Widget selectedWidget;

                switch (uiState.selectedType) {
                  case FamilyHomeUiEnums.DefaultSection:
                    selectedWidget = const FamilyDefaultView();
                    break;

                  // case FamilyHomeUiEnums.DistanceSection:
                  //   selectedWidget = const FamilyDistanceFilterView();
                  //   break;
                }

                return selectedWidget;
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up any resources if necessary
    super.dispose();
  }
}

class DayButtonFamily extends StatefulWidget {
  final String day;

  const DayButtonFamily({
    super.key,
    required this.day,
  });

  @override
  _DayButtonFamilyState createState() => _DayButtonFamilyState();
}

class _DayButtonFamilyState extends State<DayButtonFamily> {
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
          widget.day,
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
