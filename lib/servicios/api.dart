import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const String baseUrl = 'http://10.0.2.2:3001';

  static Future<bool> comprobarConexion() async {
    try {
      final respuesta = await http
          .get(Uri.parse('$baseUrl/api/salud'))
          .timeout(const Duration(seconds: 10));

      return respuesta.statusCode == 200;
    } catch (e) {
      print('ERROR DE CONEXION: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> login({
    required String correo,
    required String password,
    required String rol,
  }) async {
    final respuesta = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'correo': correo,
        'password': password,
        'rol': rol,
      }),
    ).timeout(const Duration(seconds: 15));

    final datos = jsonDecode(respuesta.body);

    if (respuesta.statusCode == 200) {
      return Map<String, dynamic>.from(datos['usuario']);
    }

    throw Exception(datos['mensaje'] ?? 'No se pudo iniciar sesión');
  }

  static Future<void> registrar({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    final respuesta = await http.post(
      Uri.parse('$baseUrl/api/registro'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'correo': correo,
        'password': password,
      }),
    ).timeout(const Duration(seconds: 15));

    final datos = jsonDecode(respuesta.body);

    if (respuesta.statusCode != 201) {
      throw Exception(datos['mensaje'] ?? 'No se pudo crear la cuenta');
    }
  }
}