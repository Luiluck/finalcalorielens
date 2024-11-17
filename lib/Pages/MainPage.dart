import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../Service/ChangePassword.dart';
import 'ProfilePage.dart';
import 'EditProfilePage.dart';
import 'HistoryPage.dart';
import 'FoodPage.dart';
import 'LogInPage.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Map<String, dynamic>> _imageHistory = [];
  bool _isLoading = false;
  String? _lastImagePath;
  final String userName = "Luis Lacuata";

  void _addToHistory(String name, String imageUrl, String analysis, DateTime date) {
    setState(() {
      _imageHistory.insert(0, {
        'name': name,
        'imagePath': imageUrl,
        'analysis': analysis,
        'date': date,
      });
    });
  }

  void _deleteFromHistory(int index) {
    setState(() {
      _imageHistory.removeAt(index);
    });
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage == null) return;
    final File imageFile = File(pickedImage.path);
    _lastImagePath = imageFile.path;  // Assign image path correctly
    await _sendImageToBackend(context, imageFile);
  }

  Future<void> _sendImageToBackend(BuildContext context, File imageFile) async {
    setState(() {
      _isLoading = true;
    });
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://us-central1-soilproject-91ac2.cloudfunctions.net/app/api/v1/upload'),
    );
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    try {
      var response = await request.send();
      final responseBody = await response.stream.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        final analysisData = jsonDecode(responseBody);
        final analysis = analysisData['Analysis']?.toString() ?? 'No analysis available';
        final imageUrl = analysisData['imageUrl'];
        // Show the analysis dialog
        _showAnalysisDialog(context, imageUrl, analysis, _lastImagePath);
        // Add to history: If imageUrl is not null, use it; otherwise, use the local file path
        if (imageUrl != null) {
          _addToHistory('Analysis Result', imageUrl, analysis, DateTime.now());
        } else {
          _addToHistory('Captured Image', _lastImagePath!, analysis, DateTime.now());
        }
      } else {
        _showErrorDialog(context, 'Failed to upload image');
      }
    } catch (e) {
      _showErrorDialog(context, 'An error occurred while sending the image: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAnalysisDialog(BuildContext context, String? imageUrl, String analysis, String? capturedImagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Analysis Result'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                if (capturedImagePath != null) Image.file(File(capturedImagePath)),
                if (imageUrl != null)
                  Image.network(imageUrl)
                else
                  const Text('No image available from the server'),
                const SizedBox(height: 10),
                Text('Analysis: $analysis', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FoodPage()), // Navigate to FoodPage on swipe left
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background decoration
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xfff2f2f2), Color(0xffe0e0e0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Loading indicator
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            // Main content
            if (!_isLoading)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xfff2f2f2), Color(0xffA8BBA2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            spreadRadius: 2,
                            offset: Offset(2, 3),
                          ),
                        ],
                      ),
                      child: Image.asset('assets/Food.gif', fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Snap Your Food!',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Get nutritional insights instantly.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            // Positioned profile circle avatar with name
            Positioned(
              top: 20.0,
              left: 10.0,
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/Avatar.png'),
                        radius: 20,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      },
                      child: Text(
                        userName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          shadows: [
                            Shadow(
                              blurRadius: 2.0,
                              color: Colors.black.withOpacity(0.2),
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Positioned settings button at top-right corner with PopupMenuButton
            Positioned(
              top: 20.0,
              right: 10.0,
              child: PopupMenuButton<String>(
                onSelected: (String value) {
                  switch (value) {
                    case 'Change Password':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordPage(),
                        ),
                      );
                      break;
                    case 'Edit Profile':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );
                      break;
                    case 'Log Out':
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LogInPage(),
                        ),
                      );
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'Change Password',
                      child: Text('Change Password'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Edit Profile',
                      child: Text('Edit Profile'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Log Out',
                      child: Text('Log Out'),
                    ),
                  ];
                },
              ),
            ),
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xffA8BBA2),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _pickImage(context, ImageSource.camera),
                      child: const Text('Camera'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffd3d3d3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryPage(
                            imageHistory: _imageHistory,
                            onDelete: _deleteFromHistory,
                          ),
                        ),
                      ),
                      child: const Text('History'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffd3d3d3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _pickImage(context, ImageSource.gallery),
                      child: const Text('Gallery'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffd3d3d3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
