import 'dart:ffi';

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
