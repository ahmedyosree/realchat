import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Message extends Equatable {
  final String id;
  final String senderId;
  // Instead of a plain text string, we store encrypted data as a Map.
  // This map should contain keys like 'cipherText', 'nonce', and 'mac'
  final Map<String, dynamic> encryptedData;
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.senderId,
    required this.encryptedData,
    required this.timestamp,
  });

  /// Create a Message model from a Firestore document map.
  /// [documentId] should be the Firestore document id.
  factory Message.fromMap(Map<String, dynamic> map, String documentId) {
    return Message(
      id: documentId,
      senderId: map['senderId'] as String,
      encryptedData: map['encryptedData'] as Map<String, dynamic>,
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.parse(map['timestamp']),
    );
  }

  /// Convert the Message model to a map for Firestore storage.
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'encryptedData': encryptedData,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  List<Object> get props => [id, senderId, encryptedData, timestamp];
}