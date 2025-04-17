import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../new_question.dart'; // Import the next screen

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _signUp() async {
    debugPrint("🔵 _signUp() called");
    debugPrint("📩 Email: \${_emailController.text}, 🔑 Password: \${_passwordController.text}");

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      debugPrint("❌ Email or password is empty!");
      setState(() {
        _errorMessage = "Please enter email and password.";
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      debugPrint("❌ Passwords do not match!");
      setState(() {
        _errorMessage = "Passwords do not match.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      debugPrint("✅ User created: \${userCredential.user!.email}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign Up Successful!")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewQuestionPage()),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("🔥 Firebase Auth Error: \${e.code} - \${e.message}");
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("🔄 SignUpPage UI built");
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Color(0xFF2B4162)),
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Color(0xFF2B4162)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2B4162)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF118AB2), width: 2),
                ),
              ),
            ),
            SizedBox(height: 10),

            TextField(
              controller: _passwordController,
              obscureText: true,
              style: TextStyle(color: Color(0xFF2B4162)),
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Color(0xFF2B4162)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2B4162)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF118AB2), width: 2),
                ),
              ),
            ),
            SizedBox(height: 10),

            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              style: TextStyle(color: Color(0xFF2B4162)),
              decoration: InputDecoration(
                labelText: "Confirm Password",
                labelStyle: TextStyle(color: Color(0xFF2B4162)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2B4162)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF118AB2), width: 2),
                ),
              ),
            ),
            SizedBox(height: 25),
            SizedBox(
              width: 260,
              height: 60,
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF118AB2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}