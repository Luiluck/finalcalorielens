import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class HistoryPage extends StatefulWidget {
  final List<Map<String, dynamic>> imageHistory;
  final Function(int) onDelete;

  const HistoryPage({required this.imageHistory, required this.onDelete, Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Function to format the date nicely
  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(date);
  }

  // Function to show the delete confirmation dialog
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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: widget.imageHistory.isEmpty
          ? const Center(child: Text("No history available"))
          : Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wallpaper1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: widget.imageHistory.length,
          itemBuilder: (context, index) {
            final item = widget.imageHistory[index];
            return Card(
              color: Colors.white,
              child: ListTile(
                leading: Image.network(item['imagePath']),
                title: Text(
                  item['name'],
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: ${_formatDate(item['date'])}',
                      style: const TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Analysis: ${item['analysis']}',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirmationDialog(context, index),
                ),
                onTap: () {
                  // Show the analysis details in a dialog when tapped
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Display image
                              Image.network(item['imagePath']),
                              // Display date
                              Text('Date: ${_formatDate(item['date'])}', style: const TextStyle(color: Colors.black)),
                              // Display analysis
                              Text('Analysis: ${item['analysis']}', style: const TextStyle(color: Colors.black)),
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
