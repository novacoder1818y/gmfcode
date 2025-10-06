import 'package:get/get.dart';

// This binding is for the NotificationsView.
// Since the current view is a static list, no controller is needed.
// If you were to fetch notifications from a server, you would create a
// NotificationsController and inject it here.
class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    // Example: Get.lazyPut<NotificationsController>(() => NotificationsController());
  }
}