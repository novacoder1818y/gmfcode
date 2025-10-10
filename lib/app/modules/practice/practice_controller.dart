// lib/modules/practice/practice_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PracticeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get a stream of all practice categories, sorted by the 'order' field
  Stream<QuerySnapshot> getCategoriesStream() {
    return _firestore.collection('practiceCategories').orderBy('order').snapshots();
  }

  // Get a stream of problems for a specific category ID
  Stream<QuerySnapshot> getProblemsStream(String categoryId) {
    return _firestore
        .collection('practiceCategories')
        .doc(categoryId)
        .collection('problems')
        .snapshots();
  }
}