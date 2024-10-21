import 'package:flutter/material.dart';
import 'package:nanny_fairy/ViewModel/place_view_model.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:nanny_fairy/view/chat/widgets/predicate_tile.dart';
import 'package:provider/provider.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({super.key});

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  @override
  Widget build(BuildContext context) {
    final distanceViewModel =
        Provider.of<PlaceViewModel>(context, listen: false);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.creamyColor,
          centerTitle: true,
          title: const Text(
            'Set Address',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 16,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  height: 46,
                  decoration: const BoxDecoration(
                    color: AppColor.creamyColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        spreadRadius: 0.5,
                        offset: Offset(
                          0.7,
                          0.7,
                        ),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      distanceViewModel.findPlaceAutoCompleteSearch(value);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search Address Here',
                      filled: true,
                      fillColor: AppColor.creamyColor,
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(left: 11, top: 8, bottom: 8),
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Consumer<PlaceViewModel>(builder: (context, viewModel, child) {
                return (viewModel.placePredictedList.isNotEmpty)
                    ? Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: PlacePredicationTile(
                                  predicatedPlaceses:
                                      viewModel.placePredictedList[index],
                                ),
                              );
                            },
                            physics: const ClampingScrollPhysics(),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                height: 30,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Divider(
                                    height: 0,
                                    color: Colors.grey,
                                    thickness: 0,
                                  ),
                                ),
                              );
                            },
                            itemCount: viewModel.placePredictedList.length),
                      )
                    : Container();
              }),
              //display place predications result
            ],
          ),
        ),
      ),
    );
  }
}
