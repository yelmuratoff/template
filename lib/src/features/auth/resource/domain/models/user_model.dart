import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String email;
  final String name;
  final String role;
  final String avatar;
  final String creationAt;
  final String updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.avatar,
    required this.creationAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int,
        email: json['email'] as String,
        name: json['name'] as String,
        role: json['role'] as String,
        avatar: json['avatar'] as String,
        creationAt: json['creationAt'] as String,
        updatedAt: json['updatedAt'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'role': role,
        'avatar': avatar,
        'creationAt': creationAt,
        'updatedAt': updatedAt,
      };

  static List<UserModel> fromJsonList(List<dynamic> jsonList) => jsonList
      .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
      .toList();

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        role,
        avatar,
        creationAt,
        updatedAt,
      ];
}
