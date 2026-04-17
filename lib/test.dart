import 'dart:developer';

import 'package:dio/dio.dart';

Future getData() async {
  try {
    log("Starting getData...");
    var id = "8718e040";
    var appKey = "971cb341a0f6f26293f476a23e1177c0";
    var response = await Dio().get(
      "https://api.edamam.com/api/recipes/v2?type=public&q=chicken&app_id=$id&app_key=$appKey",
    );
    log("Response: ${response.toString()}");
  } catch (e) {
    log("Error in getData: $e");
  }
}
