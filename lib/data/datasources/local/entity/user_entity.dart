class UserEntity {
  int? localId;
  int remoteId;
  String username;
  String email;
  String password;
  String role;
  String? profileImage;

  UserEntity({
    this.localId,
    required this.remoteId,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.profileImage,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json, [int? localKey]) {
    return UserEntity(
      localId: localKey ?? json['localId'] as int?,
      remoteId: json['remoteId'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
      profileImage: json['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'remoteId': remoteId,
      'username': username,
      'email': email,
      'password': password,
      'role': role,
      'profileImage': profileImage,
    };
  }

  UserEntity copyWith({
    int? localId,
    int? remoteId,
    String? username,
    String? email,
    String? password,
    String? role,
    String? profileImage,
  }) {
    return UserEntity(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
