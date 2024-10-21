import 'package:flutter/material.dart';
import 'package:nanny_fairy/Models/predicate_model.dart';
import 'package:nanny_fairy/view/chat/widgets/predicate_request.dart';
import 'package:nanny_fairy/view/chat/widgets/progress_dialog.dart';

class SearchPlaceRepository extends ChangeNotifier {
  List<PredictedPlaces> placePredictedList = [];
  List<PredictedPlaces> get placePridList => placePredictedList;
  String? providerAddress;
  String? get proAddress => providerAddress;
  findPlaceAutoCompleteSearch(String inputText) async {
    if (inputText.length > 1) {
      String components = 'country:PK|administrative_area:GB';
      String urlAutoCompleteSearch =
          'https://maps.googleapis.com/maps/api/place/queryautocomplete/json?input=$inputText&key=AIzaSyCBUyZVjnq9IGxH9Zu6ACNRIJXtkfZ2iuQ&components=$components';
      var responseAutoCompleteSearch =
          await RequestAssistant.getRequest(urlAutoCompleteSearch);
      debugPrint("this is search Response : $responseAutoCompleteSearch");
      if (responseAutoCompleteSearch == 'failed') {
        return;
      }
      if (responseAutoCompleteSearch['status'] == "OK") {
        var placePredictions = responseAutoCompleteSearch["predictions"];
        if (placePredictions is List) {
          var placePredictionsList = placePredictions
              .map((jsonData) => PredictedPlaces.fromJson(jsonData))
              .toList();
          debugPrint(
            "Place Predictions List: ${placePredictionsList.toString()}",
          );

          placePredictedList = placePredictionsList;
          notifyListeners();
          debugPrint("Updated Place Predicted List: $placePredictedList");
        }
      }
    }
  }

  Future<void> getPlaceDirectionDetails(String? placeId, context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => PrograssDialog(
        message: 'Please wait.....',
      ),
    );
    // String placeId = 'ChIJsUMlZONJ5jgRKygXyqMM_UA';
    String placeDirectionDetailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyCBUyZVjnq9IGxH9Zu6ACNRIJXtkfZ2iuQ';
    var responeApi =
        await RequestAssistant.getRequest(placeDirectionDetailsUrl);
    Navigator.pop(context);
    if (responeApi == "failed") {
      return;
    }
    if (responeApi['status'] == 'OK') {
      String locationName = responeApi['result']['name'];

      providerAddress = locationName;
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (c) =>const RegisterDetails()),
      //     (route) => false);
      notifyListeners();
      Navigator.pop(context);
    }
  }
}
