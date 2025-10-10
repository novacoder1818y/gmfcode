// lib/modules/practice/practice_view.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../widgets/language_card.dart';
import 'practice_controller.dart';

class PracticeView extends GetView<PracticeController> {
  const PracticeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Practice Arena")),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.getCategoriesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No practice categories found.'));
          }
          final categories = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index].data() as Map<String, dynamic>;

              return LanguageCard(
                name: category['name'] ?? 'Unnamed',
                onTap: () {
                  // Navigate to the problems screen for this category
                  Get.toNamed(
                    Routes.PRACTICE_PROBLEMS,
                    arguments: {
                      'categoryId': categories[index].id, // Pass the document ID
                      'languageName': category['name'],
                    },
                  );
                }, iconPath: '',
              ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2);
            },
          );
        },
      ),
    );
  }
}