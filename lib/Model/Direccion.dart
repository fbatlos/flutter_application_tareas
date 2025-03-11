//Los DTO son para que puedas ingresar datos sin necesidad de que tenga todos los campos,  son simples data class con los diferentes campos
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
//Es necesario pasarlo a formato json para enviarlo en la API
  Map<String, dynamic> toJson() {
    return {
      "municipio": municipio,
      "provincia": provincia,
    };
  }
}
