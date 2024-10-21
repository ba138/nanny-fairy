import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nanny_fairy/Repository/family_home_ui_repository.dart';
import 'package:nanny_fairy/ViewModel/family_filter_view_model.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/family_home_ui_enums.dart';
import 'package:nanny_fairy/res/components/widgets/family_job_enums.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';

class FamilyJobFilterPopup extends StatefulWidget {
  const FamilyJobFilterPopup({super.key});

  @override
  State<FamilyJobFilterPopup> createState() => _FamilyJobFilterPopupState();
}

class _FamilyJobFilterPopupState extends State<FamilyJobFilterPopup> {
  bool button1 = false;
  bool button2 = false;
  bool button3 = false;
  bool button4 = false;
  bool button5 = true;
  bool button6 = false;
  bool button7 = false;
  bool button8 = true;
  bool button9 = false;
  bool button10 = false;
  bool button11 = true;
  bool button12 = false;
  bool button13 = false;
  bool button14 = true;
  bool button15 = false;
  bool button16 = false;
  bool button17 = false;
  RangeValues _values = const RangeValues(5, 1000);
  List<String> selectedPassions = [];
  List<String> selecteDays = [];
  double minRating = 4;
// Example conversion logic
  Map<String, Map<String, bool>> convertDaysToAvailability(List<String> days) {
    try {
      // Initialize the availability map with empty maps for each time of day
      Map<String, Map<String, bool>> availability = {
        'Morning': {},
        'Afternoon': {},
        'Evening': {},
      };

      // Loop through each day in the list and assign it to each time of day
      for (String day in days) {
        availability['Morning']![day] = true;
        availability['Afternoon']![day] = true;
        availability['Evening']![day] = true;
      }

      return availability;
    } catch (e) {
      // Print the error message and return an empty map
      debugPrint("Error converting days to availability: $e");
      return {
        'Morning': {},
        'Afternoon': {},
        'Evening': {},
      };
    }
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: AppColor.secondaryBgColor,
      child: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Container(
                  height: 116,
                  width: double.infinity,
                  color: AppColor.primaryColor,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: AppColor.whiteColor,
                            ),
                          ),
                          const Text(
                            "Filters",
                            style: TextStyle(
                              fontFamily: 'CenturyGothic',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: AppColor.whiteColor,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {});
                              button1 = false;
                              button2 = false;
                              button3 = false;
                              button4 = false;
                              button5 = false;
                              button6 = false;
                              button7 = false;
                              button8 = false;
                              button9 = false;
                              button10 = false;
                              button11 = false;
                              button12 = false;
                              button13 = false;
                              button14 = false;
                              button15 = false;
                              button16 = false;
                              button17 = false;
                            },
                            child: const Text(
                              "Reset",
                              style: TextStyle(
                                fontFamily: 'CenturyGothic',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: AppColor.whiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VerticalSpeacing(38),
                      Container(
                        height: 75, // Adjust the height as needed
                        width: double.infinity,
                        color: Colors
                            .transparent, // Set the desired background color
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hourly Rate: \$${_values.start.toInt()} - \$${_values.end.toInt()}',
                              style: const TextStyle(
                                fontFamily: 'CenturyGothic',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: AppColor.blackColor,
                              ),
                            ),
                            RangeSlider(
                              activeColor: AppColor.primaryColor,
                              inactiveColor: Colors.grey.shade300,
                              values: _values,
                              min: 5,
                              max: 1000,
                              divisions: 100,
                              labels: RangeLabels(
                                _values.start.round().toString(),
                                _values.end.round().toString(),
                              ),
                              onChanged: (values) {
                                setState(() {
                                  _values = values;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const VerticalSpeacing(16),
                      const Text(
                        "provider Categories",
                        style: TextStyle(
                          fontFamily: 'CenturyGothic',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: AppColor.blackColor,
                        ),
                      ),
                      const VerticalSpeacing(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FilterButton(
                            label: "Cleaning",
                            isSelected: selectedPassions.contains("Cleaning"),
                            onTap: () {
                              if (selectedPassions.contains("Cleaning")) {
                                setState(() {
                                  selectedPassions.remove("Cleaning");
                                });
                              } else {
                                setState(() {
                                  selectedPassions.add("Cleaning");
                                });
                              }
                            },
                          ),
                          FilterButton(
                            label: "Home",
                            isSelected: selectedPassions.contains("Home"),
                            onTap: () {
                              if (selectedPassions.contains("Home")) {
                                setState(() {
                                  selectedPassions.remove("Home");
                                });
                              } else {
                                setState(() {
                                  selectedPassions.add("Home");
                                });
                              }
                            },
                          ),
                          FilterButton(
                            label: "Children Care",
                            isSelected:
                                selectedPassions.contains("Children Care"),
                            onTap: () {
                              if (selectedPassions.contains("Children Care")) {
                                setState(() {
                                  selectedPassions.remove("Children Care");
                                });
                              } else {
                                setState(() {
                                  selectedPassions.add("Children Care");
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const VerticalSpeacing(
                        20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FilterButton(
                            label: "Music Lesson",
                            isSelected:
                                selectedPassions.contains("Music Lesson"),
                            onTap: () {
                              if (selectedPassions.contains("Music Lesson")) {
                                setState(() {
                                  selectedPassions.remove("Music Lesson");
                                });
                              } else {
                                setState(() {
                                  selectedPassions.add("Music Lesson");
                                });
                              }
                            },
                          ),
                          FilterButton(
                            label: "House Setting",
                            isSelected:
                                selectedPassions.contains("House Setting"),
                            onTap: () {
                              if (selectedPassions.contains("House Setting")) {
                                setState(() {
                                  selectedPassions.remove("House Setting");
                                });
                              } else {
                                setState(() {
                                  selectedPassions.add("House Setting");
                                });
                              }
                            },
                          ),
                          FilterButton(
                            label: "Elderly Care",
                            isSelected:
                                selectedPassions.contains("Elderly Care"),
                            onTap: () {
                              if (selectedPassions.contains("Elderly Care")) {
                                setState(() {
                                  selectedPassions.remove("Elderly Care");
                                });
                              } else {
                                setState(() {
                                  selectedPassions.add("Elderly Care");
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const VerticalSpeacing(14),
                      FilterButton(
                        label: "Pet Care",
                        isSelected: selectedPassions.contains("Pet Care"),
                        onTap: () {
                          if (selectedPassions.contains("Pet Care")) {
                            setState(() {
                              selectedPassions.remove("Pet Care");
                            });
                          } else {
                            setState(() {
                              selectedPassions.add("Pet Care");
                            });
                          }
                        },
                      ),
                      const VerticalSpeacing(16),
                      const Text(
                        "Availability",
                        style: TextStyle(
                          fontFamily: 'CenturyGothic',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: AppColor.blackColor,
                        ),
                      ),
                      const VerticalSpeacing(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FilterButton(
                            label: "Mon",
                            isSelected: selecteDays.contains("Monday"),
                            onTap: () {
                              if (selecteDays.contains("Monday")) {
                                setState(() {
                                  selecteDays.remove("Monday");
                                });
                              } else {
                                setState(() {
                                  selecteDays.add("Monday");
                                });
                              }
                            },
                          ),
                          FilterButton(
                            label: "Tue",
                            isSelected: selecteDays.contains("Tuesday"),
                            onTap: () {
                              if (selecteDays.contains("Tuesday")) {
                                setState(() {
                                  selecteDays.remove("Tuesday");
                                });
                              } else {
                                setState(() {
                                  selecteDays.add("Tuesday");
                                });
                              }
                            },
                          ),
                          FilterButton(
                            label: "Wed",
                            isSelected: selecteDays.contains("Wednesday"),
                            onTap: () {
                              if (selecteDays.contains("Wednesday")) {
                                setState(() {
                                  selecteDays.remove("Wednesday");
                                });
                              } else {
                                setState(() {
                                  selecteDays.add("Wednesday");
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const VerticalSpeacing(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FilterButton(
                            label: "Thu",
                            isSelected: selecteDays.contains("Thursday"),
                            onTap: () {
                              if (selecteDays.contains("Thursday")) {
                                setState(() {
                                  selecteDays.remove("Thursday");
                                });
                              } else {
                                setState(() {
                                  selecteDays.add("Thursday");
                                });
                              }
                            },
                          ),
                          FilterButton(
                            label: "Fri",
                            isSelected: selecteDays.contains("Friday"),
                            onTap: () {
                              if (selecteDays.contains("Friday")) {
                                setState(() {
                                  selecteDays.remove("Friday");
                                });
                              } else {
                                setState(() {
                                  selecteDays.add("Friday");
                                });
                              }
                            },
                          ),
                          FilterButton(
                            label: "Sat",
                            isSelected: selecteDays.contains("Saturday"),
                            onTap: () {
                              if (selecteDays.contains("Saturday")) {
                                setState(() {
                                  selecteDays.remove("Saturday");
                                });
                              } else {
                                setState(() {
                                  selecteDays.add("Saturday");
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const VerticalSpeacing(16.0),
                      FilterButton(
                        label: "Sun",
                        isSelected: selecteDays.contains("Sunday"),
                        onTap: () {
                          if (selecteDays.contains("Sunday")) {
                            setState(() {
                              selecteDays.remove("Sunday");
                            });
                          } else {
                            setState(() {
                              selecteDays.add("Sunday");
                            });
                          }
                        },
                      ),
                      const VerticalSpeacing(
                        30,
                      ),
                      const Text(
                        "Rating Star",
                        style: TextStyle(
                          fontFamily: 'CenturyGothic',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: AppColor.blackColor,
                        ),
                      ),
                      const VerticalSpeacing(
                        14,
                      ),
                      RatingBar.builder(
                          initialRating: 4,
                          minRating: 1,
                          allowHalfRating: true,
                          glowColor: Colors.amber,
                          itemCount: 5,
                          itemSize: 30,
                          itemBuilder: (context, _) => const Icon(
                                Icons.star_rate_rounded,
                                color: Colors.amber,
                              ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              minRating = rating;
                            });
                          }),
                      const VerticalSpeacing(
                        50,
                      ),
                      Consumer2<FamilyFilterController, FamilyHomeUiRepository>(
                        builder: (context, viewModel, uiState, child) {
                          return RoundedButton(
                            title: 'Apply Filters',
                            onpress: () {
                              setState(() {
                                isLoading = true;
                              });
                              debugPrint("Button pressed");

                              try {
                                final Map<String, Map<String, bool>>
                                    availabilityMap =
                                    convertDaysToAvailability(selecteDays);
                                debugPrint(
                                    "Availability Map: $availabilityMap");

                                // Call methods on the viewModel to perform the search
                                viewModel.filterProviders(
                                  minRate: _values.start,
                                  maxRate: _values.end,
                                  selectedPassions: selectedPassions,
                                  selectedAvailability: availabilityMap,
                                  minRating: minRating,
                                );
                                debugPrint(
                                    "check the function:${viewModel.filteredProviders}");
                                // Update UI based on the state

                                uiState.switchToJobType(
                                    FamilyJobEnums.FilterSection);
                                Navigator.pop(context);
                              } catch (e) {
                                debugPrint("Error applying filters: $e");
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 40.0),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isSelected ? AppColor.primaryColor : Colors.transparent,
          border: Border.all(color: AppColor.borderColor, width: 1),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'CenturyGothic',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isSelected ? AppColor.whiteColor : AppColor.blackColor,
            ),
          ),
        ),
      ),
    );
  }
}
