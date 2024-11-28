import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _firstName = 'First Name';
  String _lastName = 'Last Name';
  String _height = 'Height';
  String _weight = 'Weight';
  String _avatar = 'assets/default_avatar.png'; // Default avatar image

  final ImagePicker _picker = ImagePicker(); // ImagePicker to choose images

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load user data from SharedPreferences
  }

  // Load profile data from SharedPreferences
  _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('firstName') ?? 'First Name';
      _lastName = prefs.getString('lastName') ?? 'Last Name';
      _height = prefs.getString('height') ?? 'Height';
      _weight = prefs.getString('weight') ?? 'Weight';
      _avatar = prefs.getString('avatar') ?? 'assets/default_avatar.png'; // Fetch avatar image path
    });
  }

  // Function to pick an image (either from camera or gallery)
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _saveAvatar(pickedFile.path);
    }
  }

  // Save avatar image path to SharedPreferences
  _saveAvatar(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('avatar', imagePath); // Save the image path
    setState(() {
      _avatar = imagePath; // Update the UI with the new avatar
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffA8BBA2), // Greenish background color for AppBar
        elevation: 0, // No shadow for a clean look
        automaticallyImplyLeading: false, // Disable back button in AppBar
        title: Text(
          'Profile', // Updated app bar title to 'Profile'
          style: GoogleFonts.poppins( // Apply custom font for the title
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff2f2f2), Color(0xffA8BBA2)], // GradientBackground
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Align items to the top
              crossAxisAlignment: CrossAxisAlignment.center, // Center the profile content
              children: [
                const SizedBox(height: 20), // SpaceAvatar

                // Avatar
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: FileImage(File(_avatar)), // Show the avatar image
                      backgroundColor: Colors.transparent,
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt, size: 40, color: Colors.black.withOpacity(0.7)),
                      onPressed: _pickImage,//gallery
                    ),
                  ],
                ),
                const SizedBox(height: 20), // SpaceAvatar

                // Name display
                Text(
                  '$_firstName $_lastName',
                  style: GoogleFonts.poppins( // Font
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10), // SpaceName

                // Height and Weight display
                Text(
                  'Tangkad: $_height',
                  style: GoogleFonts.roboto( // Font
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Timbang: $_weight',
                  style: GoogleFonts.roboto( // Font
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40), // SpaceAfterWeight
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Positioned(
        bottom: 20.0,
        right: 20.0,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context); //previous screen
          },
          backgroundColor: Colors.transparent,
          elevation: 2, // Flat button appearance
          child: Icon(
            Icons.arrow_back,
            color: Colors.white.withOpacity(0.7), //icon color
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}