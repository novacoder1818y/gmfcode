import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../routes/app_pages.dart';
import '../../theme/app_theme.dart';
import '../../widgets/animated_counter.dart';
import '../../widgets/neon_button.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with TickerProviderStateMixin {
  late final AnimationController _streakController;

  // Check if we are viewing our own profile or someone else's
  final bool isMyProfile = Get.arguments == null;

  // Use dummy data or passed arguments
  late final String userName;
  late final String heroTag;

  @override
  void initState() {
    super.initState();
    userName = Get.arguments?['name'] ?? 'Player One';
    heroTag = 'user_avatar_$userName';

    _streakController = AnimationController(duration: 1200.ms, vsync: this);
    _streakController.forward();
  }

  @override
  void dispose() {
    _streakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isMyProfile ? 'My Profile' : '$userName\'s Profile'),
        actions: [
          if (isMyProfile)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => Get.offAllNamed(Routes.AUTH),
              tooltip: 'Log Out',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileCard(context)
                .animate()
                .fadeIn(duration: 500.ms)
                .scale(begin: const Offset(0.8, 0.8)),
            const SizedBox(height: 30),
            _buildStatsGrid().animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 30),
            _buildStreakSection(),
            const SizedBox(height: 30),
            _buildBadgesSection().animate().fadeIn(delay: 400.ms),
            if (!isMyProfile) ...[
              const SizedBox(height: 40),
              NeonButton(
                text: 'Challenge $userName',
                onTap: () {
                  Get.snackbar(
                    'Challenge Sent!',
                    'A random duel request was sent to $userName.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppTheme.accentColor,
                    colorText: Colors.black,
                  );
                },
                gradientColors: [Colors.red, Colors.orangeAccent],
              ).animate().slideY(begin: 1, end: 0).fadeIn(),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userName, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 5),
            const Text('Joined: Oct 2025', style: TextStyle(color: Colors.white70)),
          ],
        )
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('Total XP', 12000),
        _buildStatItem('Challenges', 78),
        _buildStatItem('Highest Streak', 25),
      ],
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        AnimatedCounter(
          end: value,
          duration: Duration(seconds: 2),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.accentColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildStreakSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Daily Streak', style: Theme.of(Get.context!).textTheme.titleLarge),
        const SizedBox(height: 15),
        AnimatedBuilder(
          animation: _streakController,
          builder: (context, child) {
            return LinearPercentIndicator(
              lineHeight: 18.0,
              percent: (5 / 7) * _streakController.value,
              center: const Text("5 days streak!", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              barRadius: const Radius.circular(10),
              progressColor: AppTheme.goldColor,
              backgroundColor: AppTheme.primaryColor,
            );
          },
        ),
      ],
    );
  }

  Widget _buildBadgesSection() {
    // ... (same as before)
    final badges = [
      {'icon': Icons.star, 'label': 'First Kill'},
      {'icon': Icons.local_fire_department, 'label': 'Hot Streak'},
      {'icon': Icons.shield, 'label': 'Bug Squasher'},
      {'icon': Icons.code_off, 'label': 'Puzzle Master'},
      {'icon': Icons.group_add, 'label': 'Team Player'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Achievements', style: Theme.of(Get.context!).textTheme.titleLarge),
        const SizedBox(height: 15),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            return _Badge(
              icon: badges[index]['icon'] as IconData,
              label: badges[index]['label'] as String,
            ).animate().fadeIn(delay: (100 * index).ms).scale();
          },
        ),
      ],
    );
  }
}

/// A custom widget for displaying a single badge.
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

