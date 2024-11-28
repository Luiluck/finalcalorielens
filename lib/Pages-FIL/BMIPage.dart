import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BMIPage extends StatefulWidget {
  const BMIPage({Key? key}) : super(key: key);

  @override
  _BMIPageState createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String _bmiResult = '';
  String _healthStatus = '';
  String _calorieNeeds = '';

  // Function to calculate BMI
  void _calculateBMI() {
    double? heightInInches = double.tryParse(_heightController.text);
    double? weightInKg = double.tryParse(_weightController.text);

    if (heightInInches != null && weightInKg != null && heightInInches > 0 && weightInKg > 0) {
      // Convert height from inches to meters
      double heightInMeters = heightInInches * 0.0254;

      // Calculate BMI
      double bmi = weightInKg / (heightInMeters * heightInMeters);

      setState(() {
        _bmiResult = bmi.toStringAsFixed(2);

        // Determine health status based on BMI value
        if (bmi < 18.5) {
          _healthStatus = 'Malnourished: Mayroon kang BMI na mas mababa sa malusog na hanay.';
        } else if (bmi >= 18.5 && bmi <= 24.9) {
          _healthStatus = 'Malusog: Ikaw ay nasa malusog na hanay ng BMI.';
        } else if (bmi >= 25 && bmi <= 29.9) {
          _healthStatus = 'labis sa timbang : Bahagya kang nasa itaas ng malusog na hanay ng BMI.';
        } else {
          _healthStatus = 'Obese: Ikaw ay nasa napakataba na hanay ng BMI. Isaalang-alang ang pagkonsulta sa isang doktor.';
        }

        // Calculate daily calorie needs using the Mifflin-St Jeor equation (basic formula)
        double bmr = 10 * weightInKg + 6.25 * (heightInInches * 2.54) - 5 * 25 + 5;  // Assume age 25 and male for simplicity
        _calorieNeeds = 'Ang iyong pang-araw-araw na pangangailangan sa calorie ay humigit-kumulang ${bmr.toStringAsFixed(0)} calories/araw para sa pagpapanatili ng iyong timbang.';
      });
    } else {
      setState(() {
        _bmiResult = '';
        _healthStatus = 'Pakilagay ang wastong taas (sa pulgada) at timbang (sa kg).';
        _calorieNeeds = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center( // Center the title in the AppBar
          child: Text(
            'BMI Calculator',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold, // Bold title text
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Height input field (in inches)
                  TextField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Tangkad (inches)',
                      hintText: 'Ilagay ang iyo tangkad in inches',
                      labelStyle: GoogleFonts.roboto(fontWeight: FontWeight.bold), // Font for label text
                      hintStyle: GoogleFonts.roboto(fontWeight: FontWeight.normal), // Hint text font
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Weight input field (in kg)
                  TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Timbang (kg)',
                      hintText: 'ilagay ang iyo Timbang in kilograms',
                      labelStyle: GoogleFonts.roboto(fontWeight: FontWeight.bold), // Font for label text
                      hintStyle: GoogleFonts.roboto(fontWeight: FontWeight.normal), // Hint text font
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Calculate button
                  ElevatedButton(
                    onPressed: _calculateBMI,
                    child: Text(
                      'Calculate BMI',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffA8BBA2), // BGColor
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // BMI Result
                  if (_bmiResult.isNotEmpty)
                    Column(
                      children: [
                        Text(
                          'ang iyo BMI: $_bmiResult',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _healthStatus,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _calorieNeeds,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Positioned(
        bottom: 20.0,
        right: 20.0,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context); // NavigateBack
          },
          backgroundColor: Colors.transparent,
          elevation: 2, // To make it look flat
          child: Icon(
            Icons.arrow_back,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}