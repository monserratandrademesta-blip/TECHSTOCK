import 'package:flutter/material.dart';
import 'inicio.dart';
import 'inicio_empleado.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool esAdministrador = true;
  bool mostrarPassword = false;
  bool recordarSesion = true;

  final usuarioController =
      TextEditingController(text: 'admin@techstock.com');

  final passwordController = TextEditingController();

  @override
  void dispose() {
    usuarioController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // SIMULADOR DE INICIO DE SESIÓN
  void iniciarSesion() {
    if (esAdministrador) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const InicioScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const InicioEmpleadoScreen(),
        ),
      );
    }
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
                  style: TextStyle(
                    color: Color(0xFF444653),
                  ),
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
                  'Ingresa tus datos para continuar',
                ),

                const SizedBox(height: 25),

                // SELECTOR DE PERFIL
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: true,
                      label: Text('Administrador'),
                      icon: Icon(Icons.admin_panel_settings),
                    ),
                    ButtonSegment(
                      value: false,
                      label: Text('Empleado'),
                      icon: Icon(Icons.person),
                    ),
                  ],
                  selected: {esAdministrador},
                  onSelectionChanged: (value) {
                    setState(() {
                      esAdministrador = value.first;

                      usuarioController.text = esAdministrador
                          ? 'admin@techstock.com'
                          : 'lucia@techstock.com';

                      passwordController.clear();
                    });
                  },
                ),

                const SizedBox(height: 25),

                const Text(
                  'Correo electrónico',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
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
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: passwordController,
                  obscureText: !mostrarPassword,
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

                const SizedBox(height: 12),

                CheckboxListTile(
                  value: recordarSesion,
                  onChanged: (value) {
                    setState(() {
                      recordarSesion = value ?? false;
                    });
                  },
                  title: const Text('Recordar sesión'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),

                const SizedBox(height: 20),

                // BOTÓN DE ACCESO
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
                      esAdministrador
                          ? 'Ingresar como Administrador'
                          : 'Ingresar como Empleado',
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