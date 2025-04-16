import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'pages/landing_page.dart';
import 'pages/submitted_questions.dart'; // Import SubmittedQuestionsPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(), // Start with LandingPage or auth check
        '/submitted_questions': (context) => SubmittedQuestionsPage(), // Register the route
      },
    );
  }
}