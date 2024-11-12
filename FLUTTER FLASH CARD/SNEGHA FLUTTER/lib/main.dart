import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        backgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FlashcardScreen(),
    );
  }
}

class Flashcard {
  String question;
  String answer;
  String difficulty;

  Flashcard({
    required this.question,
    required this.answer,
    required this.difficulty,
  });
}

class FlashcardScreen extends StatefulWidget {
  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  List<Flashcard> flashcards = [];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  String selectedDifficulty = 'Medium'; // Default difficulty level

  // Method to add or edit flashcards
  void _addOrEditFlashcard({int? index}) {
    questionController.text = index != null ? flashcards[index].question : '';
    answerController.text = index != null ? flashcards[index].answer : '';
    selectedDifficulty =
        index != null ? flashcards[index].difficulty : 'Medium';

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: questionController,
                decoration: InputDecoration(
                  labelText: 'Question',
                  filled: true,
                  fillColor: Colors.blue[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Question cannot be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: answerController,
                decoration: InputDecoration(
                  labelText: 'Answer',
                  filled: true,
                  fillColor: Colors.blue[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Answer cannot be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedDifficulty,
                decoration: InputDecoration(
                  labelText: 'Difficulty Level',
                  filled: true,
                  fillColor: Colors.blue[50],
                ),
                items: ['Easy', 'Medium', 'Hard'].map((String difficulty) {
                  return DropdownMenuItem<String>(
                    value: difficulty,
                    child: Text(difficulty),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDifficulty = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      if (index == null) {
                        flashcards.add(Flashcard(
                          question: questionController.text,
                          answer: answerController.text,
                          difficulty: selectedDifficulty,
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Flashcard added!')),
                        );
                      } else {
                        flashcards[index] = Flashcard(
                          question: questionController.text,
                          answer: answerController.text,
                          difficulty: selectedDifficulty,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Flashcard updated!')),
                        );
                      }
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text(index == null ? 'Add Flashcard' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
    );
  }

  // Method to delete a flashcard
  void _deleteFlashcard(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Flashcard"),
        content: Text("Are you sure you want to delete this flashcard?"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
            child: Text("Delete"),
            onPressed: () {
              setState(() {
                flashcards.removeAt(index);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Flashcard deleted!')),
              );
            },
          ),
        ],
      ),
    );
  }

  // Method to show answer dialog
  void _showAnswerDialog(String question, String answer, String difficulty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Flashcard Answer'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Question: $question',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Difficulty: $difficulty',
                style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            Text('Answer: $answer',
                style: TextStyle(fontSize: 18, color: Colors.indigo)),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Close", style: TextStyle(color: Colors.indigo)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Building the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard App'),
        backgroundColor: Colors.indigo,
      ),
      body: flashcards.isEmpty
          ? Center(
              child: Text(
                "No flashcards available. Tap + to add.",
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: flashcards.length,
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.indigo[50],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      flashcards[index].question,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    subtitle:
                        Text('Difficulty: ${flashcards[index].difficulty}'),
                    onTap: () {
                      _showAnswerDialog(
                          flashcards[index].question,
                          flashcards[index].answer,
                          flashcards[index].difficulty);
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.teal),
                          onPressed: () => _addOrEditFlashcard(index: index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _deleteFlashcard(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEditFlashcard(),
        label: Text('Add Flashcard'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.white,
    );
  }
}
