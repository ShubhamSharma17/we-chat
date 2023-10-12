class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participant;
  String? lastMessage;

  ChatRoomModel({this.chatroomid, this.participant, this.lastMessage});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participant = map["participant"];
    lastMessage = map["lastmessage"];
  }
  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participant": participant,
      "lastmessage": lastMessage,
    };
  }
}
