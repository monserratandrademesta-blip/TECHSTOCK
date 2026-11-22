import 'package:flutter/material.dart';
import 'inicio.dart';
import 'inicio_empleado.dart';
import 'cliente.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 0 = Administrador, 1 = Empleado, 2 = Cliente
  int rolSeleccionado = 0;

  bool mostrarPassword = false;

  final usuarioController =
      TextEditingController(text: 'admin@techstock.com');

  final passwordController = TextEditingController();

  final String correoAdmin = 'admin@techstock.com';
  final String passwordAdmin = 'Admin123';

  final String correoEmpleado = 'lucia@techstock.com';
  final String passwordEmpleado = 'Empleado123';

  final String correoCliente = 'cliente@techstock.com';
  final String passwordCliente = 'Cliente123';

  @override
  void dispose() {
    usuarioController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void cambiarRol(int nuevoRol) {
    setState(() {
      rolSeleccionado = nuevoRol;

      if (nuevoRol == 0) {
        usuarioController.text = correoAdmin;
      } else if (nuevoRol == 1) {
        usuarioController.text = correoEmpleado;
      } else {
        usuarioController.text = correoCliente;
      }

      passwordController.clear();
    });
  }

  void iniciarSesion() {
    final correo = usuarioController.text.trim().toLowerCase();
    final password = passwordController.text;

    if (correo.isEmpty || password.isEmpty) {
      mostrarMensaje('Completa todos los campos');
      return;
    }

    if (rolSeleccionado == 0) {
      if (correo == correoAdmin && password == passwordAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const InicioScreen(),
          ),
        );
      } else {
        mostrarMensaje('Correo o contraseña de administrador incorrectos');
      }
    } else if (rolSeleccionado == 1) {
      if (correo == correoEmpleado && password == passwordEmpleado) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const InicioEmpleadoScreen(),
          ),
        );
      } else {
        mostrarMensaje('Correo o contraseña de empleado incorrectos');
      }
    } else {
      if (correo == correoCliente && password == passwordCliente) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ClienteScreen(),
          ),
        );
      } else {
        mostrarMensaje('Correo o contraseña de cliente incorrectos');
      }
    }
  }

  void mostrarMensaje(String mensaje) {
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

                const Text('Selecciona tu tipo de cuenta para continuar'),

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
                    onPressed: iniciarSesion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00288E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
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