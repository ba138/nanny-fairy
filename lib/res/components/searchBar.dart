import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Repository/home_ui_repostory.dart';
import 'package:nanny_fairy/ViewModel/provider_distance_view_model.dart';
import 'package:nanny_fairy/view/filter/filter_popup.dart';
import 'package:nanny_fairy/view/home/home_view.dart';

import 'package:provider/provider.dart';
import 'colors.dart';

class SearchBarProvider extends StatefulWidget {
  const SearchBarProvider({
    super.key,
  });

  @override
  State<SearchBarProvider> createState() => _SearchBarProviderState();
}

class _SearchBarProviderState extends State<SearchBarProvider> {
  String selectedKM = 'All';
  final List<String> kM = ["All", '2', '4', '8', '12'];

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
    final viewModel = context.read<ProviderDistanceViewModel>();
    final searchText = searchController.text;

    if (searchText.isNotEmpty) {
      viewModel.searchFamiliesByPassion(
          searchText, double.parse(selectedKM), context);
    } else if (selectedKM == "All") {
      viewModel.fetchFamiliesFromFirebaseData();
    } else {
      viewModel.distanceFilteredFamilies.clear();
      viewModel.filterFamiliesByDistance(double.parse(selectedKM), context);
    }
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
              color: AppColor.creamyColor,
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
                      child: Consumer2<ProviderDistanceViewModel,
                          HomeUiSwithchRepository>(
                        builder: (context, viewModel, uiState, child) {
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
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => FilterPopUp(
                          maxDistance: selectedKM,
                        )));
          },
          child: Container(
            height: 50,
            width: 56,
            decoration: BoxDecoration(
              color: AppColor.creamyColor,
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
                color: AppColor.lavenderColor,
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
              color: AppColor.creamyColor,
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
                      ProviderDistanceViewModel>(
                    builder: (context, uiState, distanceRepo, child) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: providerDistance ?? selectedKM,
                          icon: const SizedBox.shrink(),
                          dropdownColor: AppColor.creamyColor,
                          style: GoogleFonts.getFont(
                            "Poppins",
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColor.lavenderColor,
                            ),
                          ),
                          onChanged: (String? newValue) async {
                            if (newValue != null) {
                              setState(() {
                                selectedKM = newValue;
                                providerDistance = newValue;
                              });

                              try {
                                if (selectedKM != "All") {
                                  await distanceRepo.filterFamiliesByDistance(
                                      providerDistance == null
                                          ? double.parse(selectedKM)
                                          : double.parse(providerDistance!),
                                      context);
                                } else {
                                  distanceRepo.fetchFamiliesFromFirebaseData();
                                }
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
