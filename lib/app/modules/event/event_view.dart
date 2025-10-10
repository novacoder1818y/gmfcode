import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../routes/app_pages.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neon_button.dart';
import 'event_controller.dart';

class EventView extends GetView<EventsController> {
  const EventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Events')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.eventsList.isEmpty) {
          return const Center(child: Text('No events scheduled right now.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.eventsList.length,
          itemBuilder: (context, index) {
            final event = controller.eventsList[index];
            return EventCard(event: event);
          },
        );
      }),
    );
  }
}

class EventCard extends StatefulWidget {
  final QueryDocumentSnapshot event;
  const EventCard({super.key, required this.event});
  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  Timer? _timer;
  Duration _timeUntilStart = Duration.zero;
  bool _hasParticipated = false;
  bool _isCheckingParticipation = true;

  @override
  void initState() {
    super.initState();
    _checkParticipationStatus();
    _updateTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTimer());
  }

  // THIS IS THE NEW LOGIC TO CHECK IF THE USER HAS ALREADY PLAYED
  Future<void> _checkParticipationStatus() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      if (mounted) setState(() => _isCheckingParticipation = false);
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('events').doc(widget.event.id)
        .collection('participants').doc(userId).get();

    if (mounted) {
      setState(() {
        _hasParticipated = doc.exists;
        _isCheckingParticipation = false;
      });
    }
  }

  void _updateTimer() {
    if (mounted) {
      final startTime = (widget.event['startDate'] as Timestamp).toDate();
      final difference = startTime.difference(DateTime.now());
      setState(() {
        _timeUntilStart = difference.isNegative ? Duration.zero : difference;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.event.data() as Map<String, dynamic>;
    final startTime = (data['startDate'] as Timestamp).toDate();
    final duration = Duration(minutes: data['durationInMinutes'] as int? ?? 0);
    final endTime = startTime.add(duration);
    final bool isEventOver = DateTime.now().isAfter(endTime);

    final bool canJoin = _timeUntilStart > Duration.zero && _timeUntilStart <= const Duration(minutes: 5);
    final bool isLive = DateTime.now().isAfter(startTime) && !isEventOver;

    String countdownText;
    if (isLive) {
      countdownText = 'Event is live!';
    } else if (_timeUntilStart > Duration.zero) {
      countdownText = 'Starts in: ${_timeUntilStart.toString().split('.').first.padLeft(8, "0")}';
    } else {
      countdownText = 'Event has ended.';
    }

    // --- DYNAMIC ACTION BUTTON LOGIC ---
    Widget actionButton;
    if (_isCheckingParticipation) {
      actionButton = const SizedBox(height: 40, child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    } else if (_hasParticipated || isEventOver) {
      // If user has participated OR the event is over, show "View Results"
      actionButton = NeonButton(
        onTap: () => Get.toNamed(Routes.EVENT_LEADERBOARD, arguments: {
          'eventId': widget.event.id,
          'eventTitle': data['title'],
        }),
        text: 'View Results',
        gradientColors: const [AppTheme.secondaryColor, Colors.purpleAccent],
      );
    } else {
      // Otherwise, show the Join/Not Started button
      actionButton = NeonButton(
        onTap: (canJoin || isLive) ? () => Get.toNamed(Routes.EVENT_ARENA, arguments: widget.event) : null,
        text: (canJoin || isLive) ? 'Join Event' : 'Not Started Yet',
        gradientColors: const [Colors.green, Colors.teal],
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data['title'], style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(data['description']),
            const SizedBox(height: 16),
            Text(countdownText, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Center(child: actionButton),
          ],
        ),
      ),
    );
  }
}