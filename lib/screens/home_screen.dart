import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/models/user_model.dart';
import 'package:we_chat/screens/seachPage.dart';

class HomeScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomeScreen(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Sign Out Function
  _signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
      appBar: AppBar(
        title: const Text("Home"),
        leading: const Icon(CupertinoIcons.home),
        actions: [
          // search button
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          // more feature button
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_vert_outlined)),
        ],
      ),
      // floating button for add new user
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return SearchScreen(
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseUser);
              },
            ));
          },
          child: const Icon(Icons.search)),
    );
  }
}
