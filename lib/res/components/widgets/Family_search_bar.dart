import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Family_View/homeFamily/home_view_family.dart';
import 'package:nanny_fairy/Repository/family_home_ui_repository.dart';
import 'package:nanny_fairy/ViewModel/family_distance_view_model.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:provider/provider.dart';

class FamilySearchBarProvider extends StatefulWidget {
  const FamilySearchBarProvider({super.key, required this.onTapFilter});
  final Function() onTapFilter;

  @override
  State<FamilySearchBarProvider> createState() =>
      _FamilySearchBarProviderState();
}

class _FamilySearchBarProviderState extends State<FamilySearchBarProvider> {
  String selectedKM = 'All';
  final List<String> kM = ['All', "2", '4', '8', '12'];

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
    final viewModel = context.read<FamilyDistanceViewModel>();
    final searchText = searchController.text;

    // Debugging output
    print('Search text: "$searchText"');

    if (searchText.isNotEmpty) {
      print('Filtering by passions: $searchText');
      viewModel.filterProvidersByPassions(searchText, context);
    } else if (selectedKM == "All") {
      viewModel.fetchProviderDataFromFiebase();
    } else {
      print('Filtering by distance: $selectedKM km');
      viewModel.filterProvidersByDistance(
          familyDistance == null
              ? double.parse(selectedKM)
              : double.parse(familyDistance!),
          context);
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
                      child: Consumer<FamilyDistanceViewModel>(
                        builder: (context, viewModel, child) {
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
                        value: familyDistance ?? selectedKM,
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
                              familyDistance = selectedKM;
                            });
                            try {
                              // Call the method to filter providers by distance
                              if (selectedKM != "All") {
                                await distanceViewModel
                                    .filterProvidersByDistance(
                                        double.parse(selectedKM), context);
                              } else {
                                distanceViewModel
                                    .fetchProviderDataFromFiebase();
                              }

                              // uiState.switchToType(
                              //   FamilyHomeUiEnums.DistanceSection,
                              // );
                            } catch (e) {
                              debugPrint("this is error in dropdown:$e");
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
