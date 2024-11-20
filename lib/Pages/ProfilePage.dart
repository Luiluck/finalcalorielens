import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  String _avatarPath = 'assets/Avatar.png'; // Default avatar image path
  String _firstName = 'First Name'; // Placeholder for first name
  String _lastName = 'Last Name';   // Placeholder for last name
  double _weight = 70.0; // Placeholder for weight
  double _height = 175.0; // Placeholder for height

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load profile data when the page is loaded
    _loadAvatar();      // Load avatar image from SharedPreferences
  }

  // Load profile data (first name, last name, weight, height) from SharedPreferences
  _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('firstName') ?? 'First Name'; // Default if not set
      _lastName = prefs.getString('lastName') ?? 'Last Name';     // Default if not set
      _weight = prefs.getDouble('weight') ?? 70.0;                // Default if not set
      _height = prefs.getDouble('height') ?? 175.0;               // Default if not set
    });
  }

  // Load avatar image from SharedPreferences (if set)
  _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _avatarPath = prefs.getString('avatarPath') ?? 'assets/Avatar.png';
    });
  }

  // Pick a new avatar image from the gallery
  Future<void> _changeAvatar() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('avatarPath', pickedFile.path);

      setState(() {
        _avatarPath = pickedFile.path; // Update the avatar path
      });
    }
  }

  // Update the weight in SharedPreferences
  Future<void> _updateWeight(double weight) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('weight', weight);
    setState(() {
      _weight = weight;
    });
  }

  // Update the height in SharedPreferences
  Future<void> _updateHeight(double height) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('height', height);
    setState(() {
      _height = height;
    });
  }

  // Function to show a dialog to edit weight
  void _editWeight() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double newWeight = _weight;
        return AlertDialog(
          title: Text('Edit Weight'),
          content: TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Enter your weight (kg)'),
            onChanged: (value) {
              if (value.isNotEmpty) {
                newWeight = double.parse(value);
              }
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _updateWeight(newWeight); // Update weight in SharedPreferences
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Function to show a dialog to edit height
  void _editHeight() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double newHeight = _height;
        return AlertDialog(
          title: Text('Edit Height'),
          content: TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Enter your height (cm)'),
            onChanged: (value) {
              if (value.isNotEmpty) {
                newHeight = double.parse(value);
              }
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _updateHeight(newHeight); // Update height in SharedPreferences
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xffA8BBA2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff7f7f7), Color(0xffd6e4d9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Align content to the top
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Stack to overlay the camera icon on the avatar
            Stack(
              alignment: Alignment.bottomRight, // Align camera icon to the bottom-right of the avatar
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(_avatarPath),
                  radius: 55.0,
                ),
                GestureDetector(
                  onTap: _changeAvatar,
                  child: CircleAvatar(
                    backgroundColor: Colors.black, // Black background for the camera icon
                    radius: 15.0,
                    child: Icon(Icons.camera_alt, color: Colors.white), // White camera icon
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // Space between avatar and name
            // Display the retrieved first and last name
            Text(
              '$_firstName $_lastName', // Display the first and last name
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5), // Small space between name and weight/height
            // Weight and Height display with editing option
            GestureDetector(
              onTap: _editWeight, // Trigger editing of weight
              child: Text(
                'Weight: $_weight kg',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
            GestureDetector(
              onTap: _editHeight, // Trigger editing of height
              child: Text(
                'Height: $_height cm',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
            // Expanded container to take up remaining space
            Expanded(child: Container()), // Push content upwards
          ],
        ),
      ),
    );
  }
}
//ctrl z one time