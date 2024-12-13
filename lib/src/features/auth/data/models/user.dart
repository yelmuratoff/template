import 'package:equatable/equatable.dart';

class UserDTO extends Equatable {
  const UserDTO({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.avatar,
    required this.creationAt,
    required this.updatedAt,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) => UserDTO(
        id: json['id'] as int,
        email: json['email'] as String,
        name: json['name'] as String,
        role: json['role'] as String,
        avatar: json['avatar'] as String,
        creationAt: json['creationAt'] as String,
        updatedAt: json['updatedAt'] as String,
      );
  final int id;
  final String email;
  final String name;
  final String role;
  final String avatar;
  final String creationAt;
  final String updatedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'role': role,
        'avatar': avatar,
        'creationAt': creationAt,
        'updatedAt': updatedAt,
      };

  static List<UserDTO> fromJsonList(List<dynamic> jsonList) => jsonList
      .map((json) => UserDTO.fromJson(json as Map<String, dynamic>))
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
