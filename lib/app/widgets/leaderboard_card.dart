// lib/widgets/leaderboard_card.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LeaderboardCard extends StatelessWidget {
  final int rank;
  final String name;
  final int xp;
  final bool isTopThree;
  final VoidCallback? onTap; // Added onTap callback

  const LeaderboardCard({
    super.key,
    required this.rank,
    required this.name,
    required this.xp,
    this.isTopThree = false,
    this.onTap, // Added to constructor
  });

  @override
  Widget build(BuildContext context) {
    final Color rankColor = isTopThree ? AppTheme.goldColor : Colors.white;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: isTopThree ? AppTheme.secondaryColor.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isTopThree ? const BorderSide(color: AppTheme.goldColor, width: 1.5) : BorderSide.none,
      ),
      child: InkWell( // Wrapped with InkWell to make it tappable
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                '#$rank',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: rankColor,
                ),
              ),
              const SizedBox(width: 16),
              const CircleAvatar(
                child: Icon(Icons.person),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${xp} XP',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}