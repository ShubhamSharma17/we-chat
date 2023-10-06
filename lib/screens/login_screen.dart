// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:we_chat/models/user_model.dart';
import 'package:we_chat/screens/home_screen.dart';
import 'package:we_chat/screens/signup_screen.dart';
import 'package:we_chat/utility/utility.dart';

import '../utility/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  bool isDisable = true;
  bool show = false;

  void logIn(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      log(error.code.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection("User").doc(uid).get();
      UserModel userModel =
          UserModel.fromMap(userData.data() as Map<String, dynamic>);
      // go to home screen
      log("user details ${userModel.email}");
      log("user details ${userModel.uid}");

      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return HomeScreen(
              userModel: userModel, firebaseUser: credential!.user!);
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "We Chat",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueAccent,
                    ),
                  ),
                  verticalSpaceMedium,
                  FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        // email text field
                        FormBuilderTextField(
                          name: "email address",
                          obscureText: false,
                          controller: emailController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormBuilderValidators.required(
                            errorText: "email can't be empty",
                          ),
                          onChanged: (value) {
                            if (_formKey.currentState!.validate()) {
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
                                  Icons.mail,
                                  color: blue04C2F1,
                                  size: 23,
                                )),
                            fillColor: blueF4FDFFCC,
                            hintText: "Enter Email Address",
                            labelText: "Email",
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
                        // password text field
                        FormBuilderTextField(
                          name: "password",
                          obscureText: show ? false : true,
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormBuilderValidators.required(
                            errorText: "Password can't be empty",
                          ),
                          onChanged: (value) {
                            if (_formKey.currentState!.validate()) {
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
                              onPressed: () {
                                setState(() {
                                  if (show) {
                                    show = false;
                                  } else {
                                    show = true;
                                  }
                                });
                              },
                              icon: show
                                  ? const Icon(
                                      FontAwesomeIcons.solidEyeSlash,
                                      color: blue04C2F1,
                                      size: 18,
                                    )
                                  : const Icon(
                                      Icons.remove_red_eye_rounded,
                                      color: blue04C2F1,
                                    ),
                            ),
                            fillColor: blueF4FDFFCC,
                            hintText: "Enter Password",
                            labelText: "Password",
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
                      ],
                    ),
                  ),

                  verticalSpaceMedium,
                  // login button..
                  isDisable
                      ? CupertinoButton(
                          onPressed: () {},
                          color: gray8F959E,
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        )
                      : CupertinoButton(
                          onPressed: () {
                            logIn(emailController.text.trim(),
                                passwordController.text.trim());
                          },
                          color: Theme.of(context).colorScheme.secondary,
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have account?",
              style: TextStyle(fontSize: 16),
            ),
            CupertinoButton(
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
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
