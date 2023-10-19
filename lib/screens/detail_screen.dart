import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/utility/colors.dart';
import 'package:we_chat/utility/utility.dart';

import '../models/user_model.dart';

class DetailsScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const DetailsScreen({
    super.key,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: screenWidth(context),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // back button
              Container(
                width: screenWidth(context),
                alignment: Alignment.topLeft,
                child: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: const Icon(
                    Icons.arrow_back,
                    color: black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              verticalSpaceSmall,
              // profile picture
              CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(widget.userModel.profilepic!),
              ),
              verticalSpaceMedium,
              // name
              Text(
                widget.userModel.fullname!,
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
              verticalSpaceSmall,
              // email address
              Text(
                widget.userModel.email!,
                style: const TextStyle(
                  fontSize: 18,
                  color: gray939393,
                ),
              ),
              // phone name
              Text(
                widget.userModel.phoneNumber!,
                style: const TextStyle(
                  fontSize: 18,
                  color: gray939393,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
