import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

class ApiServices {
  /// Get request
  static Future<Map> fetchData() async {
    final response =
    await get(Uri.parse("https://dummyapi.io/data/v1/post?limit=10"),headers: {"app-id": "62b96b8063ae73811019d4f7"});
    final data = jsonDecode(response.body) as Map;
   // print(data);
    return data;

  }


}