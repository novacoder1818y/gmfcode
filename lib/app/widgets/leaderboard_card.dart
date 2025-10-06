import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';
import '../theme/app_theme.dart';

class LeaderboardCard extends StatelessWidget {
  final int rank;
  final String name;
  final int xp;

  const LeaderboardCard({
    super.key,
    required this.rank,
    required this.name,
    required this.xp, required bool isTopThree,
  });

  Color _getBorderColor() {
    if (rank == 1) return AppTheme.goldColor;
    if (rank == 2) return AppTheme.silverColor;
    if (rank == 3) return AppTheme.bronzeColor;
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final isTopThree = rank <= 3;
    final borderColor = _getBorderColor();

    return Card(
      elevation: isTopThree ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: isTopThree ? BorderSide(color: borderColor, width: 2) : BorderSide.none,
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          // Navigate to user profile, passing user data
          Get.toNamed(Routes.PROFILE, arguments: {'name': name, 'xp': xp});
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: isTopThree ? [BoxShadow(color: borderColor.withOpacity(0.5), blurRadius: 10)] : [],
          ),
          child: Row(
            children: [
              Text('#$rank', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: isTopThree ? borderColor : Colors.white)),
              const SizedBox(width: 16),
              Hero(
                tag: 'user_avatar_$name', // Unique tag for Hero animation
                child: const CircleAvatar(child: Icon(Icons.person)),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              Text('$xp XP', style: const TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}