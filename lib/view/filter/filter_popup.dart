// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import 'package:nanny_fairy/ViewModel/provider_distance_view_model.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/utils/utils.dart';

import '../../res/components/colors.dart';
import '../../res/components/widgets/vertical_spacing.dart';

class FilterPopUp extends StatefulWidget {
  final String maxDistance;
  const FilterPopUp({
    super.key,
    required this.maxDistance,
  });

  @override
  State<FilterPopUp> createState() => _FilterPopUpState();
}

class _FilterPopUpState extends State<FilterPopUp> {
  final Map<String, bool> filters = {
    "Cleaning": false,
    "Home": false,
    "Children Care": false,
    "Music Lesson": false,
    "House Setting": false,
    "Elderly Care": false,
    "Pet Care": false,
    // Add more filters as needed
  };

  List<String> query = [];

  void _updateQuery() {
    setState(() {
      query = filters.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();
    });
  }

  double totalRating = 2;
  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: AppColor.secondaryBgColor,
      child: ListView(
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
                        setState(() {
                          filters.updateAll((key, value) => false);
                          _updateQuery();
                        });
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
                const VerticalSpeacing(16),
                const Text(
                  "Provider Categories",
                  style: TextStyle(
                    fontFamily: 'CenturyGothic',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColor.blackColor,
                  ),
                ),
                const VerticalSpeacing(20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: filters.entries.map((entry) {
                    return FilterButton(
                      label: entry.key,
                      isSelected: entry.value,
                      onTap: () {
                        debugPrint("this is key:${entry.key}");
                        debugPrint("this is list:$query");
                        setState(() {
                          filters[entry.key] =
                              !filters[entry.key]!; // Toggle filter state
                          _updateQuery(); // Update the query list based on new state
                        });
                      },
                    );
                  }).toList(),
                ),
                const VerticalSpeacing(14),
                RatingBar.builder(
                  initialRating: 2,
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
                    totalRating = rating;
                  },
                ),
                const VerticalSpeacing(50),
                Consumer<ProviderDistanceViewModel>(
                  builder: (context, filteredViewModel, child) {
                    return RoundedButton(
                      title: 'Apply Filters',
                      onpress: () {
                        if (query.isNotEmpty) {
                          filteredViewModel.filteredFamiliesByMultipleQueries(
                              double.parse(widget.maxDistance),
                              context,
                              query,
                              totalRating);

                          // Navigator.pop(context);

                          // uiState.switchToType(UIType
                          //     .FilterSection); // Switch to FilterSection after applying filters
                        } else {
                          Utils.flushBarErrorMessage(
                              "Please select the filters", context);
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
