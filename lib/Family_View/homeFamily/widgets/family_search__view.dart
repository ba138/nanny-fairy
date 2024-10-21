import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Family_View/findJobFamily/provider_detail.dart';
import 'package:nanny_fairy/Family_View/homeFamily/widgets/bookCart_home_widget.dart';
import 'package:nanny_fairy/Repository/family_home_ui_repository.dart';
import 'package:nanny_fairy/ViewModel/family_search_view_model.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:nanny_fairy/res/components/widgets/family_home_ui_enums.dart';
import 'package:nanny_fairy/res/components/widgets/shimmer_effect.dart';
import 'package:provider/provider.dart';
import '../../../Models/family_search_model.dart';
import '../../findJobFamily/job_view_family.dart';

class FamilySearchView extends StatefulWidget {
  const FamilySearchView({super.key});

  @override
  State<FamilySearchView> createState() => _FamilySearchViewState();
}

class _FamilySearchViewState extends State<FamilySearchView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Consumer<FamilyHomeUiRepository>(
            builder: (context, uiState, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Searched Providers',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColor.blackColor,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        uiState.switchToType(FamilyHomeUiEnums.DefaultSection),
                    child: Text(
                      'Clear all',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.6,
            child: Consumer<FamilySearchViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const ShimmerUi();
                } else if (viewModel.users.isEmpty) {
                  return const Center(child: Text('No results found'));
                } else {
                  return ListView.builder(
                    itemCount: viewModel.users.length,
                    itemBuilder: (context, index) {
                      Map<String, Map<String, bool>> testAvailability = {
                        "Morning": {
                          "Monday": true,
                          "Tuesday": true,
                          "Friday": true,
                          "Sunday": false,
                        },
                        "Afternoon": {
                          "Wednesday": true,
                          "Thursday": false,
                        }
                      };
                      // Set<String> testDaysSet = _getDaysSet(testAvailability);

                      final user = viewModel.users[index];
                      final timeData = _getTimeData(user.time);
                      final daysSet = _getDaysSet(user.availability);
                      final dayButtons = _buildDayButtons(daysSet);

                      return BookingCartWidgetHome(
                        primaryButtonColor: AppColor.primaryColor,
                        primaryButtonTxt: 'View',
                        ontapView: () => _navigateToProviderDetails(
                          context,
                          user,
                          dayButtons,
                          timeData,
                        ),
                        profile: user.profile,
                        name: "${user.firstName} ${user.lastName}",
                        degree: user.education,
                        skill: '',
                        hoursRate: user.hoursrate,
                        dayButtons: dayButtons,
                        totalRatings: user.totalRatings,
                        ratings: user.averageRating,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Convert time data to a Map
  Map<String, String> _getTimeData(dynamic time) {
    if (time is Map) {
      final timeMap = time as Map<String, dynamic>;
      return timeMap
          .map((key, value) => MapEntry(key.toString(), value.toString()));
    } else if (time is Time) {
      final timeObject = time as Time;
      return {
        "MorningStart": timeObject.morningStart,
        "MorningEnd": timeObject.morningEnd,
        "AfternoonStart": timeObject.afternoonStart,
        "AfternoonEnd": timeObject.afternoonEnd,
        "EveningStart": timeObject.eveningStart,
        "EveningEnd": timeObject.eveningEnd,
      };
    }
    return _defaultTimeData();
  }

  Map<String, String> _defaultTimeData() {
    return {
      "MorningStart": "N/A",
      "MorningEnd": "N/A",
      "AfternoonStart": "N/A",
      "AfternoonEnd": "N/A",
      "EveningStart": "N/A",
      "EveningEnd": "N/A",
    };
  }

  // Convert availability data to a set of day abbreviations
  Set<String> _getDaysSet(Map<String, Map<String, bool>> availability) {
    final daysSet = <String>{};
    availability.forEach((timeOfDay, daysMap) {
      daysMap.forEach((day, value) {
        if (value) {
          // Assuming 'day' is a full day name; adjust this if it's an abbreviation or different format.
          String dayAbbreviation = day.substring(0, 1).toUpperCase();
          daysSet.add(dayAbbreviation);
        }
      });
    });
    // print('Days set: $daysSet'); // Debugging line
    return daysSet;
  }

  // Create DayButtonFamily widgets from daysSet
  List<Widget> _buildDayButtons(Set<String> daysSet) {
    return daysSet.map((dayAbbreviation) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: DayButtonFamily(day: dayAbbreviation),
      );
    }).toList();
  }

  void _navigateToProviderDetails(
    BuildContext context,
    ProviderSearchModel user,
    List<Widget> dayButtons,
    Map<String, String> timeData,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => ProviderDetails(
          familyId: user.uid,
          profile: user.profile,
          name: "${user.firstName} ${user.lastName}",
          bio: user.bio,
          horseRate: user.hoursrate,
          experience: user.reference.experience,
          degree: user.education,
          dayButtons: dayButtons,
          timeData: timeData,
          ratings: user.averageRating,
          totalRatings: user.totalRatings,
        ),
      ),
    );
  }
}
