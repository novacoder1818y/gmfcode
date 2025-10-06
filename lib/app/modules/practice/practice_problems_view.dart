// FILE: lib/app/modules/practice/practice_problems_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';

class PracticeProblemsView extends StatelessWidget {
  const PracticeProblemsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the language name passed from the previous screen
    final String languageName = Get.arguments as String? ?? 'Problems';

    // Dummy data for practice problems
    final Map<String, List<Map<String, String>>> problems = {
      'Python': [
        {'title': 'Reverse a String', 'difficulty': 'Easy'},
        {'title': 'Find the Fibonacci Number', 'difficulty': 'Medium'},
        {'title': 'Two Sum Problem', 'difficulty': 'Easy'},
      ],
      'JavaScript': [
        {'title': 'Implement a Promise', 'difficulty': 'Hard'},
        {'title': 'FizzBuzz', 'difficulty': 'Easy'},
      ],
      // Add more problems for other languages...
    };

    final problemList = problems[languageName] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('$languageName Problems'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: problemList.length,
        itemBuilder: (context, index) {
          final problem = problemList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(problem['title']!),
              subtitle: Text(
                problem['difficulty']!,
                style: TextStyle(
                  color: problem['difficulty'] == 'Easy'
                      ? Colors.greenAccent
                      : (problem['difficulty'] == 'Medium'
                      ? Colors.orangeAccent
                      : Colors.redAccent),
                ),
              ),
              trailing: const Icon(Icons.play_circle_outline_rounded, color: AppTheme.accentColor),
              onTap: () {
                // Navigate to the actual coding challenge screen
                Get.snackbar('Coming Soon!', 'The code editor for this problem is not yet implemented.');
              },
            ),
          )
              .animate()
              .fadeIn(delay: (100 * index).ms)
              .slideX(begin: 0.5, end: 0);
        },
      ),
    );
  }
}