import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neon_button.dart';
import '../../widgets/xp_animation_widget.dart';

class EventArenaView extends StatefulWidget {
  const EventArenaView({super.key});
  @override
  State<EventArenaView> createState() => _EventArenaViewState();
}

class _EventArenaViewState extends State<EventArenaView> {
  final QueryDocumentSnapshot event = Get.arguments;
  late Timer _timer;
  int _eventTimeLeft = 0;
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;
  bool _showXpAnimation = false;

  @override
  void initState() {
    super.initState();
    _eventTimeLeft = (event['durationInMinutes'] as int? ?? 5) * 60;
    _loadQuestions();
    _startTimer();
  }

  void _loadQuestions() {
    if (event.data() != null && (event.data() as Map).containsKey('questions')) {
      final List<dynamic> questionsData = event['questions'];
      setState(() {
        _questions = List<Map<String, dynamic>>.from(questionsData);
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_eventTimeLeft == 0) {
        _timer.cancel();
        _submitFinalScore();
      } else {
        setState(() => _eventTimeLeft--);
      }
    });
  }

  void _answerQuestion(String selectedAnswer) {
    if (_currentQuestionIndex >= _questions.length) return;

    final question = _questions[_currentQuestionIndex];
    if (selectedAnswer == question['correctAnswer']) {
      // Correct Answer: Calculate and add points
      final int pointsPerQuestion = ((event['totalXp'] as int? ?? 100) / _questions.length).round();
      _score += pointsPerQuestion;
    } else {
      // THIS IS THE FIX: Show a snackbar for incorrect answers
      Get.snackbar(
        'Incorrect!',
        'That was not the right answer.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
    }

    if (_currentQuestionIndex == _questions.length - 1) {
      _timer.cancel();
      // Add a small delay before submitting to allow the user to see the last result
      Future.delayed(const Duration(milliseconds: 500), _submitFinalScore);
    } else {
      setState(() => _currentQuestionIndex++);
    }
  }

  Future<void> _submitFinalScore() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    // Trigger the XP animation to show the total score
    setState(() => _showXpAnimation = true);

    final int totalDuration = (event['durationInMinutes'] as int? ?? 5) * 60;
    final int timeTaken = totalDuration - _eventTimeLeft;
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    // Use a transaction to safely award XP and record participation
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // 1. READ FIRST: Get the current user's data.
      final userDoc = await transaction.get(userRef);
      if (!userDoc.exists) {
        throw Exception("User document does not exist!");
      }

      // 2. PREPARE WRITES
      // a) Prepare to write the participant score for the event leaderboard
      final participantRef = FirebaseFirestore.instance.collection('events').doc(event.id).collection('participants').doc(userId);
      transaction.set(participantRef, {
        'name': userDoc.data()?['name'] ?? 'Anonymous',
        'score': _score, // The final calculated score
        'completionTimeSeconds': timeTaken,
        'submittedAt': Timestamp.now(),
      });

      // b) Prepare to update the user's total XP on their main profile
      final currentXp = userDoc.data()?['xp'] ?? 0;
      transaction.update(userRef, {'xp': currentXp + _score});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_questions.isEmpty) return const Scaffold(body: Center(child: Text('No questions found for this event.')));

    final currentQuestion = _questions[_currentQuestionIndex];
    final options = List<String>.from(currentQuestion['options']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Timer: $_eventTimeLeft s | Score: $_score'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Question ${_currentQuestionIndex + 1}/${_questions.length}', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Text(currentQuestion['question'], style: Theme.of(context).textTheme.headlineSmall),
                const Divider(height: 30),
                ...options.map((option) => Card(
                  child: ListTile(
                    title: Text(option),
                    onTap: () => _answerQuestion(option),
                  ),
                )),
              ],
            ),
          ),
          if (_showXpAnimation)
            XpAnimationWidget(
              points: _score, // Show the final score earned
              onComplete: () {
                if (mounted) {
                  Get.back();
                  Get.snackbar('Event Over!', 'Your final score is $_score. You earned $_score XP!');
                }
              },
            ),
        ],
      ),
    );
  }
}