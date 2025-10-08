import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';
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

  void _submitAnswer() {
    setState(() => _isAnswered = true);
    final isCorrect = _selectedOption == challenge['correctAnswer'];

    if (isCorrect) {
      _updateUserXP();
      Get.snackbar('Correct!', '+${challenge['points']} XP Earned!', backgroundColor: Colors.green);
    } else {
      Get.snackbar('Incorrect', 'Try again next time!', backgroundColor: Colors.red);
    }
  }

  Future<void> _updateUserXP() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    // Use a transaction to safely update XP and mark challenge as complete
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userRef);
      if (!userSnapshot.exists) return;

      final currentXp = userSnapshot.data()?['xp'] ?? 0;
      final newXp = currentXp + (challenge['points'] as int);

      // Update XP in user document
      transaction.update(userRef, {'xp': newXp});

      // Mark challenge as completed in subcollection
      final completedRef = userRef.collection('completedChallenges').doc(challenge.id);
      transaction.set(completedRef, {
        'completedAt': Timestamp.now(),
        'pointsEarned': challenge['points'],
      });
    });

    // Refresh the local state
    challengesController.completedChallenges.add(challenge.id);
  }

  @override
  Widget build(BuildContext context) {
    final options = List<String>.from(challenge['options']);
    final bool hasCompleted = challengesController.hasCompleted(challenge.id);

    return Scaffold(
      appBar: AppBar(title: Text(challenge['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(challenge['description'], style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            Text('Points: ${challenge['points']} | Difficulty: ${challenge['difficulty']}',
                style: const TextStyle(color: AppTheme.accentColor)),
            const Divider(height: 30),
            ...options.map((option) {
              Color? tileColor;
              if (_isAnswered) {
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
                  onChanged: _isAnswered || hasCompleted
                      ? null // Disable if already answered or completed
                      : (value) => setState(() => _selectedOption = value),
                ),
              );
            }),
            const Spacer(),
            if (hasCompleted)
              const Center(child: Text('You have already completed this challenge!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
            if (!hasCompleted)
              Center(
                child: ElevatedButton(
                  onPressed: _selectedOption == null || _isAnswered ? null : _submitAnswer,
                  child: const Text('Submit Answer'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
