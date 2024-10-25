import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Repository/home_ui_repostory.dart';
import 'package:nanny_fairy/ViewModel/provider_distance_view_model.dart';
import 'package:nanny_fairy/ViewModel/provider_home_view_model.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:nanny_fairy/res/components/searchbar.dart';
import 'package:nanny_fairy/res/components/widgets/ui_enums.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/view/home/widgets/home_default_view.dart';
import 'package:nanny_fairy/view/home/widgets/home_filter_view.dart';
import 'package:nanny_fairy/view/home/widgets/home_search_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

String? providerDistance;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // Fetch users when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<ProviderHomeViewModel>(context);

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
                    future: homeViewModel.getCurrentUser(),
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
                        Map<dynamic, dynamic> provider =
                            snapshot.data as Map<dynamic, dynamic>;
                        return Center(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 40,
                              foregroundImage: NetworkImage(provider[
                                      'profile'] ??
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
                              "${provider['firstName'] ?? 'Name'} ${provider['lastName'] ?? 'Name'}",
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
                  left: (MediaQuery.of(context).size.width - 320) / 2,
                  child: const SearchBarProvider(),
                ),
              ],
            ),
            const VerticalSpeacing(20.0),
            // const HomeDefaultView(),
            // const HomeSearchView(),
            Consumer<HomeUiSwithchRepository>(
              builder: (context, uiState, _) {
                Widget selectedWidget;

                switch (uiState.selectedType) {
                  case UIType.SearchSection:
                    selectedWidget = const HomeSearchView();
                    break;
                  case UIType.DefaultSection:
                    selectedWidget = const HomeDefaultView();
                    break;
                  // case UIType.DistanceSection:
                  //   selectedWidget = const HomeDistanceView();
                  //   break;

                  case UIType.FilterSection:
                    selectedWidget = const HomeFilterView();
                    break;
                }
                return selectedWidget;
              },
            ),
            // const HomeFilterView(),
          ],
        ),
      ),
    );
  }
}
