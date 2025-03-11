import 'package:flutter_application_tareas/Model/Direccion.dart';

//Los DTO son para que puedas ingresar datos sin necesidad de que tenga todos los campos,  son simples data class con los diferentes campos

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
//Es necesario pasarlo a formato json para enviarlo en la API
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
