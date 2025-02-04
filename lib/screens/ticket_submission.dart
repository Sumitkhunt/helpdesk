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
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Submit a Ticket")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Description")),
            DropdownButton<String>(
              value: category,
              items: ["General", "Technical", "Billing"].map((String value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: (newValue) => setState(() => category = newValue!),
            ),
            DropdownButton<String>(
              value: priority,
              items: ["Low", "Medium", "High"].map((String value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: (newValue) => setState(() => priority = newValue!),
            ),
            ElevatedButton(onPressed: submitTicket, child: Text("Submit")),
          ],
        ),
      ),
    );
  }
}
