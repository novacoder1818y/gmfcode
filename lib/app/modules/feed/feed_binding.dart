import 'package:get/get.dart';

// No controller is needed for this simple UI view, so the binding is empty.
// If you were to fetch feed posts from an API, you would create a FeedController
// and inject it here like this: Get.lazyPut<FeedController>(() => FeedController());
class FeedBinding extends Bindings {
  @override
  void dependencies() {
    // Dependencies go here
  }
}