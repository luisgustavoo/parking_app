import 'dart:convert';

class TokenModel {
  TokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.type,
  });

  factory TokenModel.fromMap(Map<String, dynamic> map) {
    return TokenModel(
      accessToken: map['access_token'] as String,
      refreshToken: map['refresh_token'] as String,
      type: map['type'] as String,
    );
  }

  factory TokenModel.fromJson(String source) =>
      TokenModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final String accessToken;
  final String refreshToken;
  final String type;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'type': type,
    };
  }

  String toJson() => json.encode(toMap());
}
