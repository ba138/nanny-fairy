import 'package:flutter/material.dart';

import 'package:nanny_fairy/Models/predicate_model.dart';
import 'package:nanny_fairy/ViewModel/place_view_model.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:provider/provider.dart';

class PlacePredicationTile extends StatefulWidget {
  const PlacePredicationTile({super.key, this.predicatedPlaceses});

  final PredictedPlaces? predicatedPlaceses;

  @override
  State<PlacePredicationTile> createState() => _PlacePredicationTileState();
}

class _PlacePredicationTileState extends State<PlacePredicationTile> {
  // Future<void> getPlaceDirectionDetails(String? placeId, context) async {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => PrograssDialog(
  //       message: 'Please wait.....',
  //     ),
  //   );
  //   // String placeId = 'ChIJsUMlZONJ5jgRKygXyqMM_UA';
  //   String placeDirectionDetailsUrl =
  //       'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyCBUyZVjnq9IGxH9Zu6ACNRIJXtkfZ2iuQ';
  //   var responeApi =
  //       await RequestAssistant.getRequest(placeDirectionDetailsUrl);
  //   Navigator.pop(context);
  //   if (responeApi == "failed") {
  //     return;
  //   }
  //   if (responeApi['status'] == 'OK') {
  //     String locationName = responeApi['result']['name'];

  //     setState(() {
  //       providerAddress = locationName;
  //     });
  //     // Navigator.pushAndRemoveUntil(
  //     //     context,
  //     //     MaterialPageRoute(builder: (c) =>const RegisterDetails()),
  //     //     (route) => false);
  //     Navigator.pop(context);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final distanceViewModel =
        Provider.of<PlaceViewModel>(context, listen: false);
    return Row(children: [
      const Icon(
        Icons.location_on,
        color: AppColor.primaryColor,
      ),
      Expanded(
        child: GestureDetector(
          onTap: () {
            distanceViewModel.filterFamiliesByDistance(
                widget.predicatedPlaceses!.placeId, context);
            // getPlaceDirectionDetails(
            //     widget.predicatedPlaceses!.placeId, context);
          },
          child: Text(
            widget.predicatedPlaceses!.mainText!,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 95, 94, 94)),
          ),
        ),
      )
    ]);
  }
}
