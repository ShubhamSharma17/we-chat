import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/models/chat_room_model.dart';
import 'package:we_chat/models/firebase_helper.dart';
import 'package:we_chat/models/user_model.dart';
import 'package:we_chat/screens/chat_room_screen.dart';
import 'package:we_chat/screens/edit_profile.dart';
import 'package:we_chat/screens/login_screen.dart';
import 'package:we_chat/screens/seachPage.dart';
import 'package:we_chat/utility/colors.dart';
import 'package:we_chat/utility/utility.dart';

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
    // await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  // profile picture
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(
                      widget.userModel.profilepic!,
                    ),
                  ),
                  verticalSpaceSmall,
                  // name
                  Text(
                    widget.userModel.fullname!,
                    style: const TextStyle(fontSize: 18, color: white),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, CupertinoPageRoute(
                  builder: (context) {
                    return EditProfileScreen(
                      firebaseUser: widget.firebaseUser,
                      userModel: widget.userModel,
                    );
                  },
                ));
              },
              title: const Text(
                "Profile",
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
      // appbar
      appBar: AppBar(
        title: const Text("We Chat"),
        centerTitle: true,
        actions: [
          // log out button
          IconButton(
              onPressed: () {
                _signOut();
                // go to login page
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ));
              },
              icon: const Icon(Icons.exit_to_app_rounded)),
        ],
      ),
      body: SafeArea(
          child: SizedBox(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatrooms")
              .where("users", arrayContains: widget.userModel.uid)
              .orderBy("updatedOn", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot chatroomsSnapshort =
                    snapshot.data as QuerySnapshot;
                return ListView.builder(
                  itemCount: chatroomsSnapshort.docs.length,
                  itemBuilder: (context, index) {
                    ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                        chatroomsSnapshort.docs[index].data()
                            as Map<String, dynamic>);
                    Map<String, dynamic> paricipants =
                        chatRoomModel.participant!;
                    List<String> participantsKeys = paricipants.keys.toList();
                    participantsKeys.remove(widget.userModel.uid);
                    return FutureBuilder(
                      future:
                          FirebaseHelper.getUserModelByID(participantsKeys[0]),
                      builder: (context, userdata) {
                        if (userdata.connectionState == ConnectionState.done) {
                          if (userdata.hasData) {
                            UserModel targetUser = userdata.data as UserModel;
                            return ListTile(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return ChatRoomScreen(
                                        chatRoomModel: chatRoomModel,
                                        targetUser: targetUser,
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser);
                                  },
                                ));
                              },
                              leading: CircleAvatar(
                                  backgroundImage:
                                      //  targetUser.profilepic != null
                                      //     ?
                                      NetworkImage(targetUser.profilepic!,
                                          scale: 1.0)
                                  // : Image.asset("asset/image/error.png")
                                  //     .image
                                  ),
                              title: Text(targetUser.fullname.toString()),
                              subtitle: chatRoomModel.lastMessage == ""
                                  ? Text(
                                      "Say hi to your new friend!",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    )
                                  : Text(
                                      chatRoomModel.lastMessage.toString(),
                                      style: const TextStyle(color: gray8F959E),
                                    ),
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return const Center(
                  child: Text("No Chats"),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      )),
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
