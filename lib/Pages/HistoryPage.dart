import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  final List<Map<String, dynamic>> imageHistory;
  final Function(int) onDelete;

  const HistoryPage({required this.imageHistory, required this.onDelete, Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                setState(() {
                  widget.onDelete(index);
                });
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Bold and white title
        ),
        backgroundColor: Colors.green, // Set AppBar background to black
        elevation: 0, // Remove shadow under the AppBar
        leading: IconButton( // White back button
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White arrow icon
          onPressed: () {
            Navigator.pop(context); // Navigate back when pressed
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wallpaper1.jpg'), // Replace with your image path
            fit: BoxFit.cover, // Cover the entire container
          ),
        ),
        child: ListView.builder(
          itemCount: widget.imageHistory.length,
          itemBuilder: (context, index) {
            final item = widget.imageHistory[index];
            return Card(
              color: Colors.white, // Card background color
              child: ListTile(
                leading: Image.network(item['imagePath']),
                title: Text(
                  item['name'],
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Bold and black title
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: ${item['date']}',
                      style: const TextStyle(color: Colors.black), // Black text for date
                    ),
                    Text(
                      'Analysis: ${item['analysis']}',
                      style: const TextStyle(color: Colors.black), // Black text for analysis
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red), // Red delete icon
                  onPressed: () => _showDeleteConfirmationDialog(context, index),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)), // Bold title in dialog
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              Image.network(item['imagePath']),
                              Text('Date: ${item['date']}', style: const TextStyle(color: Colors.black)), // Black text for date
                              Text('Analysis: ${item['analysis']}', style: const TextStyle(color: Colors.black)), // Black text for analysis
                            ],
                          ),
                        ),
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
                },
              ),
            );
          },
        ),
      ),
    );
  }
}