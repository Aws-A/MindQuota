import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditQuestionPage extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> questionData;

  EditQuestionPage({required this.docId, required this.questionData});

  @override
  _EditQuestionPageState createState() => _EditQuestionPageState();
}

class _EditQuestionPageState extends State<EditQuestionPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController questionController;
  late TextEditingController imageUrlController;
  late TextEditingController option1Controller;
  late TextEditingController option2Controller;
  late TextEditingController option3Controller;
  late TextEditingController option4Controller;

  int? selectedAnswerIndex;
  String? selectedTopic;

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

  final Color baseColor = Color(0xFF2B4162);
  final Color activeColor = Color(0xFF118AB2);

  @override
  void initState() {
    super.initState();

    questionController = TextEditingController(text: widget.questionData['question']);
    imageUrlController = TextEditingController(text: widget.questionData['imageUrl'] ?? '');

    List options = widget.questionData['options'];
    option1Controller = TextEditingController(text: options[0]);
    option2Controller = TextEditingController(text: options[1]);
    option3Controller = TextEditingController(text: options[2]);
    option4Controller = TextEditingController(text: options[3]);

    selectedTopic = widget.questionData['topic'];
    selectedAnswerIndex = options.indexOf(widget.questionData['answer']);
  }

  InputDecoration _underlineInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: baseColor),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: activeColor, width: 2),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: baseColor),
      ),
    );
  }

  void _updateQuestion() async {
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

    Map<String, dynamic> updatedQuestion = {
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
      await _firestore.collection("custom_questions").doc(widget.docId).update(updatedQuestion);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Question updated successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating question: $e")),
      );
    }
  }

  @override
  void dispose() {
    questionController.dispose();
    imageUrlController.dispose();
    option1Controller.dispose();
    option2Controller.dispose();
    option3Controller.dispose();
    option4Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   backgroundColor: Colors.white,  // Set the background color of the whole page
   appBar: AppBar(
      title: Text(
        "Edit Question",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: questionController,
                style: TextStyle(color: baseColor),
                decoration: _underlineInputDecoration("Enter your question"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: imageUrlController,
                style: TextStyle(color: baseColor),
                decoration: _underlineInputDecoration("Image URL (optional)"),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: _underlineInputDecoration("Select a Topic"),
                value: selectedTopic,
                dropdownColor: Colors.white,
                style: TextStyle(color: baseColor),
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
                "Edit answer choices and select the correct one:",
                style: TextStyle(color: baseColor),
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
                        style: TextStyle(color: baseColor),
                        decoration: _underlineInputDecoration("Option ${i + 1}"),
                      ),
                    ),
                    Radio<int>(
                      value: i,
                      groupValue: selectedAnswerIndex,
                      activeColor: activeColor,
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
                    onPressed: _updateQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      "Update Question",
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