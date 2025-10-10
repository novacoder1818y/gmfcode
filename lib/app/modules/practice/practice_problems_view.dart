// lib/modules/practice/practice_problems_view.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import 'practice_controller.dart';

class PracticeProblemsView extends GetView<PracticeController> {
  const PracticeProblemsView({super.key});

  @override
  Widget build(BuildContext context) {
    final String categoryId = Get.arguments['categoryId'] ?? '';
    final String languageName = Get.arguments['languageName'] ?? 'Problems';

    return Scaffold(
      appBar: AppBar(
        title: Text('$languageName Problems'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.getProblemsStream(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No problems found for this category yet.'));
          }

          final problemList = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: problemList.length,
            itemBuilder: (context, index) {
              final problem = problemList[index].data() as Map<String, dynamic>;
              final difficulty = problem['difficulty'] ?? 'N/A';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(problem['title'] ?? 'No Title'),
                  subtitle: Text(
                    difficulty,
                    style: TextStyle(
                      color: difficulty == 'Easy'
                          ? Colors.greenAccent
                          : (difficulty == 'Medium'
                          ? Colors.orangeAccent
                          : Colors.redAccent),
                    ),
                  ),
                  trailing: const Icon(Icons.play_circle_outline_rounded, color: AppTheme.accentColor),
                  onTap: () {
                    // Later, you can navigate to a code editor view
                    Get.snackbar('Coming Soon!', 'The code editor for this problem is not yet implemented.');
                  },
                ),
              ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.5, end: 0);
            },
          );
        },
      ),
    );
  }
}