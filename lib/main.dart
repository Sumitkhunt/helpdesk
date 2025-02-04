import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/sign_in_screen.dart';
import 'screens/user_dashboard.dart';
import 'screens/admin_dashboard.dart';
import 'screens/ticket_submission.dart';
import 'screens/ticket_list.dart';
import 'screens/ticket_details.dart';
import 'widgets/app_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  runApp(HelpdeskApp());
}

class HelpdeskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helpdesk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: TextTheme(
          displayLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      home: SignInScreen(),
    );
  }
}

class TicketService {
  final CollectionReference tickets =
      FirebaseFirestore.instance.collection('tickets');

  Future<void> submitTicket(String description, String category,
      String priority, String userId) async {
    await tickets.add({
      'description': description,
      'category': category,
      'status': 'Open',
      'priority': priority,
      'createdBy': userId,
      'createdDate': Timestamp.now(),
      'updatedBy': userId,
      'updatedDate': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getUserTickets(String userId) {
    return tickets.where('createdBy', isEqualTo: userId).snapshots();
  }

  Stream<QuerySnapshot> getAllTickets() {
    return tickets.snapshots();
  }

  Future<void> updateTicketStatus(
      String ticketId, String status, String adminId) async {
    await tickets.doc(ticketId).update({
      'status': status,
      'updatedBy': adminId,
      'updatedDate': Timestamp.now()
    });
  }

  Future<void> addTicketComment(
      String ticketId, String comment, String adminId) async {
    await tickets.doc(ticketId).collection('comments').add({
      'comment': comment,
      'createdBy': adminId,
      'createdDate': Timestamp.now(),
    });
  }
}
