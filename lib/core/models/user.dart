import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';


class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String nickname;
  final DateTime signInTime;
  final Map<String, dynamic> publicKeyInfo;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.nickname,
    required this.signInTime,
    required this.publicKeyInfo,
  });



  /// Factory constructor to create UserModel from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    final pkInfo = map['publicKeyInfo'] as Map<String, dynamic>?;
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      nickname: map['nickname'] as String,
      signInTime: (map['signInTime'] is String)
          ? DateTime.parse(map['signInTime'] as String).toLocal()
          : (map['signInTime'] as Timestamp).toDate().toLocal(),
      publicKeyInfo: {
        'publicKey': pkInfo?['publicKey'] as String,
        'Date':  (pkInfo?['Date'] is String)
            ? DateTime.parse(pkInfo?['Date'] as String).toLocal()
            :(pkInfo?['Date'] as Timestamp).toDate().toLocal(),
      },
    );
  }

  /// Converts a User object to a Firebase document (Map)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'nickname': nickname,
      'signInTime': FieldValue.serverTimestamp(),
      'publicKeyInfo': {
        'publicKey': publicKeyInfo['publicKey'],
        'Date': FieldValue.serverTimestamp() ,
      },
    };
  }


  @override
  List<Object> get props => [id, email, name, nickname, signInTime, publicKeyInfo];
}