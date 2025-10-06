// lib/app/modules/event/event_view.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../theme/app_theme.dart';
import '../../widgets/leaderboard_card.dart';
import '../../widgets/neon_button.dart';

// Enum to manage the state of the event screen
enum EventState { countdown, inProgress, finished }

class EventView extends StatefulWidget {
  const EventView({super.key});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  final eventState = EventState.countdown.obs;
  late Timer _timer;
  Duration _countdownDuration = const Duration(minutes: 5, seconds: 30);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownDuration.inSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          _countdownDuration -= const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Code Clash')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          switch (eventState.value) {
            case EventState.countdown:
              return _buildCountdownView();
            case EventState.inProgress:
              return _buildQnaView();
            case EventState.finished:
              return _buildLeaderboardView();
          }
        }),
      ),
    );
  }

  /// The view shown before the event starts.
  Widget _buildCountdownView() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(_countdownDuration.inMinutes.remainder(60));
    final seconds = twoDigits(_countdownDuration.inSeconds.remainder(60));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'EVENT STARTS IN',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 20),
        Text(
          '$minutes:$seconds',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: AppTheme.accentColor,
            fontWeight: FontWeight.bold,
            shadows: [
              const Shadow(blurRadius: 20, color: AppTheme.accentColor),
            ],
          ),
        ),
        const SizedBox(height: 40),
        NeonButton(
          text: 'Join Event',
          onTap: () => eventState.value = EventState.inProgress,
          gradientColors: const [AppTheme.accentColor, AppTheme.tertiaryColor],
        ),
      ],
    );
  }

  /// The view shown during the event.
  Widget _buildQnaView() {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 80.0,
          lineWidth: 12.0,
          animation: true,
          percent: 0.4, // Mock progress: 2 out of 5 questions
          center: Text(
            "2 / 5",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: AppTheme.secondaryColor,
          backgroundColor: AppTheme.primaryColor.withOpacity(0.5),
        ),
        const SizedBox(height: 30),
        const Text(
          "Question 3: What is the output of `print(2 + '2')` in Python?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 30),
        // Add answer options here
        const Spacer(),
        NeonButton(
          text: 'Finish',
          onTap: () => eventState.value = EventState.finished,
          gradientColors: const [Colors.red, Colors.orange],
        ),
      ],
    );
  }

  /// The view shown after the event ends.
  Widget _buildLeaderboardView() {
    return Column(
      children: [
        Text("Event Finished!", style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 10),
        const Text("Here are the results:"),
        const SizedBox(height: 20),
        const Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                LeaderboardCard(rank: 1, name: 'Player One', xp: 500, isTopThree: true),
                LeaderboardCard(rank: 2, name: 'CodeNinja', xp: 450, isTopThree: true),
                LeaderboardCard(rank: 3, name: 'DebugDiva', xp: 420, isTopThree: true),
                LeaderboardCard(rank: 4, name: 'ScriptKid', xp: 300, isTopThree: true,),
              ],
            ),
          ),
        )
      ],
    );
  }
}


