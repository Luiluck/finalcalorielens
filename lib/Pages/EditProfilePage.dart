// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
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
//   @override
//   void initState() {
//     super.initState();
//     _loadProfileData();
//   }
//
//   /// Load avatar image and other data from SharedPreferences
//   Future<void> _loadProfileData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final avatarPath = prefs.getString('avatar_image_path');
//     if (avatarPath != null && File(avatarPath).existsSync()) {
//       setState(() {
//         _avatarImage = File(avatarPath);
//       });
//     }
//   }
//
//   /// Save avatar image path to SharedPreferences
//   Future<void> _saveAvatarPath(String path) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('avatar_image_path', path);
//   }
//
//   /// Pick an image from the gallery and save the path
//   Future<void> _pickImage() async {
//     final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       final imageFile = File(pickedImage.path);
//       setState(() {
//         _avatarImage = imageFile;
//       });
//       await _saveAvatarPath(pickedImage.path); // Save the selected image path
//     }
//   }
//
//   /// Calculate BMI based on weight and height
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
//
//   /// Save profile changes
//   void _saveProfileChanges() {
//     print('Profile updated with: ${_nameController.text}, ${_emailController.text}');
//     // Additional logic to save other profile details
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
