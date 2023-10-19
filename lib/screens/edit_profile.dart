import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../models/user_model.dart';
import '../utility/colors.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const EditProfileScreen(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormBuilderState> _key = GlobalKey<FormBuilderState>();
  TextEditingController fullnameController = TextEditingController();
  bool isDisable = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Container(
        child: Column(
          children: [
            // text editing controller..
            FormBuilder(
              key: _key,
              child: FormBuilderTextField(
                name: "Change Name",
                controller: fullnameController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: FormBuilderValidators.required(
                  errorText: "Full Name can't be empty",
                ),
                onChanged: (value) {
                  if (_key.currentState!.validate()) {
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
          ],
        ),
      ),
    );
  }
}
