import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'HistoryPage.dart';
import 'LogInPage.dart';
import 'ProfilePage.dart'; // Import ProfilePage

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Map<String, dynamic>> _imageHistory = [];
  bool _isLoading = false;
  String? _lastImagePath;

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
    _lastImagePath = imageFile.path;
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
        final nutrition = analysisData['nutrition']?.toString() ?? 'No nutrition information available';

        _showAnalysisDialog(context, imageUrl, analysis, nutrition, _lastImagePath);

        if (imageUrl != null) {
          _addToHistory('Analysis Result', imageUrl, analysis, DateTime.now());
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

  void _showAnalysisDialog(BuildContext context, String? imageUrl, String analysis, String nutrition, String? capturedImagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Analysis Result'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                if (capturedImagePath != null)
                  Image.file(File(capturedImagePath)),
                if (imageUrl != null)
                  Image.network(imageUrl)
                else
                  const Text('No image available from the server'),
                const Text('Estimated or close to target calories'),
                Text('Analysis: $analysis'),
                Text('Nutrition Information: $nutrition'),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/Avatar.png'),
              radius: 23,
            ),
            const SizedBox(width: 10),
            const Text(
              'Luisito Lacuata',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff607D8B),
                Color(0xff455A64),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.history, color: Colors.white),
                title: const Text('History', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryPage(
                        imageHistory: _imageHistory,
                        onDelete: _deleteFromHistory,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white), // Icon for Profile
                title: const Text('Profile', style: TextStyle(color: Colors.white)), // Text for Profile
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(), // Navigate to ProfilePage
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text('Logout', style: TextStyle(color: Colors.white)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Log Out?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const LogInPage()),
                                    (Route<dynamic> route) => false,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.tealAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
          if (!_isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage('assets/Food.gif') as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  height: 2,
                  width: double.infinity,
                  color: Colors.black,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        _pickImage(context, ImageSource.camera);
                      },
                      icon: const Icon(Icons.camera_alt, size: 40),
                    ),
                    IconButton(
                      onPressed: () {
                        _pickImage(context, ImageSource.gallery);
                      },
                      icon: const Icon(Icons.photo_album, size: 40),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
