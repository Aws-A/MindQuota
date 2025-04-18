import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_question.dart'; // Make sure this import matches your file structure

class SubmittedQuestionsPage extends StatefulWidget {
  @override
  _SubmittedQuestionsPageState createState() => _SubmittedQuestionsPageState();
}

class _SubmittedQuestionsPageState extends State<SubmittedQuestionsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _confirmQuestion(String docId, Map<String, dynamic> questionData) async {
    try {
      await _firestore.collection('general_questions').add(questionData);

      String topic = (questionData['topic'] ?? '').toString();
      String collectionName = _getTopicCollectionName(topic);

      if (collectionName.isNotEmpty) {
        await _firestore.collection(collectionName).add(questionData);
      }

      await _firestore.collection('custom_questions').doc(docId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Question confirmed and routed by topic!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  String _getTopicCollectionName(String topic) {
    switch (topic.trim()) {
      case 'Arts':
        return 'arts_questions';
      case 'Business & Economics':
        return 'business&economics_questions';
      case 'Geography':
        return 'geography_questions';
      case 'History':
        return 'history_questions';
      case 'Language & Communication':
        return 'language&communication_questions';
      case 'Science & Technology':
        return 'science&technology_questions';
      case 'Social Sciences':
        return 'social-sciences_questions';
      case 'Sports & Recreation':
        return 'sports&recreation_questions';
      default:
        return '';
    }
  }

  Future<void> _deleteQuestion(String docId) async {
    try {
      await _firestore.collection('custom_questions').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Question deleted!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Review Submitted Questions")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('custom_questions').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error loading questions"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No submitted questions"));
          }

          var questions = snapshot.data!.docs;

          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              var question = questions[index];
              var questionData = question.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  title: Text(
                    questionData['question'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (questionData['options'] as List<dynamic>).map((option) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Text("• $option"),
                        );
                      }).toList(),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check_circle, color: Colors.green, size: 30),
                        onPressed: () => _confirmQuestion(question.id, questionData),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue, size: 30),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditQuestionPage(
                                docId: question.id,
                                questionData: questionData,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red, size: 30),
                        onPressed: () => _deleteQuestion(question.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}