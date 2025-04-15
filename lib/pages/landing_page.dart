import 'package:flutter/material.dart';
import 'auth/sign_in_page.dart';
import 'auth/sign_up_page.dart';
import 'screens/topics_screen.dart'; // Updated import

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/logo.png', // Path to your logo
              height: 222, // Adjust the size as needed
            ),
            const SizedBox(height: 25),
            const Text(
              "Welcome to our quiz app.",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 35),

            // Sign In Button
            _buildButton(
              context,
              text: "Sign In",
              color: const Color(0xFF118AB2),
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
            ),

            const SizedBox(height: 25),

            // Sign Up Button
            _buildButton(
              context,
              text: "Sign Up",
              color: const Color(0xFF118AB2),
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
            ),

            const SizedBox(height: 25),

            // Continue as Guest Button
            _buildButton(
              context,
              text: "Continue as Guest",
              color: const Color(0xFFFFD116),
              textColor: Colors.black,
              borderColor: const Color(0xFFFFD116),
              isTextButton: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TopicsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Common button builder for consistency
  Widget _buildButton(
    BuildContext context, {
    required String text,
    required Color color,
    required Color textColor,
    VoidCallback? onPressed,
    Color? borderColor,
    bool isTextButton = false,
  }) {
    return SizedBox(
      width: 260,
      height: 60,
      child: isTextButton
          ? TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                backgroundColor: color,
                side: BorderSide(color: borderColor ?? color, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(text, style: TextStyle(fontSize: 25, color: textColor)),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(text, style: TextStyle(fontSize: 25, color: textColor)),
            ),
    );
  }
}