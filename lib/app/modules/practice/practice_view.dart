import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../widgets/language_card.dart';
// ... other imports

class PracticeView extends StatelessWidget {
  const PracticeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Practice Arena")),
      // Use a StreamBuilder to get real-time updates from Firestore
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('practiceCategories').orderBy('order').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final categories = snapshot.data!.docs;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              // Assuming you have a LanguageCard widget
              return LanguageCard(
                name: category['name'],
                iconPath: category['icon'],
                // onTap: () {
                //   // Navigate to a new screen that shows content for this category.categoryId
                // },
              );
            },
          );
        },
      ),
    );
  }
}