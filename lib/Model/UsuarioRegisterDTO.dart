import 'package:flutter_application_tareas/Model/Direccion.dart';

class UsuarioRegisterDTO {
  final String username;
  final String email;
  final String password;
  final String passwordRepeat;
  final Direccion direccion;

  UsuarioRegisterDTO({
    required this.username,
    required this.email,
    required this.password,
    required this.passwordRepeat,
    required this.direccion,
  });

  factory UsuarioRegisterDTO.fromJson(Map<String, dynamic> json) {
    return UsuarioRegisterDTO(
      username: json["username"],
      email: json["email"],
      password: json["password"],
      passwordRepeat: json["passwordRepeat"],
      direccion: Direccion.fromJson(json["direccion"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "password": password,
      "passwordRepeat": passwordRepeat,
      "direccion": direccion.toJson(),
    };
  }
}
