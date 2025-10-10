import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'feed_post_model.dart'; // Corrected import

class FeedDetailView extends StatelessWidget {
  const FeedDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // The post data is passed as an argument during navigation
    final FeedPostModel post = Get.arguments;

    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
            const SizedBox(height: 8),
            if (post.createdAt != null)
              Text(
                'By ${post.author} • ${DateFormat.yMMMd().format(post.createdAt!.toDate())}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            const Divider(height: 30),
            Text(post.content, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}