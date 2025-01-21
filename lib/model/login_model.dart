
class LoginModel {
  final String token;

  LoginModel({ required this.token});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      token: json['accessToken'],
    );
  }

  Map<String, dynamic> toJson() { 
    return {
      'token': token,
    };
  }
}
