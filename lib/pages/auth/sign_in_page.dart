import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../new_question.dart'; // Ensure this page exists

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        // ✅ Signed in successfully, navigate to the new question page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NewQuestionPage()),
        );
      } else {
        _showErrorDialog("Sign-in failed. Please try again.");
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? "Sign-in failed. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign In")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Color(0xFF2B4162)),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Color(0xFF2B4162)),
                  suffixIcon: Icon(Icons.email, color: Color(0xFF118AB2)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2B4162)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF118AB2), width: 2),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter an email" : null,
              ),
              SizedBox(height: 17),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: TextStyle(color: Color(0xFF2B4162)),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Color(0xFF2B4162)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Color(0xFF118AB2),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2B4162)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF118AB2), width: 2),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter a password" : null,
              ),
              SizedBox(height: 25),
              SizedBox(
                width: 260,
                height: 60,
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF118AB2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          "Sign In",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to SignUpPage
                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(fontSize: 17, color: Color(0xFF2B4162)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}