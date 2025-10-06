import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../widgets/language_card.dart';

class PracticeView extends StatelessWidget {
  const PracticeView({super.key});

  @override
  Widget build(BuildContext context) {
    final languages = [
      LanguageCard(name: 'Python', iconPath: '🐍'),
      LanguageCard(name: 'JavaScript', iconPath: '📜'),
      LanguageCard(name: 'Java', iconPath: '☕'),
      LanguageCard(name: 'C++', iconPath: '++'),
      LanguageCard(name: 'Flutter', iconPath: '🐦'),
      LanguageCard(name: 'HTML', iconPath: '🌐'),
    ];

    return Scaffold(
        appBar: AppBar(title: Text("Practice Arena")),
        body: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: languages.length,
          itemBuilder: (context, index) {
            return languages[index]
                .animate()
                .fadeIn(delay: (100 * index).ms)
                .scale(begin: Offset(0.8, 0.8));
          },
        )
    );
  }
}