import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../widgets/leaderboard_card.dart';

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
              Tab(text: 'Event Ranks'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LeaderboardList(isEvent: false),
            LeaderboardList(isEvent: true),
          ],
        ),
      ),
    );
  }
}

class LeaderboardList extends StatelessWidget {
  final bool isEvent;
  const LeaderboardList({super.key, required this.isEvent});

  @override
  Widget build(BuildContext context) {
    final data = isEvent
        ? [
      {'rank': 1, 'name': 'EventWinner', 'xp': 1200},
      {'rank': 2, 'name': 'QuickCoder', 'xp': 1100},
      {'rank': 3, 'name': 'Player One', 'xp': 950},
    ]
        : [
      {'rank': 1, 'name': 'GlobalKing', 'xp': 15000},
      {'rank': 2, 'name': 'CodeGod', 'xp': 14500},
      {'rank': 3, 'name': 'AlgoQueen', 'xp': 14200},
      {'rank': 4, 'name': 'Player One', 'xp': 12000},
      {'rank': 5, 'name': 'ByteMaster', 'xp': 11500},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final user = data[index];
        return LeaderboardCard(
          rank: user['rank'] as int,
          name: user['name'] as String,
          xp: user['xp'] as int, isTopThree:true,
        ).animate().fadeIn(delay: (100 * index).ms).slideX();
      },
    );
  }
}
