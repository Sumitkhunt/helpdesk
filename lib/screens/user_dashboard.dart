import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'ticket_submission.dart';
import 'ticket_list.dart';

class UserDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Dashboard')),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TicketSubmissionScreen())),
              child: Text("Submit a Ticket"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TicketListScreen())),
              child: Text("View My Tickets"),
            ),
          ],
        ),
      ),
    );
  }
}
