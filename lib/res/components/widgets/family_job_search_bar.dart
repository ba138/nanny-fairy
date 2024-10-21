import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Repository/family_home_ui_repository.dart';
import 'package:nanny_fairy/ViewModel/family_distance_view_model.dart';
import 'package:nanny_fairy/ViewModel/family_search_view_model.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:nanny_fairy/res/components/widgets/family_job_enums.dart';
import 'package:provider/provider.dart';

import '../../../Repository/family_distance_repository.dart';

class FamilySearchBar extends StatefulWidget {
  const FamilySearchBar({super.key, required this.onTapFilter});
  final Function() onTapFilter;

  @override
  State<FamilySearchBar> createState() => _FamilySearchBarState();
}

class _FamilySearchBarState extends State<FamilySearchBar> {
  String selectedKM = '2';
  final List<String> kM = [
    '2',
    '4',
    '8',
    '12',
  ];

  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _dropdownFocusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!kM.contains(selectedKM)) {
      selectedKM = kM.first;
    }
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _dropdownFocusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // The logic will be moved to the Consumer inside the build method
  }

  @override
  Widget build(BuildContext context) {
    FamilyDistanceRepository distanceRepository = FamilyDistanceRepository();

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(_searchFocusNode);
          },
          child: Container(
            height: 50,
            width: 200,
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Focus(
                      focusNode: _searchFocusNode,
                      child: Consumer2<FamilySearchViewModel,
                          FamilyHomeUiRepository>(
                        builder: (context, viewModel, uiState, child) {
                          searchController.addListener(() {
                            if (searchController.text.isNotEmpty) {
                              viewModel
                                  .searchUsersByPassion(searchController.text);
                              uiState.switchToJobType(
                                  FamilyJobEnums.SearchSection);
                            } else {
                              uiState.switchToJobType(
                                  FamilyJobEnums.DefaultSection);
                            }
                          });
                          return TextFormField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search Here',
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColor.blackColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 5.0),
        GestureDetector(
          onTap: widget.onTapFilter,
          child: Container(
            height: 50,
            width: 56,
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
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
            child: const Center(
              child: Icon(
                Icons.filter_alt_outlined,
                color: AppColor.primaryColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 5.0),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(_dropdownFocusNode);
          },
          child: Container(
            height: 50,
            width: 56,
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
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
            child: Center(
              child: Focus(
                focusNode: _dropdownFocusNode,
                child:
                    Consumer2<FamilyHomeUiRepository, FamilyDistanceViewModel>(
                  builder: (context, uiState, distanceViewModel, child) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedKM,
                        icon: const SizedBox.shrink(),
                        style: GoogleFonts.getFont(
                          "Poppins",
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColor.primaryColor,
                          ),
                        ),
                        onChanged: (String? newValue) async {
                          if (newValue != null) {
                            setState(() {
                              selectedKM = newValue;
                            });
                            try {
                              // Call the method to filter providers by distance
                              await distanceViewModel.filterProvidersByDistance(
                                double.parse(selectedKM),
                                context,
                              );

                              uiState.switchToJobType(
                                  FamilyJobEnums.DistanceFilter);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Failed to fetch nearby providers.'),
                                ),
                              );
                            }
                          }
                        },
                        items: kM.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  value.split(" ")[0],
                                  style: GoogleFonts.getFont(
                                    "Poppins",
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.blackColor,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "KM",
                                      style: GoogleFonts.getFont(
                                        "Poppins",
                                        textStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.expand_more_outlined,
                                      color: AppColor.blackColor,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
