import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../widgets/challenge_card.dart';

class ChallengesView extends StatelessWidget {
  const ChallengesView({super.key});

  @override
  Widget build(BuildContext context) {
    final challenges = [
      const ChallengeCard(
        title: 'Variable Declarations',
        category: 'Coding',
        progress: 1.0,
        tags: ['Easy', 'Variables'],
      ),
      const ChallengeCard(
        title: 'Loop Masters',
        category: 'Puzzle',
        progress: 0.6,
        tags: ['Medium', 'Loops'],
      ),
      const ChallengeCard(
        title: 'Algorithm Basics',
        category: 'MCQ',
        progress: 0.0,
        tags: ['Easy', 'Algorithms'],
      ),
      const ChallengeCard(
        title: 'Recursive Thinking',
        category: 'Coding',
        progress: 0.2,
        tags: ['Hard', 'Recursion'],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coding Challenges'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          return challenges[index]
              .animate()
              .fadeIn(delay: (100 * index).ms)
              .slideX(begin: -0.2, end: 0);
        },
      ),
    );
  }
}
