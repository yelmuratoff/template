import 'package:equatable/equatable.dart';

/// `TokenPair` is a value object that holds the access and refresh tokens.
class TokenPair extends Equatable {
  final String access;
  final String refresh;

  const TokenPair({
    required this.access,
    required this.refresh,
  });

  factory TokenPair.fromJson(Map<String, dynamic> json) => TokenPair(
        access: json['access_token'] as String,
        refresh: json['refresh_token'] as String,
      );

  Map<String, dynamic> toJson() => {
        'access_token': access,
        'refresh_token': refresh,
      };

  @override
  List<Object?> get props => [
        access,
        refresh,
      ];
}
