class LocalMessage {
  final String id;
  final String chatId; // Add chatId to link messages to chats locally
  final String senderId;
  final String text;
  final int timestamp; // Store as milliseconds since epoch for SQLite

  const LocalMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
    };
  }

  factory LocalMessage.fromMap(Map<String, dynamic> map) {
    return LocalMessage(
      id: map['id'] as String,
      chatId: map['chatId'] as String,
      senderId: map['senderId'] as String,
      text: map['text'] as String,
      timestamp: map['timestamp'] as int,
    );
  }
}