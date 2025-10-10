// lib/modules/dashboard/dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../routes/app_pages.dart';
import '../../theme/app_theme.dart';
import '../../widgets/animated_glow_card.dart';
import '../profile/profile_controller.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // This ensures the profile data is ready for the header by creating its controller
    Get.lazyPut(() => ProfileController(), fenix: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            tooltip: 'Notifications',
            onPressed: () => Get.toNamed(Routes.NOTIFICATIONS),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(context)
                .animate()
                .fadeIn(duration: 500.ms)
                .slideY(begin: -0.2, end: 0),
            const SizedBox(height: 30),
            _buildDashboardGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();

    return Obx(() {
      if (profileController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (profileController.userData.value == null) {
        return const Center(child: Text('Could not load profile header.'));
      }

      final user = profileController.userData.value!;
      final totalXp = user['xp'] ?? 0;

      return GestureDetector(
        onTap: () => Get.toNamed(Routes.PROFILE),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900]?.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.5)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Hero(
                    tag: 'user_avatar_${user['uid']}',
                    child: const CircleAvatar(
                      radius: 35,
                      backgroundColor: AppTheme.secondaryColor,
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['name'] ?? 'Player',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 5),
                        Text('Level ${profileController.currentLevel.value}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppTheme.accentColor)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LinearPercentIndicator(
                lineHeight: 12.0,
                percent: profileController.levelProgress.value,
                animation: true,
                barRadius: const Radius.circular(10),
                progressColor: AppTheme.secondaryColor,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.5),
                center: Text(
                  "XP: $totalXp / ${profileController.nextLevelXp.value}",
                  style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDashboardGrid() {
    final cards = [
      AnimatedGlowCard(
        title: 'Challenges',
        icon: Icons.gamepad_outlined,
        onTap: () => Get.toNamed(Routes.CHALLENGES),
        gradientColors: const [AppTheme.accentColor, AppTheme.tertiaryColor],
      ),
      AnimatedGlowCard(
        title: 'Live Events',
        icon: Icons.online_prediction,
        onTap: () => Get.toNamed(Routes.EVENT),
        gradientColors: const [AppTheme.secondaryColor, Colors.pinkAccent],
      ),
      AnimatedGlowCard(
        title: 'Leaderboard',
        icon: Icons.leaderboard_outlined,
        onTap: () => Get.toNamed(Routes.LEADERBOARD),
        gradientColors: const [AppTheme.tertiaryColor, Colors.orangeAccent],
      ),
      AnimatedGlowCard(
        title: 'Practice Arena',
        icon: Icons.fitness_center,
        onTap: () => Get.toNamed(Routes.PRACTICE),
        gradientColors: const [Colors.lightGreen, AppTheme.accentColor],
      ),
      AnimatedGlowCard(
        title: 'Code Feed',
        icon: Icons.article_outlined,
        onTap: () => Get.toNamed(Routes.FEED),
        gradientColors: const [Colors.cyan, AppTheme.tertiaryColor],
      ),
      AnimatedGlowCard(
        title: 'My Profile',
        icon: Icons.person_outline,
        onTap: () => Get.toNamed(Routes.PROFILE),
        gradientColors: const [Colors.purple, Colors.redAccent],
      ),
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: cards.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return cards[index].animate().fadeIn(delay: (200 * index).ms).slideX();
      },
    );
  }
}