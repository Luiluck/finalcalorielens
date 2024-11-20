import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import to format the date

class HistoryPage extends StatefulWidget {
  final List<Map<String, dynamic>> imageHistory;
  final Function(int) onDelete; // Callback to delete an item

  const HistoryPage({
    Key? key,
    required this.imageHistory,
    required this.onDelete,
  }) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool isLoading = false; // To handle the loading state during deletion

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
          content: const Text('Delete image?'),
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
                Navigator.of(context).pop(); // Close the confirmation dialog
                _deleteImage(context, index); // Delete image and show loading indicator
              },
            ),
          ],
        );
      },
    );
  }

  // Method to handle the image deletion and show loading state
  void _deleteImage(BuildContext context, int index) {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    // Call the onDelete callback to remove the image from history
    widget.onDelete(index);

    // Simulate a delay for deletion process (you can replace it with actual async logic)
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false; // Hide loading indicator
      });

      // Refresh the UI after deletion
    });
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
        title: const Center( // Center the title in the AppBar
          child: Text(
            'History',
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())  // Show a loading indicator when deleting
            : widget.imageHistory.isEmpty
            ? const Center(
          child: Text(
            'No images in history.',
            style: TextStyle(fontSize: 18, color: Colors.black54),
            textAlign: TextAlign.center,  // Center the 'No images' message
          ),
        )
            : ListView.builder(
          itemCount: widget.imageHistory.length,
          itemBuilder: (context, index) {
            final imageItem = widget.imageHistory[index];
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
                  title: Center( // Center the title (formatted date)
                    child: Text(
                      formattedDateTime,  // Show formatted date and time
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Column(
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        'Analysis: $shortAnalysis', // Show short analysis in the list
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                        textAlign: TextAlign.center, // Center align the analysis
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
      ),
      // Floating Action Button for back arrow at the bottom
      floatingActionButton: Positioned(
        bottom: 20.0,
        right: 20.0,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
          backgroundColor: Colors.transparent,
          elevation: 2, // To make it look flat
          child: Icon(
            Icons.arrow_back,
            color: Colors.white.withOpacity(0.7), // Arrow color with opacity
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Place it at the bottom-right corner
    );
  }
}
