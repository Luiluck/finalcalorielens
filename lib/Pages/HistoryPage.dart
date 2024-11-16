import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import to format the date

class HistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> imageHistory;
  final Function(int) onDelete; // Callback to delete an item

  const HistoryPage({
    Key? key,
    required this.imageHistory,
    required this.onDelete,
  }) : super(key: key);

  // Method to show the image, analysis, and brief text with delete confirmation
  void _showDetail(BuildContext context, String? imagePath, String analysis, int index) {
    // Show a detailed view with image, full analysis, and brief text
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Image Details'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                if (imagePath != null)
                  imagePath.startsWith('http') // Check if the image is a URL
                      ? Image.network(imagePath, height: 250, width: 250, fit: BoxFit.cover)
                      : Image.file(File(imagePath), height: 250, width: 250, fit: BoxFit.cover),
                const SizedBox(height: 10),
                Text(
                  'Analysis: $analysis',  // Show full analysis
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _confirmDelete(context, index); // Call the delete confirmation method
              },
            ),
          ],
        );
      },
    );
  }

  // Method to confirm deletion
  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Image'),
          content: const Text('Do you really want to delete this image?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                onDelete(index); // Perform the deletion
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Method to get a short version of the analysis (first 50 characters)
  String _getShortAnalysis(String analysis) {
    return analysis.length > 50 ? analysis.substring(0, 50) + '...' : analysis;
  }

  // Method to format the date and time (hour:minute)
  String _formatDateTime(DateTime dateTime) {
    final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm"); // Only hour and minute
    return dateFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: const Color(0xffA8BBA2),
      ),
      body: imageHistory.isEmpty
          ? const Center(
        child: Text(
          'No images in history.',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      )
          : ListView.builder(
        itemCount: imageHistory.length,
        itemBuilder: (context, index) {
          final imageItem = imageHistory[index];
          final imagePath = imageItem['imagePath'];
          final analysis = imageItem['analysis'];
          final date = imageItem['date']; // Get the date
          final formattedDateTime = _formatDateTime(date); // Format the date and time

          // Get short version of the analysis
          String shortAnalysis = _getShortAnalysis(analysis);

          return GestureDetector(
            onTap: () {
              _showDetail(context, imagePath, analysis, index); // Show detail view on tap
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                title: Text(
                  formattedDateTime,  // Show formatted date and time
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      'Analysis: $shortAnalysis', // Show short analysis in the list
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
                leading: imagePath != null
                    ? imagePath.startsWith('http') // Check if the image is a URL
                    ? Image.network(imagePath, width: 50, height: 50, fit: BoxFit.cover)
                    : Image.file(File(imagePath), width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.image, size: 50),
              ),
            ),
          );
        },
      ),
    );
  }
}
