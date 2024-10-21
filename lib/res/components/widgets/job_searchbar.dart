import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Repository/home_ui_repostory.dart';
import 'package:nanny_fairy/ViewModel/family_distance_view_model.dart';
import 'package:nanny_fairy/ViewModel/provider_distance_view_model.dart';
import 'package:nanny_fairy/ViewModel/search_view_model.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:nanny_fairy/res/components/widgets/job_enum.dart';
import 'package:nanny_fairy/res/components/widgets/ui_enums.dart';
import 'package:provider/provider.dart';

class JobSearchbar extends StatefulWidget {
  const JobSearchbar({super.key, required this.onTapFilter});
  final Function() onTapFilter;

  @override
  State<JobSearchbar> createState() => _JobSearchBarState();
}

class _JobSearchBarState extends State<JobSearchbar> {
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
                      child:
                          Consumer2<SearchViewModel, HomeUiSwithchRepository>(
                        builder: (context, viewModel, uiState, child) {
                          searchController.addListener(() {
                            if (searchController.text.isNotEmpty) {
                              viewModel
                                  .searchUsersByPassion(searchController.text);
                              uiState.switchToJobType(JobUIType.SearchSection);
                            } else {
                              uiState.switchToJobType(JobUIType.DefaultSection);
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
                  child: Consumer2<HomeUiSwithchRepository,
                      FamilyDistanceViewModel>(
                    builder: (context, uiState, distanceRepo, child) {
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
                                await distanceRepo.filterProvidersByDistance(
                                    double.parse(selectedKM), context);
                                uiState
                                    .switchToJobType(JobUIType.DistanceSection);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Failed to fetch nearby providers.')),
                                );
                              }
                            }
                          },
                          items:
                              kM.map<DropdownMenuItem<String>>((String value) {
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
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
