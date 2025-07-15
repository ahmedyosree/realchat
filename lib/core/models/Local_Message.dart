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


  @override
  List<Object?> get props => [id , chatId, senderId, text, sentAt];

}