import 'dart:convert';
import 'dart:io';
import 'package:finalcalorielens/Pages/MainPage.dart';
import 'package:finalcalorielens/Service/ChangePasswordFil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'ProfilePage.dart';
import 'HistoryPage.dart';
import 'FoodPage.dart';
import 'LogInPage.dart';
import 'BMIPage.dart'; // Import BMIPage
import 'AboutPage.dart'; // Import AboutPage

class MainPageFil extends StatefulWidget {
  const MainPageFil({Key? key}) : super(key: key);

  @override
  _MainPageFilState createState() => _MainPageFilState();
}

class _MainPageFilState extends State<MainPageFil> {
  final List<Map<String, dynamic>> _imageHistory = [];
  bool _isLoading = false;
  String? _lastImagePath;
  String lang = 'fil';

  // Add image details to history
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

  // Remove an image from history
  void _deleteFromHistory(int index) {
    setState(() {
      _imageHistory.removeAt(index);
    });
  }

  // Pick an image from the camera or gallery
  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage == null) return;
    final File imageFile = File(pickedImage.path);
    _lastImagePath = imageFile.path;
    await _sendImageToBackend(context, imageFile);
  }

  // Send image to backend for analysis
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

        // Add to history
        if (imageUrl != null) {
          _addToHistory('resulta ng pagsusuri', imageUrl, analysis, DateTime.now());
        } else {
          _addToHistory('nakunan larawan', _lastImagePath!, analysis, DateTime.now());
        }
      } else {
        _showErrorDialog(context, 'sablay ang pag-upload ng larawan');
      }
    } catch (e) {
      _showErrorDialog(context, 'Nagkaroon ng error habang ipinapadala ang larawan: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Show error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('May Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Isara'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Show analysis dialog
  void _showAnalysisDialog(BuildContext context, String? imageUrl, String analysis, String? capturedImagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resulta ng Analysis'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                if (capturedImagePath != null) Image.file(File(capturedImagePath)),
                if (imageUrl != null)
                  Image.network(imageUrl)
                else
                  const Text('Larawan Dito'),
                const SizedBox(height: 10),
                Text('Pagsusuri: $analysis', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: const Text('Isara'),
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

  // Show log out confirmation dialog
  void _showLogOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mag-Log Out'),
          content: const Text('Sigurado kang gusto mo mag log-out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ikansela'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Mag-Log Out'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LogInPage(),
                  ),
                );
              },
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
            MaterialPageRoute(builder: (context) => FoodPage()),
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
                    Text(
                      'Kuhaan ng Litrato ang Iyong Pagkain!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Mag-swipe sa kaliwa para sa mga recipe',
                      style: GoogleFonts.roboto(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

            // Positioned profile circle avatar without name
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                  child: Text(
                    'Profile',
                    style: GoogleFonts.pacifico(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Positioned settings button at top-right corner with PopupMenuButton
            Positioned(
              top: 20.0,
              right: 10.0,
              child: PopupMenuButton<String>(
                onSelected: (String value) {
                  if (value == 'Log Out') {
                    _showLogOutDialog(context); // Show confirmation dialog
                  } else if (value == 'Change Password') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordFilPage(),
                      ),
                    );
                  } else if (value == 'About') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutPage(),
                      ),
                    );
                  } else if (value == 'BMI') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BMIPage(),
                      ),
                    );
                  } else if (value == 'Language') {
                    switch (lang) {
                      case 'eng':
                        setState(() {
                          lang = 'fil';
                        });
                      case 'fil':
                        setState(() {
                          lang = 'eng';
                        });
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainPage(),
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'Change Password',
                      child: Text('Palitan ang Password'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'About',
                      child: Text('Tungkol sa Amin'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'BMI',
                      child: Text('BMI'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Log Out',
                      child: Text('Mag-log Out'),
                    ),
                    PopupMenuItem<String>(
                        value: 'Language',
                        child: Text('Wika: $lang')
                    )
                  ];
                },
              ),
            ),

            // Positioned action buttons at bottom
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xFFD3D3D3),
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
                      child: Text(
                        'Kamera',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
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
                      child: Text(
                        'Kasaysayan',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffd3d3d3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _pickImage(context, ImageSource.gallery),
                      child: Text(
                        'Galerya',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
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