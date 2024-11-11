import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Method to handle sign-up logic
  void _signUp() {
    if (_formKey.currentState?.validate() ?? false) {
      print('First Name: ${_firstNameController.text}');
      print('Last Name: ${_lastNameController.text}');
      print('Email: ${_emailController.text}');
      print('Height: ${_heightController.text}');
      print('Weight: ${_weightController.text}');
      print('Password: ${_passwordController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bgg.jpg'), // Food-themed background
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.deepOrange),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 35),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Spacing
                  SizedBox(height: 20),

                  // Header Text
                  Text(
                    'Get Started\nwith Delicious Food!',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Form Fields
                  _buildTextField(_firstNameController, "First Name"),
                  _buildTextField(_lastNameController, "Last Name"),
                  _buildTextField(_emailController, "Email"),
                  _buildTextField(_heightController, "Height (in inches)", keyboardType: TextInputType.number),
                  _buildTextField(_weightController, "Weight (kg)", keyboardType: TextInputType.number),
                  _buildTextField(_passwordController, "Password", obscureText: true),
                  _buildTextField(_confirmPasswordController, "Confirm Password", obscureText: true),
                  SizedBox(height: 40),

                  // Sign Up Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.deepOrange,
                        child: IconButton(
                          color: Colors.white,
                          onPressed: _signUp,
                          icon: Icon(Icons.arrow_forward),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),

                  // Sign In Link
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'login');
                      },
                      child: Text(
                        'Already have an account? Sign In',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.deepOrange,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {TextInputType? keyboardType, bool obscureText = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(2, 2)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $hintText';
          }
          return null;
        },
      ),
    );
  }
}
