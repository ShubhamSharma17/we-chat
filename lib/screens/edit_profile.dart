import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:we_chat/screens/home_screen.dart';
import 'package:we_chat/utility/ui_helper.dart';
import 'package:we_chat/utility/utility.dart';

import '../models/user_model.dart';
import '../utility/colors.dart';

class EditProfileScreen extends StatefulWidget {
  UserModel userModel;
  final User firebaseUser;

  EditProfileScreen(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormBuilderState> _key = GlobalKey<FormBuilderState>();
  TextEditingController fullnameController = TextEditingController();
  bool isDisable = true;
  // method for change name..
  void updateName(String name) async {
    UIHelper.showLoadingDialog(context, "Updating...");
    widget.userModel.fullname = name;
    await FirebaseFirestore.instance
        .collection("User")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap());

    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection("User")
        .doc(widget.userModel.uid)
        .get();
    widget.userModel =
        UserModel.fromMap(userData.data() as Map<String, dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            verticalSpacesLarge,
            // text editing controller..
            FormBuilder(
              key: _key,
              child: FormBuilderTextField(
                name: "Change Name",
                controller: fullnameController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // validator: FormBuilderValidators.required(
                //   errorText: "Full Name can't be empty",
                // ),
                onChanged: (value) {
                  if (fullnameController.text == "") {
                    setState(() {
                      isDisable = true;
                    });
                  } else {
                    setState(() {
                      isDisable = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  // icon
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.person),
                  ),
                  fillColor: blueF4FDFFCC,
                  hintText: "Enter Full Name",
                  labelText: "Full Name",
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
            // change button..
            isDisable
                ? CupertinoButton(
                    color: gray939393,
                    child: const Text("Change"),
                    onPressed: () {},
                  )
                : CupertinoButton(
                    color: blue,
                    child: const Text("Change"),
                    onPressed: () {
                      updateName(fullnameController.text.trim());
                      fullnameController.clear();
                      Navigator.pop(context);
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacement(context, CupertinoPageRoute(
                        builder: (context) {
                          return HomeScreen(
                              userModel: widget.userModel,
                              firebaseUser: widget.firebaseUser);
                        },
                      ));
                    },
                  )
          ],
        ),
      ),
    );
  }
}
