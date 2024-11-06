import 'dart:convert';
import 'package:http/http.dart' as http;

class Userservice {
  var apiUrlSignUp =
  Uri.parse('https://us-central1-soilproject-91ac2.cloudfunctions.net/app/api/v1/user/signup');
  var apiUrlSignIn =
  Uri.parse('https://us-central1-soilproject-91ac2.cloudfunctions.net/app/api/v1/user/signin');


  Future<bool> signUp(String userEmail, String userPass, String firstName, String lastName, String height,
      String weight) async {
    var userJsonData = {
      'email': userEmail,
      'password': userPass,
      'firstName': firstName,
      'lastName': lastName,
      'height': height,
      'weight': weight,
      'project': 'foodApp'
    };

    var jsonString = jsonEncode(userJsonData);

    var response = await http.post(
      apiUrlSignUp,
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonString,
    );

    print(response);
    print("Signup: " + userEmail);

    return true;
  }

  Future<bool> login(String userEmail, String userPass) async {
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
      return true;
    } else {
      return false;


    }
  }
}
