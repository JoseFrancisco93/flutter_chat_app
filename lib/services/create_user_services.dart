import 'dart:convert';
import 'package:http/http.dart' as http;

class ServicesDBpost {
  static const root = 'https://db-post-zx5s4oejdq-ue.a.run.app';

  // Function to post User. ENDPOINT POST
  static Future<String> adduser(
    String idUser,
    String nombres,
    int edad,
    String email,
  ) async {
    try {
      var map = <String, dynamic>{};
      map['id_user'] = idUser;
      map['full_name'] = nombres;
      map['user_age'] = edad;
      map['user_mail'] = email;
      final response = await http.post(Uri.parse(root), body: json.encode(map));
      if (200 == response.statusCode) {
        return 'success';
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }


}
