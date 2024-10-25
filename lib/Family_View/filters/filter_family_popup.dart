import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nanny_fairy/Family_View/homeFamily/home_view_family.dart';
import 'package:nanny_fairy/Repository/family_home_ui_repository.dart';
import 'package:nanny_fairy/ViewModel/family_distance_view_model.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:provider/provider.dart';
import '../../res/components/colors.dart';
import '../../res/components/widgets/vertical_spacing.dart';

class FilterPopUpFamily extends StatefulWidget {
  const FilterPopUpFamily({super.key});

  @override
  State<FilterPopUpFamily> createState() => _FilterPopUpFamilyState();
}

class _FilterPopUpFamilyState extends State<FilterPopUpFamily> {
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
      backgroundColor: AppColor.creamyColor,
      child: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Container(
                  height: 116,
                  width: double.infinity,
                  color: AppColor.lavenderColor,
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
                              color: AppColor.creamyColor,
                            ),
                          ),
                          const Text(
                            "Filters",
                            style: TextStyle(
                              fontFamily: 'CenturyGothic',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: AppColor.creamyColor,
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
                                color: AppColor.creamyColor,
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
                              activeColor: AppColor.lavenderColor,
                              inactiveColor:
                                  AppColor.lavenderColor.withOpacity(0.2),
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
                            label: "Home sitter",
                            isSelected:
                                selectedPassions.contains("Home sitter"),
                            onTap: () {
                              if (selectedPassions.contains("Home sitter")) {
                                setState(() {
                                  selectedPassions.remove("Home sitter");
                                });
                              } else {
                                setState(() {
                                  selectedPassions.add("Home sitter");
                                });
                              }
                            },
                          ),
                          FilterButton(
                            label: "Animal care",
                            isSelected:
                                selectedPassions.contains("Animal care"),
                            onTap: () {
                              if (selectedPassions.contains("Animal care")) {
                                setState(() {
                                  selectedPassions.remove("Animal care");
                                });
                              } else {
                                setState(() {
                                  selectedPassions.add("Animal care");
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
                            label: "Music lesson",
                            isSelected:
                                selectedPassions.contains("Music lesson"),
                            onTap: () {
                              if (selectedPassions.contains("Music lesson")) {
                                setState(() {
                                  selectedPassions.remove("Music lesson");
                                });
                              } else {
                                setState(() {
                                  selectedPassions.add("Music lesson");
                                });
                              }
                            },
                          ),
                          FilterButton(
                            label: "Homework",
                            isSelected: selectedPassions.contains("Homework"),
                            onTap: () {
                              if (selectedPassions.contains("Homework")) {
                                setState(() {
                                  selectedPassions.remove("Homework");
                                });
                              } else {
                                setState(() {
                                  selectedPassions.add("Homework");
                                });
                              }
                            },
                          ),
                          FilterButton(
                            label: "Elderly care",
                            isSelected:
                                selectedPassions.contains("Elderly care"),
                            onTap: () {
                              if (selectedPassions.contains("Elderly care")) {
                                setState(() {
                                  selectedPassions.remove("Elderly care");
                                });
                              } else {
                                setState(() {
                                  selectedPassions.add("Elderly care");
                                });
                              }
                            },
                          ),
                        ],
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
                      const VerticalSpeacing(20),
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
                      Consumer2<FamilyDistanceViewModel,
                          FamilyHomeUiRepository>(
                        builder: (context, viewModel, uiState, child) {
                          return RoundedButton(
                            buttonColor: AppColor.lavenderColor,
                            titleColor: AppColor.creamyColor,
                            title: 'Apply Filters',
                            onpress: () {
                              // setState(() {
                              //   isLoading = true;
                              // });
                              debugPrint("Button pressed");

                              try {
                                final Map<String, Map<String, bool>>
                                    availabilityMap =
                                    convertDaysToAvailability(selecteDays);
                                debugPrint(
                                    "Availability Map: $availabilityMap");
                                debugPrint("Passions list: $selectedPassions");

                                // Call methods on the viewModel to perform the search
                                viewModel.filterProviders(
                                  context,
                                  familyDistance == null
                                      ? 2
                                      : double.parse(familyDistance!),
                                  _values.start,
                                  minRating,
                                  _values.end,
                                  selectedPassions,
                                  availabilityMap,
                                );

                                // Update UI based on the state

                                // uiState.switchToType(
                                //     FamilyHomeUiEnums.FilterSection);
                              } catch (e) {
                                debugPrint("Error applying filters: $e");
                              } finally {
                                // setState(() {
                                //   isLoading = false;
                                // });
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
          color: isSelected ? AppColor.lavenderColor : Colors.transparent,
          border: Border.all(color: AppColor.borderColor, width: 1),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'CenturyGothic',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isSelected ? AppColor.creamyColor : AppColor.blackColor,
            ),
          ),
        ),
      ),
    );
  }
}
