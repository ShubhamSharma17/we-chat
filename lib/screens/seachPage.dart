// ignore_for_file: file_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:we_chat/models/user_model.dart';
import 'package:we_chat/screens/chat_room_screen.dart';
import 'package:we_chat/utility/utility.dart';

import '../utility/colors.dart';

class SearchScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchScreen(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isDisable = true;
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        // form builder..
        child: Column(
          children: [
            verticalSpacesLarge,
            // form builder..
            FormBuilder(
              child:
                  // search text field...
                  FormBuilderTextField(
                name: "Phone Number",
                obscureText: false,
                controller: searchController,
                keyboardType: TextInputType.phone,
                textCapitalization: TextCapitalization.words,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLength: 10,
                onChanged: (value) {
                  if (searchController.text.trim() != "") {
                    setState(() {
                      isDisable = false;
                    });
                  } else {
                    setState(() {
                      isDisable = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  // icon
                  prefixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.phone,
                        color: blue04C2F1,
                        size: 23,
                      )),
                  fillColor: blueF4FDFFCC,
                  hintText: "Search",
                  labelText: "Search",
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: const BorderSide(
                      color: blueD1F5FF,
                      width: 1.5,
                    ),
                  ),
                  hintStyle: const TextStyle(
                    fontFamily: 'PoppinsRegular',
                    fontSize: 14,
                    color: black0B2732,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: const BorderSide(
                      color: blueD1F5FF,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(15),
                ),
              ),
            ),
            verticalSpaceMedium,
            // search button..
            isDisable
                ? CupertinoButton(
                    color: gray8F959E,
                    child: const Text(
                      "Search",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {},
                  )
                : CupertinoButton(
                    color: Colors.blueAccent,
                    child: const Text(
                      "Search",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {},
                  ),
            verticalSpaceMedium,
            // search result..
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User")
                  .where("phoneNumber", isEqualTo: searchController.text)
                  .where("phoneNumber",
                      isNotEqualTo: widget.userModel.phoneNumber)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot querySnapshot =
                        snapshot.data as QuerySnapshot;
                    if (querySnapshot.docs.isNotEmpty) {
                      Map<String, dynamic> usersMap =
                          querySnapshot.docs[0].data() as Map<String, dynamic>;
                      UserModel searchMap = UserModel.fromMap(usersMap);
                      // list tile...
                      return ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ChatRoomScreen();
                            },
                          ));
                        },
                        title: Text(searchMap.fullname!),
                        subtitle: Text(searchMap.email!),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(searchMap.profilepic!),
                        ),
                        trailing:
                            const Icon(Icons.keyboard_arrow_right_rounded),
                      );
                    } else {
                      return const Text("No Result Found!");
                    }
                  } else if (snapshot.hasError) {
                    return const Text("An Error Occurred!");
                  } else {
                    return const Text("No Result Found!");
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
