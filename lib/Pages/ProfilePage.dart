import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

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
  List<String> _allergies = []; // List to store food allergies

  final TextEditingController _allergyController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Load profile data and allergies from SharedPreferences
  _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('firstName') ?? 'First Name';
      _lastName = prefs.getString('lastName') ?? 'Last Name';
      _height = prefs.getString('height') ?? 'Height';
      _weight = prefs.getString('weight') ?? 'Weight';
      _avatar = prefs.getString('avatar') ?? 'assets/default_avatar.png';
      _allergies = prefs.getStringList('allergies') ?? []; // Load allergies
    });
  }

  // Save allergies to SharedPreferences
  _saveAllergies() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('allergies', _allergies);
  }

  // Add a new allergy
  void _addAllergy() {
    final newAllergy = _allergyController.text.trim();
    if (newAllergy.isNotEmpty) {
      setState(() {
        _allergies.add(newAllergy);
        _saveAllergies();
      });
      _allergyController.clear(); // Clear the input field
    }
  }

  // Remove an allergy from the list
  void _removeAllergy(int index) {
    setState(() {
      _allergies.removeAt(index);
      _saveAllergies();
    });
  }

  // Pick an image for the avatar
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _saveAvatar(pickedFile.path);
    }
  }

  _saveAvatar(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('avatar', imagePath);
    setState(() {
      _avatar = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffA8BBA2),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
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
            colors: [Color(0xfff2f2f2), Color(0xffA8BBA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: FileImage(File(_avatar)),
                      backgroundColor: Colors.transparent,
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt, size: 40, color: Colors.black.withOpacity(0.7)),
                      onPressed: _pickImage,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  '$_firstName $_lastName',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Height: $_height',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Weight: $_weight',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.grey),
                Text(
                  'Allergies',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _allergyController,
                  decoration: InputDecoration(
                    labelText: 'Add Allergy',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _addAllergy,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _allergies.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(
                          _allergies[index],
                          style: GoogleFonts.roboto(fontSize: 18),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeAllergy(index),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: const Color(0xffA8BBA2),
        child: Icon(Icons.arrow_back, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}