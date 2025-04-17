import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'submitted_questions.dart';

class NewQuestionPage extends StatefulWidget {
  @override
  _NewQuestionPageState createState() => _NewQuestionPageState();
}

class _NewQuestionPageState extends State<NewQuestionPage> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController option1Controller = TextEditingController();
  final TextEditingController option2Controller = TextEditingController();
  final TextEditingController option3Controller = TextEditingController();
  final TextEditingController option4Controller = TextEditingController();

  int? selectedAnswerIndex;
  String? selectedTopic;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> topics = [
    'Language & Communication',
    'History',
    'Geography',
    'Social Sciences',
    'Science & Technology',
    'Business & Economics',
    'Arts',
    'Sports & Recreation',
  ];

  InputDecoration _underlineDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color(0xFF2B4162)),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF2B4162)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF118AB2), width: 2),
      ),
    );
  }

  void _submitQuestion() async {
    if (questionController.text.isEmpty ||
        option1Controller.text.isEmpty ||
        option2Controller.text.isEmpty ||
        option3Controller.text.isEmpty ||
        option4Controller.text.isEmpty ||
        selectedAnswerIndex == null ||
        selectedTopic == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields and select an answer and topic")),
      );
      return;
    }

    Map<String, dynamic> newQuestion = {
      "question": questionController.text,
      "imageUrl": imageUrlController.text,
      "topic": selectedTopic,
      "options": [
        option1Controller.text,
        option2Controller.text,
        option3Controller.text,
        option4Controller.text
      ],
      "answer": [
        option1Controller.text,
        option2Controller.text,
        option3Controller.text,
        option4Controller.text
      ][selectedAnswerIndex!]
    };

    try {
      await _firestore.collection("custom_questions").add(newQuestion);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Question added successfully!")),
      );
      _clearFields();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving question: $e")),
      );
    }
  }

  void _clearFields() {
    questionController.clear();
    imageUrlController.clear();
    option1Controller.clear();
    option2Controller.clear();
    option3Controller.clear();
    option4Controller.clear();
    setState(() {
      selectedAnswerIndex = null;
      selectedTopic = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("New Question"),
            IconButton(
              icon: Icon(Icons.assignment, size: 32),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubmittedQuestionsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: questionController,
                style: TextStyle(color: Color(0xFF2B4162)),
                decoration: _underlineDecoration("Enter your question"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: imageUrlController,
                style: TextStyle(color: Color(0xFF2B4162)),
                decoration: _underlineDecoration("Image URL (optional)"),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: _underlineDecoration("Select a Topic"),
                value: selectedTopic,
                dropdownColor: Colors.white,
                style: TextStyle(color: Color(0xFF2B4162)),
                items: topics.map((topic) {
                  return DropdownMenuItem<String>(
                    value: topic,
                    child: Text(topic),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTopic = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                "Enter answer choices and select the correct one:",
                style: TextStyle(color: Color(0xFF2B4162)),
              ),
              for (int i = 0; i < 4; i++)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: [
                          option1Controller,
                          option2Controller,
                          option3Controller,
                          option4Controller
                        ][i],
                        style: TextStyle(color: Color(0xFF2B4162)),
                        decoration: _underlineDecoration("Option ${i + 1}"),
                      ),
                    ),
                    Radio<int>(
                      value: i,
                      groupValue: selectedAnswerIndex,
                      activeColor: Color(0xFF118AB2),
                      onChanged: (int? value) {
                        setState(() {
                          selectedAnswerIndex = value;
                        });
                      },
                    ),
                  ],
                ),
              SizedBox(height: 25),
              Center(
                child: SizedBox(
                  width: 260,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _submitQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF118AB2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      "Submit Question",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}