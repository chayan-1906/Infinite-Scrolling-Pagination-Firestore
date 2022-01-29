import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

import 'post_model.dart';

class BuildPost extends StatelessWidget {
  const BuildPost({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postsCollection = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt')
        .withConverter<PostModel>(
      fromFirestore: (snapshot, _) => PostModel.fromDocument(snapshot.data()),
      toFirestore: (post, _) => post.toMap(),
    );

    return FirestoreQueryBuilder<PostModel>(
      query: postsCollection,
      pageSize: 2,
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        }
        return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: snapshot.docs.length,
            itemBuilder: (context, index) {
              final hasEndReached = snapshot.hasMore &&
                  index + 1 == snapshot.docs.length &&
                  !snapshot.isFetchingMore;
              if (hasEndReached) {
                snapshot.fetchMore();
              }
              final post = snapshot.docs[index].data();
              return Card(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          post.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Text(post.title),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}