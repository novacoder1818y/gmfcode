import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Code Feed')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPostCard(
            title: 'Top 5 VS Code Extensions for Flutter Devs',
            author: 'By FlutterGems',
            content: 'Boost your productivity with these must-have extensions for Visual Studio Code...',
          ),
          _buildPostCard(
            title: 'Understanding Big O Notation Simply',
            author: 'By AlgoExplained',
            content: 'Demystify algorithm complexity. A beginner-friendly guide to Big O notation with examples.',
          ),
          _buildPostCard(
            title: 'What\'s New in Dart 3?',
            author: 'By DartNews',
            content: 'Explore the latest features like patterns, records, and class modifiers introduced in Dart 3.',
          ),
        ].animate(interval: 100.ms).fadeIn().slideY(begin: 0.2),
      ),
    );
  }

  Widget _buildPostCard({required String title, required String author, required String content}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Get.theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(author, style: TextStyle(color: Get.theme.colorScheme.secondary, fontStyle: FontStyle.italic)),
            const SizedBox(height: 12),
            Text(content, style: Get.theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: (){}, child: Text('Read More...'))
            ),
          ],
        ),
      ),
    );
  }
}
