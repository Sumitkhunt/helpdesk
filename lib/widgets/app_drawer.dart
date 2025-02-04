import 'package:flutter/material.dart';
import '../screens/user_dashboard.dart';
import '../screens/admin_dashboard.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text("Navigation",
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          ListTile(
              title: Text("User Dashboard"),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserDashboard()))),
          ListTile(
              title: Text("Admin Dashboard"),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminDashboard()))),
        ],
      ),
    );
  }
}
