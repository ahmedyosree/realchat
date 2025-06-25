import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
class Chat extends Equatable {
  final String id;
  final List<String> people;
  final DateTime chatStartIn;

  const Chat({
    required this.id,
    required this.people,
    required this.chatStartIn,
  });

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as String,
      people: List<String>.from(map['people'] ?? []),
      chatStartIn: (map['chatStartIn'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'people': people,
      'chatStartIn':Timestamp.fromDate(chatStartIn),
    };
  }

  @override
  List<Object> get props => [id, people, chatStartIn];
}
