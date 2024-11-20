import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center( // Center the title in the AppBar
          child: Text(
            'About',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold, // Bold title text
              fontSize: 24, // Slightly larger title font
            ),
          ),
        ),
        backgroundColor: const Color(0xffA8BBA2), // Greenish color for AppBar
        elevation: 0, // Remove shadow under the AppBar
        automaticallyImplyLeading: false, // Remove back button from AppBar
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff2f2f2), Color(0xffA8BBA2)], // Set gradient background
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center( // Center the content vertically and horizontally
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/LOGO1.png',
                  height: 250,
                  width: 250,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Welcome to CalorieLens, your ultimate companion for making informed dietary choices on the go. Powered by cutting-edge technology, our app revolutionizes how you recognize, analyze, and manage your meals, all from the convenience of your smartphone.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.normal, // Normal weight for body text
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Show dialog with key features
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          title: Text(
                            'Key Features',
                            style: TextStyle(color: Colors.black, fontSize: 22),
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FeatureItem(
                                name: 'Food Recognition: ',
                                description:
                                'Instantly identify a variety of common Filipino dishes using advanced deep learning models.',
                                titleColor: Colors.black,
                                descriptionColor: Colors.black87,
                              ),
                              FeatureItem(
                                name: 'Details Analysis: ',
                                description:
                                'Show detailed information to dive deep into the recognized dishes, catering to specific dietary requirements and restrictions.',
                                titleColor: Colors.black,
                                descriptionColor: Colors.black87,
                              ),
                              FeatureItem(
                                name: 'Calorie Estimation: ',
                                description:
                                'Seamlessly estimate and monitor your daily caloric intake, empowering you to maintain a balanced diet and achieve your health goals.',
                                titleColor: Colors.black,
                                descriptionColor: Colors.black87,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Key Feature',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold, // Bold text for the button
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey.shade300, // Button color change to match gradient palette
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact Info:',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 26, // Larger font for section headers
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Got questions or feedback? We\'d love to hear from you!',
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Email: angelotorregoza@gmail.com',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Social Media:CalorieLens',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
            Navigator.pop(context); // Navigate back when pressed
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

class FeatureItem extends StatelessWidget {
  final String name;
  final String description;
  final Color titleColor;
  final Color descriptionColor;

  const FeatureItem({
    super.key,
    required this.name,
    required this.description,
    this.titleColor = Colors.white,
    this.descriptionColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: titleColor, // Use specified title color
          ),
        ),
        const SizedBox(height: 5),
        Text(
          description,
          style: GoogleFonts.roboto(
            fontSize: 18,
            color: descriptionColor, // Use specified description color
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
