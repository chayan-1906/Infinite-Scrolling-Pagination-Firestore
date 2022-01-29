import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String title;
  final int likes;
  final DateTime createdAt;
  final String imageUrl;

  PostModel({this.title, this.likes, this.createdAt, this.imageUrl});

  factory PostModel.fromDocument(Map<String, Object> json) {
    return PostModel(
      title: json['title'] as String,
      likes: json['likes'] as int,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, Object> toMap() {
    return {
      'title': title,
      'likes': likes,
      'createdAt': createdAt,
      'imageUrl': imageUrl,
    };
  }
}
