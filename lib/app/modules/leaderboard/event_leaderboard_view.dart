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
        // This query will FAIL until the Firebase index is created and enabled.
        stream: FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
            .collection('participants')
            .orderBy('score', descending: true)
            .orderBy('completionTimeSeconds')
            .limit(5)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: The required Firestore index is missing or still building.\n\nPlease follow the link in your error console to create it and wait for it to be "Enabled".',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No participants have completed the event yet.'));
          }

          final participants = snapshot.data!.docs;

          return ListView.builder(
            itemCount: participants.length,
            itemBuilder: (context, index) {
              final participant = participants[index].data() as Map<String, dynamic>;
              Widget leadingIcon;
              switch (index) {
                case 0:
                  leadingIcon = const Icon(Icons.emoji_events, color: Colors.amber, size: 30);
                  break;
                case 1:
                  leadingIcon = const Icon(Icons.emoji_events, color: Colors.grey, size: 30);
                  break;
                case 2:
                  leadingIcon = const Icon(Icons.emoji_events, color: Color(0xFFCD7F32), size: 30);
                  break;
                default:
                  leadingIcon = Text('  #${index + 1}', style: const TextStyle(fontSize: 18, color: Colors.grey));
              }

              return ListTile(
                leading: leadingIcon,
                title: Text(participant['name'] ?? 'Anonymous', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                subtitle: Text('Time: ${participant['completionTimeSeconds']} seconds'),
                trailing: Text('${participant['score']} XP', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              );
            },
          );
        },
      ),
    );
  }
}