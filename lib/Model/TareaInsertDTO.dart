class TareaInsertDTO {
  final String titulo;
  final String cuerpo;
  final String username;

  TareaInsertDTO({
    required this.titulo,
    required this.cuerpo,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      "titulo": titulo,
      "cuerpo": cuerpo,
      "username": username,
    };
  }
}
