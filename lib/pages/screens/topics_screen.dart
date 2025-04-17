import 'package:flutter/material.dart';
import '../general_questions_page.dart';
import '../language&communication_questions_page.dart';
import '../history_questions_page.dart';
import '../geography_questions_page.dart';
import '../social-sciences_questions_page.dart';
import '../science&technology_questions_page.dart';
import '../business&economics_questions_page.dart';
import '../arts_questions_page.dart';
import '../sports&recreation_questions_page.dart';

class TopicsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> topics = [
    {
      "title": "General",
      "icon": Icons.lightbulb,
      "color": Color.fromARGB(255, 43, 65, 98),
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
            height: 44,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: topic['color'],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                ClipPath(
                  clipper: DiagonalClipper(),
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      color: topic['diagonalColor'],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
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
                        color: Color(0xFF3E3E3E),
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 16),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: GestureDetector(
                        onTap: () {
                          switch (topic['title']) {
                            case "General":
                              Navigator.push(context, MaterialPageRoute(builder: (context) => GeneralQuestionsPage()));
                              break;
                            case "Language & Communication":
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageCommunicationQuestionsPage()));
                              break;
                            case "History":
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryQuestionsPage()));
                              break;
                            case "Geography":
                              Navigator.push(context, MaterialPageRoute(builder: (context) => GeographyQuestionsPage()));
                              break;
                            case "Social Sciences":
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SocialSciencesQuestionsPage()));
                              break;
                            case "Science & Technology":
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ScienceTechnologyQuestionsPage()));
                              break;
                            case "Business & Economics":
                              Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessEconomicsQuestionsPage()));
                              break;
                            case "Arts":
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ArtsQuestionsPage()));
                              break;
                            case "Sports & Recreation":
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SportsRecreationQuestionsPage()));
                              break;
                          }
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

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width - 20, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(DiagonalClipper oldClipper) => false;
}