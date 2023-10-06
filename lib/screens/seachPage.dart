// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:we_chat/models/user_model.dart';
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
        child: FormBuilder(
            child: Column(
          children: [
            verticalSpacesLarge,
            // search text field...
            FormBuilderTextField(
              name: "email address",
              obscureText: false,
              controller: searchController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      Icons.search_rounded,
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
                  )
          ],
        )),
      ),
    );
  }
}
