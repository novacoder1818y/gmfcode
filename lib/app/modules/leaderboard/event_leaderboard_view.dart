// lib/modules/event/event_leaderboard_view.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class EventLeaderboardView extends StatelessWidget {
  const EventLeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final String eventId = Get.arguments['eventId'];
    final String eventTitle = Get.arguments['eventTitle'];

    return Scaffold(
      appBar: AppBar(title: Text('$eventTitle - Winners')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
            .collection('participants')
            .orderBy('score', descending: true)
            .orderBy('completionTimeSeconds')
            .limit(5)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final participants = snapshot.data!.docs;
          if (participants.isEmpty) return const Center(child: Text('No participants yet.'));

          return ListView.builder(
            itemCount: participants.length,
            itemBuilder: (context, index) {
              final participant = participants[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: Text('#${index + 1}'),
                title: Text(participant['name']),
                subtitle: Text('${participant['completionTimeSeconds']} seconds'),
                trailing: Text('${participant['score']} pts', style: const TextStyle(fontWeight: FontWeight.bold)),
              );
            },
          );
        },
      ),
    );
  }
}