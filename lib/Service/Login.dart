import 'dart:convert';
import 'package:http/http.dart' as http;

class Userservice {
  var apiUrlSignUp = Uri.parse('https://us-central1-soilproject-91ac2.cloudfunctions.net/app/api/v1/user/signup');
  var apiUrlSignIn = Uri.parse('https://us-central1-soilproject-91ac2.cloudfunctions.net/app/api/v1/user/signin');

  Future<Map<String, dynamic>?> login(String userEmail, String userPass) async {
    var userJsonData = {
      'email': userEmail,
      'password': userPass,
    };

    var jsonString = jsonEncode(userJsonData);

    var response = await http.post(
      apiUrlSignIn,
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonString,
    );

    print(response);
    print("Signin: " + userEmail);

    // Check the response for successful login
    if (response.statusCode == 200) {
      // Decode the response body
      var data = jsonDecode(response.body);
      // Return user information
      return data['user'];
    } else {
      return null;
    }
  }

  getUserData(String userEmail) {}
}
