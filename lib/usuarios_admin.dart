import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsuariosAdminScreen extends StatefulWidget {
  const UsuariosAdminScreen({super.key});

  @override
  State<UsuariosAdminScreen> createState() => _UsuariosAdminScreenState();
}

class _UsuariosAdminScreenState extends State<UsuariosAdminScreen> {
  static const String baseUrl = 'http://10.0.2.2:3001';
  static const int adminId = 1;

  List<dynamic> usuarios = [];
  bool cargando = true;
  bool procesando = false;

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'x-usuario-id': adminId.toString(),
      };

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  bool estaActivo(dynamic valor) {
    return valor == 1 || valor == true || valor.toString() == '1';
  }

  Future<void> cargarUsuarios() async {
    if (mounted) setState(() => cargando = true);

    try {
      final respuesta = await http
          .get(
            Uri.parse('$baseUrl/api/usuarios'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 15));

      if (respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);

        if (mounted) {
          setState(() {
            usuarios = datos is List ? datos : [];
          });
        }
      } else {
        mostrarMensaje('Error al consultar usuarios: ${respuesta.statusCode}');
      }
    } catch (e) {
      mostrarMensaje('No se pudo conectar con el servidor');
    }

    if (mounted) setState(() => cargando = false);
  }

  void mostrarMensaje(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  Future<void> registrarEmpleado() async {
    final nombre = TextEditingController();
    final correo = TextEditingController();
    final password = TextEditingController();

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrar empleado'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombre,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: correo,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Correo'),
              ),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Registrar'),
          ),
        ],
      ),
    );

    if (confirmar != true) {
      nombre.dispose();
      correo.dispose();
      password.dispose();
      return;
    }

    if (nombre.text.trim().isEmpty ||
        correo.text.trim().isEmpty ||
        password.text.length < 6) {
      mostrarMensaje('Completa los datos. La contraseña debe tener 6 caracteres.');
      nombre.dispose();
      correo.dispose();
      password.dispose();
      return;
    }

    try {
      final respuesta = await http
          .post(
            Uri.parse('$baseUrl/api/usuarios'),
            headers: headers,
            body: jsonEncode({
              'nombre': nombre.text.trim(),
              'correo': correo.text.trim(),
              'password': password.text,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final datos = jsonDecode(respuesta.body);

      if (respuesta.statusCode == 201) {
        mostrarMensaje('Empleado registrado correctamente');
        await cargarUsuarios();
      } else {
        mostrarMensaje(datos['mensaje'] ?? 'No se pudo registrar');
      }
    } catch (e) {
      mostrarMensaje('Error al registrar empleado');
    }

    nombre.dispose();
    correo.dispose();
    password.dispose();
  }

  Future<void> editarUsuario(Map usuario) async {
    final nombre = TextEditingController(
      text: usuario['nombre']?.toString() ?? '',
    );
    final correo = TextEditingController(
      text: usuario['correo']?.toString() ?? '',
    );

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar usuario'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombre,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: correo,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Correo'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Guardar cambios'),
          ),
        ],
      ),
    );

    if (confirmar != true) {
      nombre.dispose();
      correo.dispose();
      return;
    }

    if (nombre.text.trim().isEmpty || !correo.text.contains('@')) {
      mostrarMensaje('Escribe un nombre y un correo válido');
      nombre.dispose();
      correo.dispose();
      return;
    }

    try {
      final respuesta = await http
          .put(
            Uri.parse('$baseUrl/api/usuarios/${usuario['id']}'),
            headers: headers,
            body: jsonEncode({
              'nombre': nombre.text.trim(),
              'correo': correo.text.trim(),
            }),
          )
          .timeout(const Duration(seconds: 15));

      final datos = jsonDecode(respuesta.body);

      if (respuesta.statusCode == 200) {
        mostrarMensaje('Usuario actualizado correctamente');
        await cargarUsuarios();
      } else {
        mostrarMensaje(datos['mensaje'] ?? 'No se pudo editar');
      }
    } catch (e) {
      mostrarMensaje('Error al editar usuario');
    }

    nombre.dispose();
    correo.dispose();
  }

  Future<void> cambiarEstado(Map usuario) async {
    if (usuario['rol'] == 'administrador') {
      mostrarMensaje('No puedes cambiar el estado de un administrador');
      return;
    }

    final activo = estaActivo(usuario['activo']);
    final nuevoEstado = activo ? 0 : 1;

    try {
      final respuesta = await http
          .patch(
            Uri.parse('$baseUrl/api/usuarios/${usuario['id']}/estado'),
            headers: headers,
            body: jsonEncode({'activo': nuevoEstado}),
          )
          .timeout(const Duration(seconds: 15));

      final datos = jsonDecode(respuesta.body);

      if (respuesta.statusCode == 200) {
        mostrarMensaje(nuevoEstado == 1
            ? 'Usuario activado'
            : 'Usuario desactivado');
        await cargarUsuarios();
      } else {
        mostrarMensaje(datos['mensaje'] ?? 'No se pudo cambiar el estado');
      }
    } catch (e) {
      mostrarMensaje('Error al cambiar el estado');
    }
  }

  Future<void> eliminarUsuario(Map usuario) async {
    if (usuario['rol'] == 'administrador' ||
        usuario['id'].toString() == adminId.toString()) {
      mostrarMensaje('No puedes eliminar esta cuenta de administrador');
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar usuario'),
        content: Text(
          '¿Seguro que deseas eliminar a ${usuario['nombre']}?\n\n'
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      final respuesta = await http
          .delete(
            Uri.parse('$baseUrl/api/usuarios/${usuario['id']}'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 15));

      final datos = jsonDecode(respuesta.body);

      if (respuesta.statusCode == 200) {
        mostrarMensaje('Usuario eliminado correctamente');
        await cargarUsuarios();
      } else {
        mostrarMensaje(datos['mensaje'] ?? 'No se pudo eliminar');
      }
    } catch (e) {
      mostrarMensaje('Error al eliminar usuario');
    }
  }

  Widget tarjetaUsuario(Map<String, dynamic> usuario) {
    final activo = estaActivo(usuario['activo']);
    final rol = usuario['rol']?.toString() ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: activo ? Colors.blue.shade50 : Colors.grey.shade300,
          child: Icon(
            rol == 'administrador'
                ? Icons.admin_panel_settings
                : rol == 'empleado'
                    ? Icons.badge
                    : Icons.person,
            color: Colors.blue.shade800,
          ),
        ),
        title: Text(
          usuario['nombre']?.toString() ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '${usuario['correo']}\n'
            '$rol · ${activo ? 'Activo' : 'Inactivo'}',
          ),
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (opcion) {
            if (opcion == 'editar') {
              editarUsuario(usuario);
            } else if (opcion == 'estado') {
              cambiarEstado(usuario);
            } else if (opcion == 'eliminar') {
              eliminarUsuario(usuario);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'editar',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            if (rol != 'administrador')
              PopupMenuItem(
                value: 'estado',
                child: Row(
                  children: [
                    Icon(
                      activo ? Icons.block : Icons.check_circle,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(activo ? 'Desactivar' : 'Activar'),
                  ],
                ),
              ),
            if (rol != 'administrador')
              const PopupMenuItem(
                value: 'eliminar',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Eliminar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de usuarios'),
        actions: [
          IconButton(
            onPressed: cargando ? null : cargarUsuarios,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: registrarEmpleado,
        icon: const Icon(Icons.person_add),
        label: const Text('Nuevo empleado'),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : usuarios.isEmpty
              ? RefreshIndicator(
                  onRefresh: cargarUsuarios,
                  child: ListView(
                    children: const [
                      SizedBox(height: 180),
                      Center(child: Text('No hay usuarios registrados')),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: cargarUsuarios,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 90, top: 8),
                    itemCount: usuarios.length,
                    itemBuilder: (context, index) {
                      final usuario =
                          Map<String, dynamic>.from(usuarios[index]);
                      return tarjetaUsuario(usuario);
                    },
                  ),
                ),
    );
  }
}