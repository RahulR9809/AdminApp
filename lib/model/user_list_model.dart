class UserModel {
  final String id;
  final String name;
  final String email;
  final bool isBlocked;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isBlocked,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? 'No Email',
      isBlocked: json['isBlocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'isBlocked': isBlocked,
    };
  }
}
