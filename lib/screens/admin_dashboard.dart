import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'ticket_list.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      drawer: AppDrawer(),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TicketListScreen()),
          ),
          child: Text("Manage Tickets"),
        ),
      ),
    );
  }
}
