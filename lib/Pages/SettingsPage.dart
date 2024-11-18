import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Service/ChangePassword.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  // Navigate to Edit Profile page
  // void _goToEditProfile(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const EditProfilePage()),
  //   );
  // }
  // Navigate to Change Password page
  void _goToChangePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Edit Profile Button
            // ElevatedButton(
            //   onPressed: () => _goToEditProfile(context),
            //   child: const Text('Edit Profile'),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.green,
            //     padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
            //   ),
            // ),
            const SizedBox(height: 20),

            // Change Password Button
            ElevatedButton(
              onPressed: () => _goToChangePassword(context),
              child: const Text('Change Password'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Edit Profile Page
// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({Key? key}) : super(key: key);
//
//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }
//
// class _EditProfilePageState extends State<EditProfilePage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _weightController = TextEditingController();
//   final TextEditingController _heightController = TextEditingController();
//   File? _avatarImage;
//   double _bmi = 0.0;
//
//   Future<void> _pickImage() async {
//     final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         _avatarImage = File(pickedImage.path);
//       });
//     }
//   }
//
//   void _calculateBMI() {
//     final double weight = double.tryParse(_weightController.text) ?? 0.0;
//     final double heightInInches = double.tryParse(_heightController.text) ?? 0.0;
//
//     if (weight > 0 && heightInInches > 0) {
//       final double heightInMeters = heightInInches * 0.0254;
//       setState(() {
//         _bmi = weight / (heightInMeters * heightInMeters);
//       });
//     }
//   }
//   void _saveProfileChanges() {
//     // Implement saving changes logic here
//     print('Profile updated with: ${_nameController.text}, ${_emailController.text}');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//         backgroundColor: const Color(0xffA8BBA2),
//       ),
//       body: Stack(
//         children: [
//           // Background with gradient
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xfff7f7f7), Color(0xffd6e4d9)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//           // Form inside padding
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Stack(
//                     children: [
//                       CircleAvatar(
//                         backgroundImage: _avatarImage != null
//                             ? FileImage(_avatarImage!)
//                             : const AssetImage('assets/Avatar.png') as ImageProvider,
//                         radius: 50,
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: GestureDetector(
//                           onTap: _pickImage,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.2),
//                                   blurRadius: 4,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             padding: const EdgeInsets.all(6),
//                             child: const Icon(
//                               Icons.camera_alt,
//                               size: 20,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Name',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: _emailController,
//                     decoration: const InputDecoration(
//                       labelText: 'Email',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: _weightController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: 'Weight (kg)',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: _heightController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: 'Height (inches)',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   if (_bmi > 0)
//                     Text(
//                       'Updated BMI: ${_bmi.toStringAsFixed(2)}',
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _saveProfileChanges,
//                     child: const Text(
//                       'Save Changes',
//                       style: TextStyle(color: Colors.black), // Save Changes text in black
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xffA8BBA2),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
