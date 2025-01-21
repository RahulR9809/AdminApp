class Driver {
  final String id;
  final String? name;
  final String email;
  final bool isAccepted;
  final bool isBlocked;

  Driver({
    required this.id,
    required this.name,
    required this.email,
    required this.isAccepted,
    required this.isBlocked,
  });

  // Convert Driver object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isAccepted': isAccepted,
      'isBlocked': isBlocked,
    };
  }

  // Create Driver object from JSON
  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isAccepted: json['isAccepted'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
    );
  }
}
