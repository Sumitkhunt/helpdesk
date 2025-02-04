import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketSubmissionScreen extends StatefulWidget {
  @override
  _TicketSubmissionScreenState createState() => _TicketSubmissionScreenState();
}

class _TicketSubmissionScreenState extends State<TicketSubmissionScreen> {
  final TextEditingController descriptionController = TextEditingController();
  String category = "General";
  String priority = "Low";

  void submitTicket() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Add ticket details to Firestore
    await FirebaseFirestore.instance.collection('tickets').add({
      'description': descriptionController.text,
      'category': category,
      'status': 'Open',
      'priority': priority,
      'createdBy': userId,
      'createdDate': Timestamp.now(),
      'updatedBy': userId,
      'updatedDate': Timestamp.now(),
    });

    // Show a success message (SnackBar)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Ticket submitted successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Submit a Ticket",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Submit your ticket details below',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Ticket description input field
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
                hintText: 'Enter a brief description of the issue',
              ),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 20),

            // Category dropdown wrapped with Material for decoration
            Text('Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Material(
              elevation: 4, // Add elevation
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: category,
                  isExpanded: true,
                  items:
                      ["General", "Technical", "Billing"].map((String value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) => setState(() => category = newValue!),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Priority dropdown wrapped with Material for decoration
            Text('Priority',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Material(
              elevation: 4, // Add elevation
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: priority,
                  isExpanded: true,
                  items: ["Low", "Medium", "High"].map((String value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) => setState(() => priority = newValue!),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Submit button with styling
            Center(
              child: ElevatedButton(
                onPressed: submitTicket,
                child: Text("Submit Ticket", style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
