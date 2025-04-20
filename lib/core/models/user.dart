import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';


class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String nickname;
  final DateTime signInTime;
  final List<String> chats;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.nickname,
    required this.signInTime,
    required this.chats,
  });

  /// Factory constructor to create UserModel from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      nickname: map['nickname'] as String,
      signInTime: map['signInTime'] is Timestamp
          ? (map['signInTime'] as Timestamp).toDate()
          : DateTime.parse(map['signInTime']),
      chats: List<String>.from(map['chats'] ?? []),
    );
  }

  /// Converts a User object to a Firebase document (Map)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'nickname': nickname,
      'signInTime': signInTime.toIso8601String(),
      'chats': chats,
    };
  }

  @override
  List<Object> get props => [id];
}