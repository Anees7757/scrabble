import 'dart:io';

class User {
  final String username;
  final String email;
  final String password;
  final File image;

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'image': image,
    };
  }
}
