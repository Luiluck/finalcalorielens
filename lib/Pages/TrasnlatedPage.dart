import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:translator/translator.dart';  // Import the translator package

class TranslatedPage extends StatefulWidget {
  final String analysisText;

  const TranslatedPage({
    Key? key,
    required this.analysisText, required String translatedText,
  }) : super(key: key);

  @override
  _TranslatedPageState createState() => _TranslatedPageState();
}

class _TranslatedPageState extends State<TranslatedPage> {
  String translatedText = '';
  final GoogleTranslator _translator = GoogleTranslator();  // Create the translator instance

  @override
  void initState() {
    super.initState();
    _translateText(widget.analysisText);  // Translate text when page loads
  }

  // Translate the text from English to Tagalog
  Future<void> _translateText(String text) async {
    final translation = await _translator.translate(text, to: 'tl');  // Translate to Tagalog ('tl')
    setState(() {
      translatedText = translation.text;  // Set the translated text
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translated'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(  // Wrap the body with SingleChildScrollView for scrolling
        padding: const EdgeInsets.all(20.0),
        child: Center(  // Center the translated text
          child: Column(
            children: [
              // Show a loader until translation is done
              translatedText.isEmpty
                  ? const CircularProgressIndicator()
                  : Text(
                translatedText,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}