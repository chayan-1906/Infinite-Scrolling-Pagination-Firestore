import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

import 'post_model.dart';

class RandomPostListView extends StatelessWidget {
  const RandomPostListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postsCollection = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt')
        .withConverter<PostModel>(
      fromFirestore: (snapshot, _) => PostModel.fromDocument(snapshot.data()),
      toFirestore: (post, _) => post.toMap(),
    );

    return FirestoreListView<PostModel>(
      query: postsCollection,
      pageSize: 20,
      itemBuilder: (context, snapshot) {
        final post = snapshot.data();
        return ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(post.imageUrl)),
          title: Text(post.title),
          subtitle: Text('${post.likes} Likes'),
        );
      },
    );
  }
}
