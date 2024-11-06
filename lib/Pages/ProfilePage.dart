import 'package:flutter/material.dart';
import 'SettingsPage.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  double _bmi = 0.0;

  // Function to calculate BMI
  void _calculateBMI() {
    final double weight = double.tryParse(_weightController.text) ?? 0.0;
    final double heightInInches = double.tryParse(_heightController.text) ?? 0.0;

    if (weight > 0 && heightInInches > 0) {
      // Convert height from inches to meters
      final double heightInMeters = heightInInches * 0.0254;

      // Calculate BMI
      setState(() {
        _bmi = weight / (heightInMeters * heightInMeters);
      });
    }
  }

  // Navigate to Settings Page
  void _goToSettings() {
    print("Navigating to settings...");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _goToSettings, // Navigate to the settings page
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage('assets/Avatar.png'), // Set your profile image
                radius: 50.0,
              ),
              const SizedBox(height: 20),
              const Text(
                'Luisito Lacuata',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text('Data Analyst Aspirant'),
              const SizedBox(height: 20),

              // Weight Input
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Height Input
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Height (inches)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Calculate BMI Button
              ElevatedButton(
                onPressed: _calculateBMI,
                child: const Text('Calculate BMI'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
                ),
              ),
              const SizedBox(height: 20),

              // Display BMI
              if (_bmi > 0)
                Text(
                  'Your BMI: ${_bmi.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Sample Settings Page (you can replace this with your own settings page)
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Settings Page Content'),
      ),
    );
  }
}
