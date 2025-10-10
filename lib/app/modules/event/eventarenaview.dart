import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/xp_animation_widget.dart'; // Make sure this widget exists

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
      setState(() {
        _questions = List<Map<String, dynamic>>.from(event['questions']);
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
      final int pointsPerQuestion = ((event['totalXp'] as int? ?? 100) / _questions.length).round();
      _score += pointsPerQuestion;
    }

    if (_currentQuestionIndex == _questions.length - 1) {
      _timer.cancel();
      _submitFinalScore();
    } else {
      setState(() => _currentQuestionIndex++);
    }
  }

  Future<void> _submitFinalScore() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    // Show XP animation before starting the database transaction
    setState(() => _showXpAnimation = true);

    final int totalDuration = (event['durationInMinutes'] as int? ?? 5) * 60;
    final int timeTaken = totalDuration - _eventTimeLeft;
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    // THIS IS THE FIX: Reads must happen before writes in a transaction.
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // 1. READ FIRST: Get the current user's data.
      final userDoc = await transaction.get(userRef);
      if (!userDoc.exists) {
        throw Exception("User document does not exist!");
      }

      // 2. PREPARE WRITES
      // a) Prepare to write the participant score
      final participantRef = FirebaseFirestore.instance.collection('events').doc(event.id).collection('participants').doc(userId);
      transaction.set(participantRef, {
        'name': userDoc.data()?['name'] ?? 'Anonymous',
        'score': _score,
        'completionTimeSeconds': timeTaken,
        'submittedAt': Timestamp.now(),
      });

      // b) Prepare to update the user's total XP
      final currentXp = userDoc.data()?['xp'] ?? 0;
      final eventXp = event['totalXp'] as int? ?? 0;
      transaction.update(userRef, {'xp': currentXp + eventXp});
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
              points: event['totalXp'],
              onComplete: () {
                if (mounted) {
                  Get.back();
                  Get.snackbar('Event Over!', 'Your final score is $_score. You earned ${event['totalXp']} XP!');
                }
              },
            ),
        ],
      ),
    );
  }
}