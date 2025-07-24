import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Message extends Equatable {
  final String id;
  final String senderId;

  final String encryptedData;
  final DateTime sentAt;
  final String chatId;

  const Message({
    required this.id,
    required this.senderId,
    required this.encryptedData,
    required this.sentAt,
    required this.chatId,
  });

  /// Create a Message model from a Firestore document map.
  /// [documentId] should be the Firestore document id.
  factory Message.fromMap(Map<String, dynamic> map, String documentId) {
    return Message(
      id: documentId,
      senderId: map['senderId'] as String,
      encryptedData: map['encryptedData'] as String,
      //    encryptedData: Map<String, dynamic>.from(map['encryptedData'] as Map),
      sentAt: (map['sentAt'] as Timestamp).toDate().toLocal(),
      chatId: map['chatId'] as String,

    );
  }

  /// Convert the Message model to a map for Firestore storage.
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'encryptedData': encryptedData,
      'sentAt':FieldValue.serverTimestamp(),
      'chatId': chatId,
    };
  }

  @override
  List<Object> get props => [id, senderId, encryptedData, sentAt , chatId];
}