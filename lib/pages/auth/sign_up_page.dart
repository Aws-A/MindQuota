import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../new_question.dart';
import 'dart:core';

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
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String _passwordStrength = "";

  // Email validation
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Password validation - accept Medium or Strong
  bool _isValidPassword(String password) {
    if (password.length < 8) return false;

    int strength = 0;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=/\\;\[\]~`]').hasMatch(password)) strength++;

    return strength >= 3; // Accept Medium (3) or Strong (4)
  }

  // Password strength meter (display only)
  String _getPasswordStrength(String password) {
    if (password.length < 8) return "Too short";

    int strength = 0;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=/\\;\[\]~`]').hasMatch(password)) strength++;

    switch (strength) {
      case 4:
        return "Strong";
      case 3:
        return "Medium";
      default:
        return "Weak";
    }
  }

  Future<void> _signUp() async {
    setState(() {
      _errorMessage = null;
    });

    // Empty fields
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = "Please fill in all fields.";
      });
      return;
    }

    // Email format
    if (!_isValidEmail(_emailController.text)) {
      setState(() {
        _errorMessage = "Invalid email format.";
      });
      return;
    }

    // Password/confirm match
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords do not match.";
      });
      return;
    }

    // Password validation (Medium or Strong accepted)
    if (!_isValidPassword(_passwordController.text)) {
      setState(() {
        _errorMessage =
            "Password must have at least 3 of these: lowercase, uppercase, number, special character";
      });
      return;
    }

    // Display password strength for user info
    String strength = _getPasswordStrength(_passwordController.text);
    debugPrint("Password strength: $strength");

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign Up Successful!")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewQuestionPage()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() {
          _errorMessage = "This email is already registered.";
        });
      } else {
        setState(() {
          _errorMessage = e.message;
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_errorMessage != null) ...[
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 10),
            ],

            // Email Field
            TextField(
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
            ),
            SizedBox(height: 10),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: !_showPassword,
              onChanged: (value) {
                setState(() {
                  _passwordStrength = _getPasswordStrength(value);
                });
              },
              style: TextStyle(color: Color(0xFF2B4162)),
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Color(0xFF2B4162)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Color(0xFF118AB2),
                  ),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
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
            ),
            if (_passwordStrength.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Password Strength: $_passwordStrength",
                  style: TextStyle(
                    color: _passwordStrength == "Strong"
                        ? Colors.green
                        : (_passwordStrength == "Medium"
                            ? Colors.orange
                            : Colors.red),
                  ),
                ),
              ),
            SizedBox(height: 10),

            // Confirm Password Field
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_showConfirmPassword,
              style: TextStyle(color: Color(0xFF2B4162)),
              decoration: InputDecoration(
                labelText: "Confirm Password",
                labelStyle: TextStyle(color: Color(0xFF2B4162)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Color(0xFF118AB2),
                  ),
                  onPressed: () {
                    setState(() {
                      _showConfirmPassword = !_showConfirmPassword;
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
            ),
            SizedBox(height: 25),

            // Sign Up Button
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