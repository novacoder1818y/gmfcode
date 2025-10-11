import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart'; // Use the main app pages
import 'feed_controller.dart';
import 'feed_post_model.dart';

class FeedView extends GetView<FeedController> {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Code Feed')),
      body: Obx(() {
        if (controller.isLoading.value && controller.feedPosts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.feedPosts.isEmpty) {
          return const Center(child: Text('No news available right now.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.feedPosts.length,
          itemBuilder: (context, index) {
            final post = controller.feedPosts[index];
            return _buildPostCard(post).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2);
          },
        );
      }),
    );
  }

  Widget _buildPostCard(FeedPostModel post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        // THIS IS THE FIX: This now navigates to the correct route
        onTap: () => Get.toNamed(Routes.FEED_DETAIL, arguments: post),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.title, style: Get.theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('By ${post.author}', style: TextStyle(color: Get.theme.colorScheme.secondary, fontStyle: FontStyle.italic)),
              const SizedBox(height: 12),
              Text(
                post.content,
                style: Get.theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Text('Read More...', style: TextStyle(color: Get.theme.colorScheme.primary, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}