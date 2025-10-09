import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../widgets/challenge_card.dart';
import 'challenges_controller.dart';

// By extending GetView, we no longer need to manually call Get.put() or Get.find()
class ChallengesView extends GetView<ChallengesController> {
  const ChallengesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coding Challenges')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.challenges.isEmpty) {
          return const Center(child: Text('No challenges available right now.'));
        }
        // Using a reactive variable forces the list to rebuild when a challenge is completed
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.challenges.length,
          itemBuilder: (context, index) {
            final challenge = controller.challenges[index];
            // Obx makes this individual card reactive to changes in its completion status
            return Obx(() {
              final hasCompleted = controller.hasCompleted(challenge.id);
              return ChallengeCard(
                title: challenge['title'],
                category: challenge['category'],
                tags: [challenge['difficulty']],
                progress: hasCompleted ? 1.0 : 0.0, // Update progress bar
                onTap: () {
                  // If already completed, show a message, otherwise open the detail view
                  if (hasCompleted) {
                    Get.snackbar(
                      'Challenge Complete',
                      'You have already earned XP for this challenge.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    Get.toNamed(Routes.CHALLENGE_DETAIL, arguments: challenge);
                  }
                },
              );
            });
          },
        );
      }),
    );
  }
}
