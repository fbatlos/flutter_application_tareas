import 'package:jwt_decoder/jwt_decoder.dart';

//Usamos la libreria para poder decodificar el token para saber si es admin o no, ya que la pantalla mostrará mas o menos información
bool esAdmin(String token) {
  Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  print(decodedToken["roles"]);

  return decodedToken["roles"] == "ROLE_ADMIN";
}
