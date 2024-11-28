  import 'dart:convert';
  import 'dart:io';
  import 'package:flutter/material.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:image_picker/image_picker.dart';
  import 'package:http/http.dart' as http;
  import '../Service/ChangePassword.dart';
  import 'ProfilePage.dart';
  import 'HistoryPage.dart';
  import 'FoodPage.dart';
  import 'LogInPage.dart';
  import 'BMIPage.dart'; // Import BMIPage
  import 'AboutPage.dart'; // Import AboutPage
  import 'TranslatedPage.dart';

  class MainPage extends StatefulWidget {
    const MainPage({Key? key}) : super(key: key);

    @override
    _MainPageState createState() => _MainPageState();
  }

  class _MainPageState extends State<MainPage> {
    final List<Map<String, dynamic>> _imageHistory = [];
    bool _isLoading = false;
    String? _lastImagePath;

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

    // Fetch translation from API
    Future<String> translateText(String text, String targetLang) async {
      final url = Uri.parse('https://api.mymemory.translated.net/get');
      try {
        final response = await http.get(url.replace(queryParameters: {
          'q': text,
          'langpair': 'en|$targetLang',
        }));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final translatedText = data['responseData']['translatedText'] ?? 'Translation failed';
          return translatedText;
        } else {
          return 'Error: ${response.reasonPhrase}';
        }
      } catch (e) {
        return 'Translation failed: $e';
      }
    }


    // Show analysis dialog
    Future<void> _showAnalysisDialog(BuildContext context, String? imageUrl, String analysis, String? capturedImagePath) async {
      String translatedText = await translateText(analysis, 'tl'); // Translate to Tagalog or desired language

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text('Analysis Result'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (capturedImagePath != null) Image.file(File(capturedImagePath)),
                      if (imageUrl != null)
                        Image.network(imageUrl)
                      else
                        const Text('Picture Here'),
                      const SizedBox(height: 10),
                      Text('Analysis: $analysis', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Translate To Tagalog'),
                    onPressed: () {
                      // Navigate to TranslatedPage and pass the analysis and translated text
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TranslatedPage(
                            analysisText: analysis, // Pass the analysis text
                            translatedText: translatedText, // Pass the translated text
                          ),
                        ),
                      );
                    },
                  ),
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
        },
      );
    }

    void _showLogOutDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Log Out'),
            content: const Text('Are you sure you want to log out?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: const Text('Log Out'),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LogInPage()),
                        (route) => false, // Clear the navigation stack
                  );
                },
              ),
            ],
          );
        },
      );
    }

    // Error dialog
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
                        'Snap Your Food!',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Swipe left to go to the recipe.',
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
                          builder: (context) => const ChangePasswordPage(),
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
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'Change Password',
                        child: Text('Change Password'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'About',
                        child: Text('About'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'BMI',
                        child: Text('BMI'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Log Out',
                        child: Text('Log Out'),
                      ),
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
                          'Camera',
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
                          'History',
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
                          'Gallery',
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
  //ctrl z 469page