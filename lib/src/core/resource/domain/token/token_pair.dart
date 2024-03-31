import 'package:equatable/equatable.dart';

class TokenPair extends Equatable {
  final String access;
  final String refresh;

  const TokenPair({
    required this.access,
    required this.refresh,
  });

  factory TokenPair.fromJson(Map<String, dynamic> json) => TokenPair(
        access: json['access'] as String,
        refresh: json['refresh'] as String,
      );

  Map<String, dynamic> toJson() => {
        'access': access,
        'refresh': refresh,
      };

  @override
  List<Object?> get props => [
        access,
        refresh,
      ];
}
