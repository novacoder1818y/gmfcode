import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../widgets/challenge_card.dart';
import 'challenges_controller.dart';

class ChallengesView extends StatelessWidget {
  const ChallengesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Put the controller here to initialize it for this page and its children
    final ChallengesController controller = Get.put(ChallengesController());

    return Scaffold(
      appBar: AppBar(title: const Text('Coding Challenges')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.challenges.length,
          itemBuilder: (context, index) {
            final challenge = controller.challenges[index];
            final hasCompleted = controller.hasCompleted(challenge.id);

            return ChallengeCard(
              title: challenge['title'],
              category: challenge['category'],
              tags: [challenge['difficulty']],
              progress: hasCompleted ? 1.0 : 0.0,
              // THIS IS THE FIX (Part 2)
              onTap: () => Get.toNamed(Routes.CHALLENGE_DETAIL, arguments: challenge),
            );
          },
        );
      }),
    );
  }
}