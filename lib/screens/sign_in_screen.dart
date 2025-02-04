import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_dashboard.dart';
import 'admin_dashboard.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    // Initialize Firebase
    Firebase.initializeApp().catchError((e) {
      setState(() {
        errorMessage = "Failed to initialize Firebase: $e";
      });
    });
  }

  // Sign-in method
  void signIn() async {
    setState(() {
      errorMessage = ''; // Clear any previous error messages
      isLoading = true; // Start loading
    });

    try {
      // Sign in with Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        // Redirect to dashboard based on user role
        if (emailController.text.contains('admin')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboard()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserDashboard()),
          );
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to sign in. Check your credentials.";
      });
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign In")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email input
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            // Password input
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 10),
            // Sign-in button
            ElevatedButton(
              onPressed: isLoading ? null : signIn, // Disable when loading
              child: isLoading
                  ? CircularProgressIndicator() // Show loading spinner
                  : Text("Sign In"),
            ),
            // Display error message
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
