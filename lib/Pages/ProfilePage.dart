import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  double _bmi = 0.0;

  void _calculateBMI() {
    final double weight = double.tryParse(_weightController.text) ?? 0.0;
    final double heightInInches = double.tryParse(_heightController.text) ?? 0.0;

    if (weight > 0 && heightInInches > 0) {
      final double heightInMeters = heightInInches * 0.0254;
      setState(() {
        _bmi = weight / (heightInMeters * heightInMeters);
      });
    }
  }

  void _showLogoutConfirmationDialog() {
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Log Out'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/login');
              },
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _showLogoutConfirmationDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xfff7f7f7), Color(0xffd6e4d9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/Avatar.png'),
                  radius: 60.0,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Luisito Lacuata',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Data Analyst Aspirant',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                const SizedBox(height: 30),
                _buildBMIInputFields(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateBMI,
                  child: const Text('Calculate BMI'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffA8BBA2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_bmi > 0)
                  Text(
                    'Your BMI: ${_bmi.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBMIInputFields() {
    return Column(
      children: [
        SizedBox(
          width: 240,
          child: TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 240,
          child: TextField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Height (inches)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
