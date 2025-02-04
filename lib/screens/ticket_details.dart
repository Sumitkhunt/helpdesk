import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketDetailsScreen extends StatelessWidget {
  final String ticketId;
  TicketDetailsScreen({required this.ticketId});

  final TextEditingController commentController = TextEditingController();

  void addComment() async {
    await FirebaseFirestore.instance
        .collection('tickets')
        .doc(ticketId)
        .collection('comments')
        .add({
      'comment': commentController.text,
      'createdDate': Timestamp.now(),
    });
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ticket Details")),
      body: Column(
        children: [
          Expanded(child: Text("Details about ticket ID: $ticketId")),
          TextField(
              controller: commentController,
              decoration: InputDecoration(labelText: "Add a comment")),
          ElevatedButton(onPressed: addComment, child: Text("Submit Comment")),
        ],
      ),
    );
  }
}
