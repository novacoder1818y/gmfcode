import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationController extends GetxController {
  var hasNewNotification = false.obs;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        checkForNewContent();
      }
    });
  }

  Future<void> checkForNewContent() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final lastSeen = userDoc.data()?['lastSeenNotificationTime'] as Timestamp?;

    QuerySnapshot eventQuery;
    if (lastSeen != null) {
      // Check for events with a 'createdAt' timestamp greater than the last seen time.
      eventQuery = await _firestore.collection('events').where('createdAt', isGreaterThan: lastSeen).limit(1).get();
    } else {
      // If user has never checked, any event is a new event.
      eventQuery = await _firestore.collection('events').orderBy('createdAt', descending: true).limit(1).get();
    }

    if (eventQuery.docs.isNotEmpty) {
      hasNewNotification.value = true;
    }
  }

  Future<void> markAsSeen() async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Set the new timestamp. Using SetOptions(merge: true) is safe.
    await _firestore.collection('users').doc(user.uid).set({
      'lastSeenNotificationTime': Timestamp.now(),
    }, SetOptions(merge: true));

    hasNewNotification.value = false;
  }
}