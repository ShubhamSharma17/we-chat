import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:we_chat/models/user_model.dart';
import 'package:we_chat/screens/complete_profile.dart';

import '../utility/colors.dart';
import '../utility/utility.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  bool isDisable = true;

  bool show = false;
  bool show1 = false;

  // void checkValue() {
  //   String email = emailController.text.trim();
  //   String password = passwordController.text.trim();
  //   signUp(email, password);
  // }

// sign up method..
  void signUp(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseException catch (error) {
      log(error.code.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;

      UserModel userModel = UserModel(
        email: email,
        fullname: "",
        profilepic: "",
        uid: uid,
      );
      FirebaseFirestore.instance
          .collection("User")
          .doc(uid)
          .set(userModel.toMap())
          .then((value) {
        log("New User Created");
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return CompleteProfileScreen(
                userModel: userModel, firebaseUser: credential!.user!);
          },
        ));
      });
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
                  // heading..
                  const Text(
                    "We Chat",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: screenHeight(context) * .05),
                  // form builder..
                  FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        // email text field
                        FormBuilderTextField(
                          name: "email address",
                          obscureText: false,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
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
                            hintText: "Enter Email",
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
                        SizedBox(height: screenHeight(context) * .02),
                        // password text field...
                        FormBuilderTextField(
                          obscureText: show ? false : true,
                          name: "Password",
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                  errorText: " Password can't be empty"),
                              FormBuilderValidators.match(
                                  confirmPasswordController.text,
                                  errorText: "Password must be same"),
                            ],
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
                            labelText: "Password",
                            hintText: "Enter Password",
                            prefixIcon: IconButton(
                                onPressed: () {
                                  if (show) {
                                    setState(() {
                                      show = false;
                                    });
                                  } else {
                                    setState(() {
                                      show = true;
                                    });
                                  }
                                },
                                icon: show
                                    ? const Icon(
                                        CupertinoIcons.eye_slash_fill,
                                        color: blue04C2F1,
                                        size: 23,
                                      )
                                    : const Icon(
                                        color: blue04C2F1,
                                        Icons.remove_red_eye,
                                        size: 23,
                                      )),
                            fillColor: blueF4FDFFCC,
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
                        SizedBox(height: screenHeight(context) * .02),
                        // confirm password text field..
                        FormBuilderTextField(
                          name: "Confirm Password",
                          controller: confirmPasswordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.text,
                          obscureText: show1 ? false : true,
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                  errorText: "Confirm Password can't be empty"),
                              FormBuilderValidators.match(
                                  passwordController.text,
                                  errorText: "Confirm Password must be same"),
                            ],
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
                            labelText: "Confirm Password",
                            hintText: "Enter Confirm Password",
                            prefixIcon: IconButton(
                                onPressed: () {
                                  if (show) {
                                    setState(() {
                                      show1 = false;
                                    });
                                  } else {
                                    setState(() {
                                      show1 = true;
                                    });
                                  }
                                },
                                icon: show1
                                    ? const Icon(
                                        CupertinoIcons.eye_slash_fill,
                                        color: blue04C2F1,
                                        size: 23,
                                      )
                                    : const Icon(
                                        color: blue04C2F1,
                                        Icons.remove_red_eye,
                                        size: 23,
                                      )),
                            fillColor: blueF4FDFFCC,
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
                        )
                      ],
                    ),
                  ),
                  verticalSpaceMedium,
                  // sign up button..
                  isDisable
                      ? CupertinoButton(
                          onPressed: () {
                            // signUp(emailController.text.trim(),
                            //     passwordController.text.trim());
                          },
                          color: gray8F959E,
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        )
                      : CupertinoButton(
                          onPressed: () {
                            signUp(emailController.text.trim(),
                                passwordController.text.trim());
                          },
                          color: Theme.of(context).colorScheme.secondary,
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
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
              "Already have an account?",
              style: TextStyle(fontSize: 16),
            ),
            CupertinoButton(
              child: const Text(
                "Log In",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
