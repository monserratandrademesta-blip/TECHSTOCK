import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const String baseUrl = 'http://10.0.2.2:3001';

  static int? usuarioId;

  static Map<String, String> headers({int? usuarioId}) {
    return {
      'Content-Type': 'application/json',
      if (usuarioId != null) 'x-usuario-id': usuarioId.toString(),
    };
  }

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
      headers: headers(),
      body: jsonEncode({
        'correo': correo,
        'password': password,
        'rol': rol,
      }),
    ).timeout(const Duration(seconds: 15));

    final datos = jsonDecode(respuesta.body);

    if (respuesta.statusCode == 200) {
      final usuario = Map<String, dynamic>.from(datos['usuario']);
      usuarioId = int.tryParse(usuario['id'].toString());
      return usuario;
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
      headers: headers(),
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

  static Future<List<Map<String, dynamic>>> obtenerProductosCliente() async {
    final respuesta = await http.get(
      Uri.parse('$baseUrl/api/cliente/productos'),
      headers: headers(),
    );

    final datos = jsonDecode(respuesta.body);

    if (respuesta.statusCode == 200) {
      return List<Map<String, dynamic>>.from(datos);
    }

    throw Exception(datos['mensaje'] ?? 'No se pudieron cargar los productos');
  }

  static Future<Map<String, dynamic>> obtenerCuentaCliente({
    required int usuarioId,
  }) async {
    final respuesta = await http.get(
      Uri.parse('$baseUrl/api/cliente/cuenta'),
      headers: headers(usuarioId: usuarioId),
    );

    final datos = jsonDecode(respuesta.body);

    if (respuesta.statusCode == 200) {
      return Map<String, dynamic>.from(datos);
    }

    throw Exception(datos['mensaje'] ?? 'No se pudo cargar la cuenta');
  }

  static Future<List<Map<String, dynamic>>> obtenerPedidosCliente({
    required int usuarioId,
  }) async {
    final respuesta = await http.get(
      Uri.parse('$baseUrl/api/cliente/pedidos'),
      headers: headers(usuarioId: usuarioId),
    );

    final datos = jsonDecode(respuesta.body);

    if (respuesta.statusCode == 200) {
      return List<Map<String, dynamic>>.from(datos);
    }

    throw Exception(datos['mensaje'] ?? 'No se pudieron cargar los pedidos');
  }

  static Future<Map<String, dynamic>> crearPedidoCliente({
    required int usuarioId,
    required String metodoPago,
    required List<Map<String, dynamic>> productos,
  }) async {
    final respuesta = await http.post(
      Uri.parse('$baseUrl/api/cliente/pedidos'),
      headers: headers(usuarioId: usuarioId),
      body: jsonEncode({
        'metodo_pago': metodoPago,
        'productos': productos,
      }),
    );

    final datos = jsonDecode(respuesta.body);

    if (respuesta.statusCode == 201 || respuesta.statusCode == 200) {
      return Map<String, dynamic>.from(datos);
    }

    throw Exception(datos['mensaje'] ?? 'No se pudo registrar el pedido');
  }

  static Future<List<dynamic>> obtenerMovimientos(int usuarioId) async {
    final respuesta = await http.get(
      Uri.parse('$baseUrl/api/movimientos?limite=500'),
      headers: headers(usuarioId: usuarioId),
    );

    final datos = jsonDecode(respuesta.body);

    if (respuesta.statusCode == 200) {
      return List<dynamic>.from(datos);
    }

    throw Exception('No se pudieron cargar los movimientos');
  }
}