// lib/modules/leaderboard/leaderboard_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../widgets/leaderboard_card.dart';
import 'leaderboard_controller.dart';

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Leaderboard'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Global Ranks'),
              Tab(text: 'Event Ranks (TBA)'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LeaderboardList(isEvent: false),
            const Center(
              child: Text(
                'Event-specific leaderboards are coming soon!',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaderboardList extends GetView<LeaderboardController> {
  final bool isEvent;
  const LeaderboardList({super.key, required this.isEvent});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: controller.getLeaderboardStream(),
      builder: (context, snapshot) {
        // --- THIS IS THE FIX ---

        // 1. Handle the loading state FIRST.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Handle any potential errors with the stream.
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // 3. Handle the case where the stream is empty or has no data.
        //    This check prevents the null error.
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No users found in the leaderboard yet.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        // 4. ONLY if all checks pass, we can safely use the data.
        final rankedUsers = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: rankedUsers.length,
          itemBuilder: (context, index) {
            final user = rankedUsers[index];
            final rank = index + 1;

            return LeaderboardCard(
              rank: rank,
              name: user['name'] as String,
              xp: user['xp'] as int,
              isTopThree: rank <= 3,
              onTap: () {
                final String clickedUserId = user['uid'];
                if (clickedUserId == controller.currentUserId) {
                  Get.toNamed(Routes.PROFILE);
                } else {
                  Get.toNamed(
                    Routes.PUBLIC_PROFILE,
                    arguments: {
                      'uid': user['uid'],
                      'name': user['name'],
                    },
                  );
                }
              },
            ).animate().fadeIn(delay: (100 * index).ms).slideX();
          },
        );
      },
    );
  }
}