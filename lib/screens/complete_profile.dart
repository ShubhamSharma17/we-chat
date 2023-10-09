import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/screens/home_screen.dart';
import 'package:we_chat/utility/colors.dart';
import 'package:we_chat/utility/utility.dart';

import '../models/user_model.dart';

class CompleteProfileScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfileScreen(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  File? imageFile;
  TextEditingController fullnameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormBuilderState> _key = GlobalKey<FormBuilderState>();

  bool isDisable = true;

  // select image method..
  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  // crop image method..
  void cropImage(XFile file) async {
    CroppedFile? cropImage = await ImageCropper.platform.cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 20,
    );
    if (cropImage != null) {
      setState(() {
        imageFile = File(cropImage.path);
      });
    }
  }

  // method for showing option to choose photo from gallery or camera..
  void showPhotoOption() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Upload Profile Picture"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                leading: const Icon(Icons.photo),
                title: const Text("Select from gallery"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
                leading: const Icon(Icons.camera),
                title: const Text("Take a photo"),
              )
            ],
          ),
        );
      },
    );
  }

  void checkValues() {
    String fullName = fullnameController.text.trim();
    String phoneNumber = fullnameController.text.trim();

    if (fullName == "" || imageFile == null || phoneNumber == "") {
      log("Please Fill all Fields");
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilePicture")
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;

    String? imageUrl = await snapshot.ref.getDownloadURL();
    String? fullName = fullnameController.text.trim();
    String? phoneNumber = phoneNumberController.text.trim();

    widget.userModel.fullname = fullName;
    widget.userModel.profilepic = imageUrl;
    widget.userModel.phoneNumber = phoneNumber;

    await FirebaseFirestore.instance
        .collection("User")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      log("Data is Uploaded");
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return HomeScreen(
            firebaseUser: widget.firebaseUser,
            userModel: widget.userModel,
          );
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Complete Profile",
          style: TextStyle(
            color: white,
          ),
        ),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: ListView(
          children: [
            verticalSpaceMedium,
            // profile picture
            CupertinoButton(
              onPressed: () {
                showPhotoOption();
              },
              padding: const EdgeInsets.all(0),
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    imageFile != null ? FileImage(imageFile!) : null,
                child: imageFile == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
            ),
            verticalSpaceMedium,
            // Full Name text field..
            FormBuilder(
                key: _key,
                child: Column(
                  children: [
                    // full name text field
                    FormBuilderTextField(
                      name: "full name",
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
                    verticalSpaceMedium,
                    // Phone Number text field
                    FormBuilderTextField(
                      name: "Phone Number",
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLength: 10,
                      validator: FormBuilderValidators.required(
                        errorText: "Phone can't be empty",
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
                          icon: const Icon(Icons.phone),
                        ),
                        fillColor: blueF4FDFFCC,
                        hintText: "Enter Phone Number",
                        labelText: "Phone Number",
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
                )),
            verticalSpaceMedium,
            // submit button..
            isDisable
                ? CupertinoButton(
                    onPressed: () {},
                    color: gray8F959E,
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
                : CupertinoButton(
                    onPressed: () {
                      checkValues();
                    },
                    color: Theme.of(context).colorScheme.secondary,
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
          ],
        ),
      )),
    );
  }
}
