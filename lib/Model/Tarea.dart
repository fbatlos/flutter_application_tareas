import 'dart:ffi';

//Los DTO son para que puedas ingresar datos sin necesidad de que tenga todos los campos,  son simples data class con los diferentes campos
class Tarea {
  final String id;
  final String titulo;
  final String cuerpo;
  final String username;
  final DateTime fecha_pub;
  final Bool completada;

  Tarea(
      {required this.id,
      required this.titulo,
      required this.cuerpo,
      required this.username,
      required this.fecha_pub,
      required this.completada});
//Es necesario pasarlo a formato json para enviarlo en la API
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "titulo": titulo,
      "cuerpo": cuerpo,
      "username": username,
      "fecha_pub": fecha_pub,
      "completada": completada
    };
  }
}
