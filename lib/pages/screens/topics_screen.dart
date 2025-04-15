import 'package:flutter/material.dart';
import '../general_questions_page.dart';

class TopicsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> topics = [
    {
      "title": "General",
      "icon": Icons.lightbulb, // Example icon
      "color": Color.fromARGB(255, 43, 65, 98), // Dark blue background
      "diagonalColor": Colors.white,
    },
    {
      "title": "Language & Communication",
      "icon": Icons.language,
      "color": Color.fromRGBO(43, 65, 98, 1),
      "diagonalColor": Color(0xFFEEEEEE),
    },
    {
      "title": "History",
      "icon": Icons.history,
      "color": Color.fromRGBO(43, 65, 98, 1),
      "diagonalColor": Color(0xFFD2D2D2),
    },
    {
      "title": "Geography",
      "icon": Icons.public,
      "color": Color.fromRGBO(43, 65, 98, 1),
      "diagonalColor": Color(0xFF11B2A7),
    },
    {
      "title": "Social Sciences",
      "icon": Icons.people,
      "color": Color.fromRGBO(43, 65, 98, 1),
      "diagonalColor": Color(0xFF26C4F8),
    },
    {
      "title": "Science & Technology",
      "icon": Icons.science,
      "color": Color.fromRGBO(43, 65, 98, 1),
      "diagonalColor": Color(0xFF299FF4),
    },
    {
      "title": "Business & Economics",
      "icon": Icons.business,
      "color": Color.fromRGBO(43, 65, 98, 1),
      "diagonalColor": Color(0xFF29B211),
    },
    {
      "title": "Arts",
      "icon": Icons.palette,
      "color": Color.fromRGBO(43, 65, 98, 1),
      "diagonalColor": Color(0xFFFA8334),
    },
    {
      "title": "Sports & Recreation",
      "icon": Icons.sports_soccer,
      "color": Color.fromRGBO(43, 65, 98, 1),
      "diagonalColor": Color(0xFFFFD119),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(title: Text("Topics")),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 44, // Fixed height
            child: Stack(
              children: [
                // Main dark blue container
                Container(
                  decoration: BoxDecoration(
                    color: topic['color'],
                    borderRadius: BorderRadius.circular(5), // Rounded edges
                  ),
                ),

                // White diagonal section
                ClipPath(
                  clipper: DiagonalClipper(),
                  child: Container(
                    width: 80, // Adjust width of the white section
                    decoration: BoxDecoration(
                      color: topic['diagonalColor'], // Use the new color
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                    ),
                  ),
                ),

                // Row to align icon & text
                Row(
                  children: [
                    // White circular icon background
                    Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        topic['icon'],
                        color: Color(0xFF3E3E3E), // Replaces black with #3E3E3E
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 16), // Spacing
                    // Topic Title
                    Padding(
                      padding: EdgeInsets.only(left: 8), // Adjust the value as needed
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to the corresponding questions page
                          if (topic['title'] == "General") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GeneralQuestionsPage(),
                              ),
                            );
                          }
                          // You can add similar navigation for other topics here
                        },
                        child: Text(
                          topic['title'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Clipper for the opposite 45-degree cut
class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0); // Move to top-right
    path.lineTo(size.width - 20, size.height); // Diagonal cut in the opposite direction
    path.lineTo(0, size.height); // Bottom left corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(DiagonalClipper oldClipper) => false;
}