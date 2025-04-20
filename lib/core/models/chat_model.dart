import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ChatModel extends Equatable {
  final String id;
  final List<String> people;
  final DateTime chatStartIn;

  const ChatModel({
    required this.id,
    required this.people,
    required this.chatStartIn,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] as String,
      people: List<String>.from(map['people'] ?? []),
      chatStartIn: map['chatStartIn'] is Timestamp
          ? (map['chatStartIn'] as Timestamp).toDate()
          : DateTime.parse(map['chatStartIn']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'people': people,
      'chatStartIn': chatStartIn.toIso8601String(),
    };
  }

  @override
  List<Object> get props => [id, people, chatStartIn];
}
