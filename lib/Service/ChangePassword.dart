import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // State variables for password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final String email = emailController.text.trim();
    final String newPassword = passwordController.text.trim();

    setState(() {
      isLoading = true; // Start loading indicator
    });

    try {
      final response = await http.post(
        Uri.parse(
            'https://us-central1-soilproject-91ac2.cloudfunctions.net/app/api/v1/user/updatepassword'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        _showMessage(context, 'Password updated successfully.');
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        _formKey.currentState?.reset();
      } else {
        String errorMessage = 'Failed to update password.';
        switch (response.statusCode) {
          case 400:
            errorMessage = 'Invalid request. Please check your data.';
            break;
          case 404:
            errorMessage = 'User not found.';
            break;
          case 500:
            errorMessage = 'Internal server error. Please try again later.';
            break;
          default:
            errorMessage =
            'An unexpected error occurred (${response.statusCode}).';
        }
        _showMessage(context, errorMessage);
      }
    } catch (e) {
      print("Error updating password: $e"); // Log the error for debugging
      _showMessage(
          context, 'An error occurred. Please try again later. Error: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading indicator
      });
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center( // Center the title in the AppBar
          child: Text(
            'Change Password',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold, // Bold title text
            ),
          ),
        ),
        backgroundColor: const Color(0xffA8BBA2), // Greenish color for AppBar
        elevation: 0, // Remove shadow under the AppBar
        automaticallyImplyLeading: false, // Remove back button from AppBar
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity, // Full screen height
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff7f7f7), Color(0xffd6e4d9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Space above the form
                  const SizedBox(height: 40), // This space pushes the content downward
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Enter your email and new password',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20), // Space between the header and form fields
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email field
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            const emailPattern =
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                            final regex = RegExp(emailPattern);
                            if (!regex.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15.0), // Space between fields
                        // New password field
                        TextFormField(
                          controller: passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a new password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15.0), // Space between fields
                        // Confirm password field
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0), // Space between fields and button
                        // Submit button
                        MaterialButton(
                          minWidth: double.infinity,
                          onPressed: isLoading ? null : updatePassword,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          color: const Color(0xffA8BBA2), // Button background color
                          textColor: Colors.black,
                          child: isLoading
                              ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white))
                              : const Text('Change Password'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // Floating Action Button for "Back" arrow icon at the bottom
      floatingActionButton: Positioned(
        bottom: 20.0,
        right: 20.0,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
          backgroundColor: Colors.transparent,
          elevation: 2, // To make it look flat
          child: Icon(
            Icons.arrow_back,
            color: Colors.white.withOpacity(0.7), // Arrow color with opacity
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
