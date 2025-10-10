import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gmfcode/app/modules/feed/feed_post_model.dart';

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
    isLoading.value = false;
  }
}
