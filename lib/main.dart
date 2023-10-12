import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:we_chat/models/firebase_helper.dart';
import 'package:we_chat/models/user_model.dart';
import 'package:we_chat/screens/home_screen.dart';
import 'package:we_chat/screens/login_screen.dart';

//global

var uuid = const Uuid();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    // logged In
    UserModel? userModel =
        await FirebaseHelper.getUserModelByID(currentUser.uid);
    if (userModel != null) {
      runApp(MyAppLoggedIn(
        firebaseUser: currentUser,
        userModel: userModel,
      ));
    } else {
      runApp(const MyApp());
    }
  } else {
    runApp(const MyApp());
  }
}

// not LoggedIn
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

// Already LoggedIn
class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn({
    super.key,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(firebaseUser: firebaseUser, userModel: userModel),
    );
  }
}
