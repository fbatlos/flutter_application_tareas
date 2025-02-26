import 'package:jwt_decoder/jwt_decoder.dart';

bool esAdmin(String token) {
  Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  print(decodedToken["roles"]);

  return decodedToken["roles"] == "ROLE_ADMIN";
}
