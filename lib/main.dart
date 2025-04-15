import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TestImagePage(),
  ));
}

class TestImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Test")),
      body: Center(
        child: Image.network(
          'https://i.postimg.cc/63VC9q4s/economics.jpg',
          errorBuilder: (context, error, stackTrace) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red),
                Text("Image failed to load"),
              ],
            );
          },
        ),
      ),
    );
  }
}
