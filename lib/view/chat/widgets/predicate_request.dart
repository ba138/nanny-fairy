import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> getRequest(String url) async {
    http.Response response = await http.get(
      Uri.parse(url),
    );
    debugPrint("this is request Assitant Response:${response.body}");
    try {
      if (response.statusCode == 200) {
        var jsonData = response.body;
        var decodeData = jsonDecode(jsonData);

        return decodeData;
      } else {
        return 'failed';
      }
    } catch (e) {
      debugPrint("this is the excepation of request assist:$e");
      return 'failed';
    }
  }
}
