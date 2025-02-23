import 'package:equatable/equatable.dart';

class ChatModel extends Equatable {
  final String id;
  final List<String> people;
  // Each message is represented as a Map with 'id' and 'text' keys.
  final List<Map<String, String>> messages;

  const ChatModel({
    required this.id,
    required this.people,
    required this.messages,
  });

  /// Creates a ChatModel from a map.
  factory ChatModel.fromMap(Map<String, dynamic> map) {
    List<Map<String, String>> messagesList = [];
    if (map['messages'] != null) {
      for (var message in map['messages']) {
        messagesList.add({
          'id': message['id'] as String,
          'text': message['text'] as String,
        });
      }
    }
    return ChatModel(
      id: map['id'] as String,
      people: List<String>.from(map['people'] ?? []),
      messages: messagesList,
    );
  }

  /// Converts the ChatModel to a map for Firebase storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'people': people,
      'messages': messages,
    };
  }

  @override
  List<Object> get props => [id, people, messages];
}
