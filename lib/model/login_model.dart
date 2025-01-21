// lib/models/login_model.dart

class LoginModel {
  final String token;

  LoginModel({ required this.token});

  // Factory constructor to create a LoginModel from JSON
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      token: json['accessToken'],
    );
  }

  // Method to convert LoginModel to JSON
  Map<String, dynamic> toJson() { 
    return {
      'token': token,
    };
  }
}
