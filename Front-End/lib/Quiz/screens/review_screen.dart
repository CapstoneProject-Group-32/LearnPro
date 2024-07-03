import 'package:flutter/material.dart';
import '../models/question.dart';

class QuestionReviewScreen extends StatelessWidget {
  final Question question;
  final int? selectedOption;
  final index;

  const QuestionReviewScreen(
      {super.key,
      required this.question,
      required this.selectedOption,
      required this.index});

  @override
  Widget build(BuildContext context) {
    final qnum = index + 1;
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Question',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question $qnum',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question.questionText,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          ...question.options.asMap().entries.map((entry) {
                            final index = entry.key;
                            final option = entry.value;
                            Color optionColor;
                            if (index.toString() == question.correctOptionIndex) {
                              optionColor = Colors.green;
                            } else if (index == selectedOption) {
                              optionColor = Colors.red;
                            } else {
                              optionColor = const Color.fromARGB(255, 94, 94, 94);
                            }
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: optionColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Radio<int>(
                                    value: index,
                                    groupValue: selectedOption,
                                    onChanged: null, // Disable interaction
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: optionColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  
                ],
              ),
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.background,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                      ),
                      child: Text(
                        'Back to Results',
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
            )
        ],
      ),
    );
  }
}
