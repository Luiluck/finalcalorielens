import 'dart:convert';
import 'package:http/http.dart' as http;

class Userservice {
  final Uri apiUrlSignUp = Uri.parse(
      'https://us-central1-soilproject-91ac2.cloudfunctions.net/app/api/v1/user/signup');
  final Uri apiUrlSignIn = Uri.parse(
      'https://us-central1-soilproject-91ac2.cloudfunctions.net/app/api/v1/user/signin');

  // Sign-up Function
  Future<bool> signUp(
      String userEmail,
      String userPass,
      String firstName,
      String lastName,
      String height,
      String weight,
      ) async {
    // Create request body
    final Map<String, dynamic> userJsonData = {
      'email': userEmail,
      'password': userPass,
      'firstName': firstName,
      'lastName': lastName,
      'height': height,
      'weight': weight,
      'project': 'foodApp',
    };

    try {
      // Send POST request
      final response = await http.post(
        apiUrlSignUp,
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(userJsonData),
      );

      // Debugging output
      print("Sign-up Response: ${response.statusCode}");
      print(response.body);

      // Check if the sign-up was successful
      return response.statusCode == 200;
    } catch (error) {
      // Handle any errors during the request
      print("Error during sign-up: $error");
      return false;
    }
  }

  // Login Function
  Future<bool> login(String userEmail, String userPass) async {
    // Create request body
    final Map<String, dynamic> userJsonData = {
      'email': userEmail,
      'password': userPass,
    };

    try {
      // Send POST request
      final response = await http.post(
        apiUrlSignIn,
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(userJsonData),
      );

      // Debugging output
      print("Login Response: ${response.statusCode}");
      print(response.body);

      // Check if the login was successful
      return response.statusCode == 200;
    } catch (error) {
      // Handle any errors during the request
      print("Error during login: $error");
      return false;
    }
  }
}
