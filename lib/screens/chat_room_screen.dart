import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_room_model.dart';
import 'package:we_chat/models/message_model.dart';
import 'package:we_chat/models/user_model.dart';
import 'package:we_chat/utility/colors.dart';
import 'package:we_chat/utility/utility.dart';

class ChatRoomScreen extends StatefulWidget {
  final ChatRoomModel chatRoomModel;
  final UserModel targetUser;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomScreen(
      {super.key,
      required this.chatRoomModel,
      required this.targetUser,
      required this.userModel,
      required this.firebaseUser});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController messageController = TextEditingController();

  // method for send message..
  void messageSend() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg != "") {
      MessageModel msgModel = MessageModel(
        messageid: uuid.v1(),
        sender: widget.userModel.uid,
        createdon: DateTime?.now(),
        text: msg,
        seen: false,
      );
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoomModel.chatroomid)
          .collection("messages")
          .doc(msgModel.messageid)
          .set(msgModel.toMap());

      widget.chatRoomModel.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoomModel.chatroomid)
          .set(widget.chatRoomModel.toMap());
      log("message sent!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage(widget.targetUser.profilepic.toString()),
            ),
            horizontalSpaceSmall,
            Text(widget.targetUser.fullname.toString())
          ],
        ),
      ),
      body: SafeArea(
          child: SizedBox(
        child: Column(
          children: [
            // this is where the chats will go
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatRoomModel.chatroomid)
                    .collection("messages")
                    .orderBy("createdon", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;
                      return ListView.builder(
                        reverse: true,
                        itemCount: dataSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          MessageModel currentMessage = MessageModel.fromMap(
                              dataSnapshot.docs[index].data()
                                  as Map<String, dynamic>);
                          return Row(
                            mainAxisAlignment:
                                (currentMessage.sender == widget.userModel.uid)
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            children: [
                              Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  decoration: BoxDecoration(
                                    color: (currentMessage.sender ==
                                            widget.userModel.uid)
                                        ? grayD9D9D9
                                        : blue5AD5F966,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    currentMessage.text.toString(),
                                    style: TextStyle(
                                        color: (currentMessage.sender ==
                                                widget.userModel.uid)
                                            ? black000000
                                            : white),
                                  )),
                            ],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                            "An error occurred! please check your internet connection"),
                      );
                    } else {
                      return const Center(
                        child: Text("Say Hi to your new friend!"),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              color: grayD9D9D9,
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      maxLines: null,
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: "Enter Message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        messageSend();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: blue5AD5F9,
                      ))
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
