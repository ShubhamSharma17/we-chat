import 'package:flutter/material.dart';
import 'package:we_chat/utility/colors.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            // this is where the chats will go
            Expanded(child: Container()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              color: grayD9D9D9,
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter Message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
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
