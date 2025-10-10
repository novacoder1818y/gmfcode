import 'package:cloud_firestore/cloud_firestore.dart';

// This is the core data structure for a feed post.
class FeedPostModel {
  final String id;
  final String title;
  final String author;
  final String content;
  final Timestamp? createdAt;

  FeedPostModel({
    required this.id,
    required this.title,
    required this.author,
    required this.content,
    this.createdAt,
  });

  // This factory constructor allows us to create a FeedPostModel from a Firestore document.
  factory FeedPostModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FeedPostModel(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      content: data['content'] ?? '',
      createdAt: data['createdAt'] as Timestamp?,
    );
  }
}