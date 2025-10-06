import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neon_button.dart';

class ChallengeDetailView extends StatelessWidget {
  const ChallengeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real app, you'd pass a Challenge object
    final String category = Get.arguments['category'] ?? 'Coding';
    final String title = Get.arguments['title'] ?? 'Challenge';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: $category', style: TextStyle(color: AppTheme.accentColor)),
            const SizedBox(height: 20),
            _buildChallengeContent(category),
            const SizedBox(height: 40),
            NeonButton(
              text: 'Submit',
              onTap: () => Get.back(),
              gradientColors: [AppTheme.accentColor, AppTheme.tertiaryColor],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeContent(String category) {
    switch (category) {
      case 'MCQ':
        return _buildMcqContent();
      case 'Puzzle':
        return _buildPuzzleContent();
      case 'Coding':
      default:
        return _buildCodingContent();
    }
  }

  Widget _buildMcqContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What is the time complexity of a binary search algorithm?",
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        RadioListTile(title: Text("O(n)"), value: 1, groupValue: 0, onChanged: (v){}),
        RadioListTile(title: Text("O(log n)"), value: 2, groupValue: 0, onChanged: (v){}),
        RadioListTile(title: Text("O(n^2)"), value: 3, groupValue: 0, onChanged: (v){}),
      ],
    );
  }

  Widget _buildPuzzleContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Drag and drop the code blocks to form a correct 'for' loop that prints numbers from 1 to 5.",
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.tertiaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(child: Text("[Drop Zone for Puzzle Pieces]")),
        ),
      ],
    );
  }

  Widget _buildCodingContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Write a function in Python that takes a string as input and returns its reverse.",
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        TextField(
          maxLines: 10,
          style: GoogleFonts.sourceCodePro(),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black.withOpacity(0.3),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: 'def reverse_string(s):\n  # Your code here',
          ),
        ),
      ],
    );
  }
}

