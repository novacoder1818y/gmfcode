// lib/modules/public_profile/public_profile_view.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../theme/app_theme.dart';
import '../../widgets/animated_counter.dart';
import 'public_profile_controller.dart';

class PublicProfileView extends GetView<PublicProfileController> {
  const PublicProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text("${controller.userData.value?['name'] ?? 'User'}'s Profile")),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value != null) {
          return Center(child: Text(controller.errorMessage.value!));
        }
        if (controller.userData.value == null) {
          return const Center(child: Text("No user data available."));
        }

        final user = controller.userData.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildProfileCard(context, user),
              const SizedBox(height: 30),
              _buildStatsGrid(user['xp'] ?? 0, user['points'] ?? 0),
              const SizedBox(height: 30),
              _buildLevelSection(user['xp'] ?? 0),
              const SizedBox(height: 30),
              _buildBadgesSection(controller.achievements),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileCard(BuildContext context, Map<String, dynamic> user) {
    final String userName = user['name'] ?? 'Player';
    final Timestamp? joinedDateTimestamp = user['joinedDate'] as Timestamp?;
    final String joinedDate = joinedDateTimestamp != null
        ? DateFormat('MMM yyyy').format(joinedDateTimestamp.toDate())
        : 'N/A';
    final String heroTag = 'user_avatar_${user['uid']}';

    return Row(
      children: [
        Hero(
          tag: heroTag,
          child: CircleAvatar(
            radius: 45,
            backgroundColor: AppTheme.secondaryColor,
            child: const Icon(Icons.person, size: 50, color: Colors.white),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: Theme.of(context).textTheme.headlineSmall, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 5),
              Text('Joined: $joinedDate', style: const TextStyle(color: Colors.white70)),
            ],
          ),
        )
      ],
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildStatsGrid(int xp, int points) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('Total XP', xp),
        _buildStatItem('Points', points),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        AnimatedCounter(
          end: value,
          duration: const Duration(seconds: 2),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.accentColor),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildLevelSection(int totalXp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Level ${controller.currentLevel.value}', style: Theme.of(Get.context!).textTheme.titleLarge),
        const SizedBox(height: 15),
        LinearPercentIndicator(
          lineHeight: 18.0,
          percent: controller.levelProgress.value,
          center: Text(
            "XP: $totalXp / ${controller.nextLevelXp.value}",
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          barRadius: const Radius.circular(10),
          progressColor: AppTheme.goldColor,
          backgroundColor: AppTheme.primaryColor,
          animation: true,
          animationDuration: 1000,
        ),
      ],
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildBadgesSection(List<Map<String, dynamic>> achievements) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Achievements', style: Theme.of(Get.context!).textTheme.titleLarge),
        const SizedBox(height: 15),
        if (achievements.isEmpty)
          const Text('No achievements unlocked yet.', style: TextStyle(color: Colors.white70))
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return _Badge(
                icon: _getIconForName(achievement['iconName'] ?? 'star'),
                label: achievement['name'] ?? 'Unnamed Badge',
              ).animate().fadeIn(delay: (100 * index).ms).scale();
            },
          ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  IconData _getIconForName(String iconName) {
    switch (iconName) {
      case 'star':
        return Icons.star;
      case 'fire':
        return Icons.local_fire_department;
      case 'shield':
        return Icons.shield;
      default:
        return Icons.emoji_events;
    }
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Badge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.withOpacity(0.1),
          border: Border.all(color: AppTheme.accentColor.withOpacity(0.5)),
        ),
        child: Icon(icon, color: AppTheme.accentColor, size: 30),
      ),
    );
  }
}