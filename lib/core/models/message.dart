import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Message extends Equatable {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> map, String documentId) {
    return Message(
      id: documentId,
      senderId: map['senderId'] as String,
      text: map['text'] as String,
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  List<Object> get props => [id, senderId, text, timestamp];
}
