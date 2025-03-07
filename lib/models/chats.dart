class Chats {
  final int key;
  final String chats;

  Chats({required this.key, required this.chats});

  factory Chats.fromJson(Map<String, dynamic> json){
    return Chats(
      key: json['id'],
      chats: json['username']
    );
  }
}
