import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_application_tareas/Model/Tarea.dart';
import 'package:flutter_application_tareas/Model/TareaInsertDTO.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class ApiService {
  static Future<String?> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/usuarios/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["token"];
    } else {
      return null;
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
      return null;
    }
  }

  static Future<List<dynamic>?> postTareas(
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

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<Bool?> deleteTareas(String token, String idTarea) async {
    final url = Uri.parse("$baseUrl/tareas/tarea/$idTarea");
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
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
      print(response.body);
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
