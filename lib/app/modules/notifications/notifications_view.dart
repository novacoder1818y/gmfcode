import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../theme/app_theme.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      _NotificationItem(
        icon: Icons.event_available,
        title: 'New Event: Weekly Code Clash',
        subtitle: 'Starts in 1 hour. Get ready!',
        onTap: () => Get.toNamed(Routes.EVENT),
        color: AppTheme.secondaryColor,
      ),
      _NotificationItem(
        icon: Icons.gamepad,
        title: 'New Challenge Added!',
        subtitle: 'Test your skills in the new "Recursive Thinking" challenge.',
        onTap: () => Get.toNamed(Routes.CHALLENGES),
        color: AppTheme.accentColor,
      ),
      _NotificationItem(
        icon: Icons.person_add,
        title: 'Challenge from CodeNinja',
        subtitle: 'CodeNinja has challenged you to a duel. Tap to accept.',
        onTap: () { /* Navigate to duel screen */ },
        color: Colors.orangeAccent,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return notifications[index].animate()
              .fadeIn(delay: (100 * index).ms)
              .slideX(begin: 0.5, end: 0);
        },
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;

  const _NotificationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.white70)),
        onTap: onTap,
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}