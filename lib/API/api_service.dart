import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_application_tareas/Model/Tarea.dart';
import 'package:flutter_application_tareas/Model/TareaInsertDTO.dart';
import 'package:flutter_application_tareas/Model/UsuarioRegisterDTO.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

//API service todos los enpoinst que al que puedes acceder
class ApiService {
  //Para todos es necesario mencionarle la URL, y una respuesta asincrona con cada tipo de petición
  static Future<String?> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/usuarios/login");
    final response = await http.post(
      url,
      //En la cabecera le añadimos el formato que le vamos a pasar.
      headers: {"Content-Type": "application/json"},
      //El cuerpo que vamos a enviarle a la api
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["token"];
    } else {
      return null;
    }
  }

  static Future<dynamic?> register(UsuarioRegisterDTO usuarioRegistrado) async {
    final url = Uri.parse("$baseUrl/usuarios/register");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(usuarioRegistrado.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final errorBody = jsonDecode(response.body);
      return errorBody["message"];
    }
  }

  static Future<List<dynamic>?> getTareas(String token) async {
    final url = Uri.parse("$baseUrl/tareas/tareas");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorBody = jsonDecode(response.body);
      return errorBody["message"];
    }
  }

  static Future<dynamic?> postTareas(
      String token, TareaInsertDTO tareainsertada) async {
    final url = Uri.parse("$baseUrl/tareas/tarea");
    final response = await http.post(
      url,
      body: jsonEncode(tareainsertada.toJson()),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final errorBody = jsonDecode(response.body);
      print(errorBody);
      return errorBody["message"];
    }
  }

  static Future<dynamic?> deleteTareas(String token, String idTarea) async {
    final url = Uri.parse("$baseUrl/tareas/tarea/$idTarea");
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 204) {
      return null;
    } else {
      final errorBody = jsonDecode(response.body);
      return errorBody["message"];
    }
  }

  static Future<dynamic> putTareas(
      String token, Map<String, dynamic> tareaUpdate) async {
    final url = Uri.parse("$baseUrl/tareas/tarea");
    final response = await http.put(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(tareaUpdate));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorBody = jsonDecode(response.body);
      return errorBody["message"];
    }
  }
}
