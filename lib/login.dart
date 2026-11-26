import 'package:flutter/material.dart';
import 'inicio.dart';
import 'inicio_empleado.dart';
import 'cliente.dart';
import 'servicios/api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int rolSeleccionado = 0;
  bool mostrarPassword = false;
  bool cargando = false;

  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();

  String get rol {
    if (rolSeleccionado == 0) return 'administrador';
    if (rolSeleccionado == 1) return 'empleado';
    return 'cliente';
  }

  @override
  void dispose() {
    usuarioController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void cambiarRol(int nuevoRol) {
    setState(() {
      rolSeleccionado = nuevoRol;
      usuarioController.clear();
      passwordController.clear();
    });
  }

  Future<void> iniciarSesion() async {
    final correo = usuarioController.text.trim().toLowerCase();
    final password = passwordController.text;

    if (correo.isEmpty || password.isEmpty) {
      mostrarMensaje('Completa todos los campos');
      return;
    }

    setState(() => cargando = true);

    try {
      final usuario = await Api.login(
        correo: correo,
        password: password,
        rol: rol,
      );

      if (!mounted) return;

      final rolUsuario = usuario['rol'];

      if (rolUsuario == 'administrador') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InicioScreen(
              usuarioId: int.parse(usuario['id'].toString()),
              nombreAdministrador: usuario['nombre'].toString(),
            ),
          ),
        );
      } else if (rolUsuario == 'empleado') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InicioEmpleadoScreen(
              usuarioId: int.parse(usuario['id'].toString()),
              nombreEmpleado: usuario['nombre'].toString(),
            ),
          ),
        );
      } else if (rolUsuario == 'cliente') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ClienteScreen(),
          ),
        );
      } else {
        mostrarMensaje('Tipo de usuario no reconocido');
      }
    } catch (e) {
      if (mounted) {
        mostrarMensaje(
          e.toString().replaceFirst('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  Future<void> mostrarRegistro() async {
    final nombreController = TextEditingController();
    final correoController = TextEditingController();
    final passwordRegistroController = TextEditingController();
    final confirmarController = TextEditingController();

    bool registrando = false;
    bool mostrarRegistroPassword = false;

    await showDialog(
      context: context,
      barrierDismissible: !registrando,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, actualizarDialogo) {
            return AlertDialog(
              title: const Text(
                'Crear cuenta',
                style: TextStyle(
                  color: Color(0xFF00288E),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Regístrate como nuevo cliente'),
                    const SizedBox(height: 18),
                    TextField(
                      controller: nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre completo',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: correoController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passwordRegistroController,
                      obscureText: !mostrarRegistroPassword,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: confirmarController,
                      obscureText: !mostrarRegistroPassword,
                      decoration: const InputDecoration(
                        labelText: 'Confirmar contraseña',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        actualizarDialogo(() {
                          mostrarRegistroPassword =
                              !mostrarRegistroPassword;
                        });
                      },
                      child: Text(
                        mostrarRegistroPassword
                            ? 'Ocultar contraseñas'
                            : 'Mostrar contraseñas',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: registrando
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00288E),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: registrando
                      ? null
                      : () async {
                          final nombre = nombreController.text.trim();
                          final correo =
                              correoController.text.trim().toLowerCase();
                          final password =
                              passwordRegistroController.text;
                          final confirmar = confirmarController.text;

                          if (nombre.isEmpty ||
                              correo.isEmpty ||
                              password.isEmpty ||
                              confirmar.isEmpty) {
                            mostrarMensaje('Completa todos los campos');
                            return;
                          }

                          if (!correo.contains('@') ||
                              !correo.contains('.')) {
                            mostrarMensaje('Ingresa un correo válido');
                            return;
                          }

                          if (password.length < 6) {
                            mostrarMensaje(
                              'La contraseña debe tener al menos 6 caracteres',
                            );
                            return;
                          }

                          if (password != confirmar) {
                            mostrarMensaje(
                              'Las contraseñas no coinciden',
                            );
                            return;
                          }

                          actualizarDialogo(() {
                            registrando = true;
                          });

                          try {
                            await Api.registrar(
                              nombre: nombre,
                              correo: correo,
                              password: password,
                            );

                            if (!mounted) return;

                            Navigator.pop(dialogContext);

                            setState(() {
                              rolSeleccionado = 2;
                              usuarioController.clear();
                              passwordController.clear();
                            });

                            mostrarMensaje(
                              'Cuenta creada. Ahora puedes iniciar sesión.',
                            );
                          } catch (e) {
                            actualizarDialogo(() {
                              registrando = false;
                            });

                            mostrarMensaje(
                              e.toString().replaceFirst(
                                'Exception: ',
                                '',
                              ),
                            );
                          }
                        },
                  child: registrando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Registrarme'),
                ),
              ],
            );
          },
        );
      },
    );

    nombreController.dispose();
    correoController.dispose();
    passwordRegistroController.dispose();
    confirmarController.dispose();
  }

  void mostrarMensaje(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 25),
                Container(
                  width: 75,
                  height: 75,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00288E),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.inventory_2,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'TechStock',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF00288E),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Control Inteligente de Inventario Tech',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF444653)),
                ),
                const SizedBox(height: 35),
                const Text(
                  'Bienvenido',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Selecciona tu tipo de cuenta para continuar',
                ),
                const SizedBox(height: 20),
                SegmentedButton<int>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: 0,
                      label: Text('Admin'),
                      icon: Icon(Icons.admin_panel_settings),
                    ),
                    ButtonSegment(
                      value: 1,
                      label: Text('Empleado'),
                      icon: Icon(Icons.badge_outlined),
                    ),
                    ButtonSegment(
                      value: 2,
                      label: Text('Cliente'),
                      icon: Icon(Icons.person_outline),
                    ),
                  ],
                  selected: {rolSeleccionado},
                  onSelectionChanged: (value) {
                    cambiarRol(value.first);
                  },
                ),
                const SizedBox(height: 25),
                const Text(
                  'Correo electrónico',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: usuarioController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: 'usuario@techstock.com',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Contraseña',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: !mostrarPassword,
                  onSubmitted: (_) => iniciarSesion(),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          mostrarPassword = !mostrarPassword;
                        });
                      },
                      icon: Icon(
                        mostrarPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    hintText: 'Ingresa tu contraseña',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: cargando ? null : iniciarSesion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00288E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: cargando
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            rolSeleccionado == 0
                                ? 'Ingresar como Administrador'
                                : rolSeleccionado == 1
                                    ? 'Ingresar como Empleado'
                                    : 'Ingresar como Cliente',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                if (rolSeleccionado == 2) ...[
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: mostrarRegistro,
                    child: const Text(
                      '¿No tienes cuenta? Regístrate',
                      style: TextStyle(
                        color: Color(0xFF00288E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 30),
                const Text(
                  'Nodo Central de Logística • Región Sur-Este',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF757684),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}