class ChatRoomModel {
  String? chatroomid;
  List<String>? participant;

  ChatRoomModel({this.chatroomid, this.participant});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participant = map["participant"];
  }
}
