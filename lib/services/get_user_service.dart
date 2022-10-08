import 'dart:convert';
import 'package:flutter_chat_app/models/user_data.dart';
import 'package:http/http.dart' as http;

class ServicesDBget {
  static const root =
      'https://db-get-zx5s4oejdq-ue.a.run.app/?id=';

  // Function to get User. ENDPOINT GET
  static Future<List<UserData>> getUser(String id) async {
    try {
      final response = await http.get(Uri.parse(root + id));
      if (200 == response.statusCode) {
        List<UserData> list = parseResponse((response.body));
        return list;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Decode to User Data
  static List<UserData> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<UserData>((json) => UserData.fromJson(json)).toList();
  }
}
