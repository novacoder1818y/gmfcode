import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'feed_post_model.dart'; // Corrected import path

class FeedController extends GetxController {
  var feedPosts = <FeedPostModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    feedPosts.bindStream(
      FirebaseFirestore.instance
          .collection('codeFeed')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => FeedPostModel.fromFirestore(doc)).toList()),
    );
    // Use a listener to know when the data has been loaded for the first time
    feedPosts.listen((_) {
      if (isLoading.value) {
        isLoading.value = false;
      }
    });
  }
}