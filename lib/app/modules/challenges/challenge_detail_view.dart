import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neon_button.dart';
import '../../widgets/xp_animation_widget.dart';
import 'challenges_controller.dart';

class ChallengeDetailView extends StatefulWidget {
  const ChallengeDetailView({super.key});
  @override
  State<ChallengeDetailView> createState() => _ChallengeDetailViewState();
}

class _ChallengeDetailViewState extends State<ChallengeDetailView> {
  final QueryDocumentSnapshot challenge = Get.arguments;
  final ChallengesController challengesController = Get.find();

  String? _selectedOption;
  bool _isAnswered = false;
  bool _showXpAnimation = false;

  /// Submits the user's answer and handles the outcome.
  void _submitAnswer() {
    setState(() => _isAnswered = true);
    final isCorrect = _selectedOption == challenge['correctAnswer'];

    if (isCorrect) {
      _updateUserXPAndMarkComplete();
    } else {
      Get.snackbar(
        'Incorrect',
        'That was not the right answer. Feel free to try again later!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      // After a short delay, go back to the list
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Get.back();
      });
    }
  }

  /// Updates user XP and marks the challenge as complete in Firestore.
  Future<void> _updateUserXPAndMarkComplete() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final int points = challenge['points'];

    setState(() => _showXpAnimation = true); // Trigger the XP animation

    // Use a transaction for safety
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userRef);
      if (!userSnapshot.exists) return;

      final currentXp = userSnapshot.data()?['xp'] ?? 0;
      final newXp = currentXp + points;

      transaction.update(userRef, {'xp': newXp});

      final completedRef = userRef.collection('completedChallenges').doc(challenge.id);
      transaction.set(completedRef, {
        'completedAt': Timestamp.now(),
        'pointsEarned': points,
      });
    });

    // Update the local state in the controller
    challengesController.markAsCompleted(challenge.id);
  }

  @override
  Widget build(BuildContext context) {
    final options = List<String>.from(challenge['options']);
    // Check completion status directly from the controller
    final bool hasCompleted = challengesController.hasCompleted(challenge.id);

    return Scaffold(
      appBar: AppBar(title: Text(challenge['title'])),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(challenge['description'], style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 20),
                Text('Points: ${challenge['points']} | Difficulty: ${challenge['difficulty']}', style: const TextStyle(color: AppTheme.accentColor)),
                const Divider(height: 30),
                ...options.map((option) {
                  Color? tileColor;
                  if (_isAnswered) { // Show feedback only after an answer is submitted
                    if (option == challenge['correctAnswer']) {
                      tileColor = Colors.green.withOpacity(0.3);
                    } else if (option == _selectedOption) {
                      tileColor = Colors.red.withOpacity(0.3);
                    }
                  }

                  return Card(
                    color: tileColor,
                    child: RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: _selectedOption,
                      // Disable selection if the challenge is already done or answered
                      onChanged: _isAnswered || hasCompleted ? null : (value) => setState(() => _selectedOption = value),
                    ),
                  );
                }),
                const Spacer(),
                if (hasCompleted)
                  const Center(child: Text('You have already completed this challenge!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)))
                else
                  Center(
                    child: NeonButton(
                      onTap: _selectedOption == null || _isAnswered ? () {} : _submitAnswer,
                      text: 'Submit Answer',
                      gradientColors: const [AppTheme.accentColor, AppTheme.primaryColor],
                    ),
                  ),
              ],
            ),
          ),
          // Conditionally show the XP animation overlay
          if (_showXpAnimation)
            XpAnimationWidget(
              points: challenge['points'],
              onComplete: () {
                // When the animation finishes, go back to the challenges list
                if (mounted) Get.back();
              },
            ),
        ],
      ),
    );
  }
}
