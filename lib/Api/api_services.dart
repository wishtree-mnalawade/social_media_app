import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

class ApiServices {
  /// Get request for post screen
  static Future<Map> fetchPostData() async {
    final response = await get(
        Uri.parse("https://dummyapi.io/data/v1/post?limit=20"),
        headers: {"app-id": "62b96b8063ae73811019d4f7"});
    final data = jsonDecode(response.body) as Map;
    return (data) ;
  }

  /// Get request for user screen
  static Future<Map> fetchUserData() async {
    final response = await get(
        Uri.parse("https://dummyapi.io/data/v1/user?limit=20"),
        headers: {"app-id": "62b96b8063ae73811019d4f7"});
    final data = jsonDecode(response.body) as Map;
    // print(data);
    return data;
  }

  /// Get request for profile screen
  static Future<Map> fetchProfileData() async {
    final response = await get(
        Uri.parse("https://dummyapi.io/data/v1/user/60d0fe4f5311236168a109ca"),
        headers: {"app-id": "62b96b8063ae73811019d4f7"});
    final data = jsonDecode(response.body) as Map;
    // print(data);
    return data;
  }
}
