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
      signInTime: DateTime.parse((map['signInTime'] as String)),
      publicKeyInfo: {
        'publicKey': pkInfo?['publicKey'] as String,
        'Date':  DateTime.parse((pkInfo?['Date'] as String)),
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
      'signInTime': signInTime.toIso8601String(),
      'publicKeyInfo': {
        'publicKey': publicKeyInfo['publicKey'],
        'Date': publicKeyInfo['Date'].toIso8601String() ,
      },
    };
  }


  @override
  List<Object> get props => [id, email, name, nickname, signInTime, publicKeyInfo];
}