import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var eventsList = <QueryDocumentSnapshot>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Bind a real-time stream to the events collection, ordering by the nearest start date
    eventsList.bindStream(
        _firestore.collection('events').orderBy('startDate').snapshots().map((snapshot) => snapshot.docs)
    );
    isLoading.value = false;
  }
}
