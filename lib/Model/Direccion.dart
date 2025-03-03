class Direccion {
  final String municipio;
  final String provincia;

  Direccion({required this.municipio, required this.provincia});

  factory Direccion.fromJson(Map<String, dynamic> json) {
    return Direccion(
      municipio: json["municipio"],
      provincia: json["provincia"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "municipio": municipio,
      "provincia": provincia,
    };
  }
}
