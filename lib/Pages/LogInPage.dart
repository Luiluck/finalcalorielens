import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:finalcalorielens/Pages/MainPage.dart'; // Import your MainPage here
import 'package:finalcalorielens/Pages/SignUpPage.dart'; // Import your SignUpPage here
import '../Service/user.dart'; // Import your user service

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  String _userEmail = "";
  String _userPass = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Userservice userService = Userservice(); // Instantiate UserService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures screen adjusts when keyboard appears
      body: SingleChildScrollView( // Makes the page scrollable
        child: Container(
          width: double.infinity, // Take up all available width
          height: MediaQuery.of(context).size.height, // Make sure the height is the same as the screen height
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bgg.jpg'), // BG
              fit: BoxFit.cover, // Covers the entire screen
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align the content to the start (left)
              children: [
                // Centered app logo
                Container(
                  padding: EdgeInsets.only(top: 80), // Add top padding to position the logo
                  child: Center(
                    child: Image.asset('assets/LOGO1.png', width: 1000, height: 120), // Centered logo
                  ),
                ),
                SizedBox(height: 1),
                // Add extra space before login form
                SizedBox(height: 50), // Adjust this value to move the login form lower or higher
                // Login form container with text fields and button
                FadeInUp(
                  duration: Duration(seconds: 1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Title
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(49, 39, 79, 1),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Email/Username TextField
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Email or User Name',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {
                            _userEmail = value;
                          },
                        ),
                        SizedBox(height: 20),
                        // Password TextField
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {
                            _userPass = value;
                          },
                        ),
                        SizedBox(height: 20),
                        // Login Button
                        ElevatedButton(
                          onPressed: () async {
                            if (_userEmail.isNotEmpty && _userPass.isNotEmpty) {
                              bool success = await userService.login(
                                _userEmail,
                                _userPass,
                              );
                              if (success) {
                                // Show loading indicator while navigating
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                      ),
                                    );
                                  },
                                );
                                // Delay navigation to simulate loading
                                await Future.delayed(const Duration(seconds: 2));
                                // If login is successful, navigate to MainPage
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainPage(),
                                  ),
                                );
                              } else {
                                // Display error message if login fails
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Invalid email or password'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                            backgroundColor: Color.fromRGBO(49, 39, 79, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Login Now',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 20),
                        // "Don’t have an account?" text button
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpPage()),
                            );
                          },
                          child: Text(
                            "Don't have an account? Signup Now",
                            style: TextStyle(
                              color: Color.fromRGBO(49, 39, 79, 1),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
