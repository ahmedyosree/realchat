import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class LocalMessage extends Equatable{
  final String id;
  final String chatId;
  final String senderId;
  final String text;
  final DateTime sentAt;

  const LocalMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.sentAt,
  });



  factory LocalMessage.fromMap(Map<String, dynamic> map) {
    return LocalMessage(
      id: map['id'] as String,
      chatId: map['chatId'] as String,
      senderId: map['senderId'] as String,
      text: map['text'] as String,
      sentAt:( map['sentAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'sentAt': Timestamp.fromDate(sentAt),
    };
  }

  @override
  List<Object?> get props => [id , chatId, senderId, text, sentAt];

}