//Los DTO son para que puedas ingresar datos sin necesidad de que tenga todos los campos,  son simples data class con los diferentes campos
class TareaInsertDTO {
  final String titulo;
  final String cuerpo;
  final String username;

  TareaInsertDTO({
    required this.titulo,
    required this.cuerpo,
    required this.username,
  });
//Es necesario pasarlo a formato json para enviarlo en la API
  Map<String, dynamic> toJson() {
    return {
      "titulo": titulo,
      "cuerpo": cuerpo,
      "username": username,
    };
  }
}
