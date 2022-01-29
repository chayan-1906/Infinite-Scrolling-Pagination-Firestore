import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'build_post.dart';
import 'post_model.dart';
import 'random_post_listview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinite Scrolling & Pagination',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final postsCollection = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('createdAt')
      .withConverter<PostModel>(
        fromFirestore: (snapshot, _) => PostModel.fromDocument(snapshot.data()),
        toFirestore: (post, _) => post.toMap(),
      );

  int _selectedIndex = 0;

  Future<void> uploadRandom() async {
    final postsCollection =
        FirebaseFirestore.instance.collection('posts').withConverter<PostModel>(
              fromFirestore: (snapshot, _) =>
                  PostModel.fromDocument(snapshot.data()),
              toFirestore: (post, _) => post.toMap(),
            );
    final numbers = List.generate(500, (index) => index + 1);

    for (final number in numbers) {
      final postModel = PostModel(
        title: 'Random Title $number',
        likes: Random().nextInt(1000),
        createdAt: DateTime.now(),
        imageUrl: 'https://source.unsplash.com/random?sig=$number',
      );
      postsCollection.add(postModel);
    }
  }

  List bottomNavBarItems = [
    const RandomPostListView(),
    const BuildPost(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uploadRandom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: const Text('Infinite Scrolling & Pagination'),
      ),
      body: bottomNavBarItems.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              label: 'Random Posts', icon: Icon(Icons.post_add_rounded)),
          BottomNavigationBarItem(
              label: 'Posts', icon: Icon(Icons.ac_unit_rounded)),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
