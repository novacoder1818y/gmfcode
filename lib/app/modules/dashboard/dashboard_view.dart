import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../routes/app_pages.dart';
import '../../theme/app_theme.dart';
import '../../widgets/animated_glow_card.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
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
    // This could be a StatefulWidget to animate the indicators on load
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
                const Hero(
                  tag: 'user_avatar_Player One', // Unique tag
                  child: CircleAvatar(
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
                        'Player One',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 5),
                      Text('Level 5 | Pro Coder',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppTheme.accentColor)),
                    ],
                  ),
                ),
                CircularPercentIndicator(
                  radius: 30.0,
                  lineWidth: 8.0,
                  animation: true,
                  animationDuration: 1200,
                  percent: 0.7,
                  center: const Text(
                    "🔥 5",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: AppTheme.accentColor,
                  backgroundColor: AppTheme.primaryColor,
                )
              ],
            ),
            const SizedBox(height: 20),
            LinearPercentIndicator(
              lineHeight: 12.0,
              percent: 0.45,
              animation: true,
              animationDuration: 1000,
              barRadius: const Radius.circular(10),
              progressColor: AppTheme.secondaryColor,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.5),
              center: Text(
                "XP: 450 / 1000",
                style:
                const TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
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
