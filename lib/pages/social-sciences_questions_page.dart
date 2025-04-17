import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SocialSciencesQuestionsPage extends StatefulWidget {
  @override
  _SocialSciencesQuestionsPageState createState() => _SocialSciencesQuestionsPageState();
}

String convertToRawGitHubUrl(String url) {
  if (url.contains('github.com') && url.contains('/blob/')) {
    return url
        .replaceFirst('https://github.com/', 'https://raw.githubusercontent.com/')
        .replaceFirst('/blob/', '/');
  }
  if (url.startsWith('assets/')) {
    return 'https://raw.githubusercontent.com/Aws-A/MindQuota/main/$url';
  }
  return url;
}

Future<List<Map<String, dynamic>>> getTenRandomSocialSciencesQuestions() async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('social-sciences_questions')
        .get();

    print("🧠 Total fetched social sciences questions: ${snapshot.docs.length}");

    final allQuestions = snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        ...data,
        "id": doc.id,
      };
    }).toList();

    allQuestions.shuffle();
    return allQuestions.take(10).toList();
  } catch (e) {
    print("❌ Error getting social sciences questions: $e");
    return [];
  }
}

class _SocialSciencesQuestionsPageState extends State<SocialSciencesQuestionsPage> {
  int currentQuestionIndex = 0;
  int score = 0;
  String? selectedAnswer;
  bool isAnswered = false;
  bool isLoading = true;

  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    print("🧠 Loading social sciences questions...");
    setState(() => isLoading = true);

    questions = await getTenRandomSocialSciencesQuestions();

    print("✅ Finished loading social sciences. Total loaded: ${questions.length}");
    setState(() => isLoading = false);
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        isAnswered = false;
      });
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text("Quiz Completed!"),
          content: Text("Your score: $score / ${questions.length}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                restartQuiz();
              },
              child: Text("Restart Quiz"),
            )
          ],
        ),
      );
    }
  }

  void restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      selectedAnswer = null;
      isAnswered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Social Sciences Questions")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Social Sciences Questions")),
        body: Center(child: Text("No questions found.")),
      );
    }

    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Social Sciences Questions")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: SizedBox(
                height: 350,
                width: double.infinity,
                child: question["imageUrl"] != null &&
                        question["imageUrl"].toString().trim().isNotEmpty
                    ? Image.network(
                        convertToRawGitHubUrl(question["imageUrl"]),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          'assets/quiz.jpg',
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        'assets/quiz.jpg',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(height: 20),
            CustomPaint(size: Size(double.infinity, 5), painter: YellowLinePainter()),
            CustomPaint(size: Size(double.infinity, 5), painter: NavyLinePainter()),
            CustomPaint(size: Size(double.infinity, 5), painter: WhiteLinePainter()),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                question["question"] ?? "",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            Column(
              children: (question["options"] as List<dynamic>).asMap().entries.map<Widget>((entry) {
                int i = entry.key;
                String option = entry.value;
                String correctAnswer = question["answer"];
                bool isCorrect = correctAnswer == option;
                bool isSelected = selectedAnswer == option;

                return GestureDetector(
                  onTap: () {
                    if (!isAnswered) {
                      setState(() {
                        selectedAnswer = option;
                        isAnswered = true;
                        if (isCorrect) score++;
                      });
                      Future.delayed(Duration(seconds: 1), nextQuestion);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    height: 44,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isCorrect ? Color(0xFF118AB2) : Color(0xFFFA8334))
                                : Color(0xFF2B4162),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 88.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                option,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ClipPath(
                          clipper: DiagonalClipper(),
                          child: Container(
                            width: 80,
                            decoration: BoxDecoration(
                              color: Color(0xFFFFD116),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                getAnswerLabel(i),
                                style: TextStyle(
                                  color: Color(0xFF3E3E3E),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String getAnswerLabel(int index) {
    return ["A", "B", "C", "D"][index];
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

class YellowLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Color(0xFFFFD116)..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, size.height - 25)
      ..lineTo(size.width, size.height - 100)
      ..lineTo(size.width, size.height - 85)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class NavyLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Color(0xFF2B4162)..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, size.height - 30)
      ..lineTo(size.width, size.height - 90)
      ..lineTo(size.width, size.height - 60)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class WhiteLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 253, 248, 251)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, size.height - 35)
      ..lineTo(size.width, size.height - 65)
      ..lineTo(size.width, size.height - 35)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}