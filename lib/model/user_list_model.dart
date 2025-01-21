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

  // Factory method to parse JSON data into a UserModel object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? 'No Email',
      isBlocked: json['isBlocked'] ?? false,
    );
  }

  // Method to convert the UserModel object back to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'isBlocked': isBlocked,
    };
  }
}
