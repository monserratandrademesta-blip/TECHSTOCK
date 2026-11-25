import 'package:flutter/material.dart';
import 'login.dart';
import 'inventario.dart';
import 'movimientos.dart';
import 'historial.dart';
import 'usuarios_admin.dart';

const Color azul = Color(0xFF00288E);
const Color fondo = Color(0xFFFAF8FF);
const Color gris = Color(0xFF444653);

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  int indiceActual = 0;

  void cerrarSesion() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  void abrirPantalla(Widget pantalla) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => pantalla),
    );
  }

  void navegar(int indice) {
    switch (indice) {
      case 0:
        setState(() => indiceActual = 0);
        break;
      case 1:
        abrirPantalla(const InventarioScreen());
        break;
      case 2:
        abrirPantalla(const MovimientosScreen());
        break;
      case 3:
        abrirPantalla(const HistorialScreen());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.inventory_2, color: azul),
            SizedBox(width: 10),
            Text(
              'TechStock',
              style: TextStyle(
                color: azul,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Center(
              child: Text(
                'Admin',
                style: TextStyle(
                  color: gris,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: cerrarSesion,
            icon: const Icon(Icons.logout, color: azul),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Inicio',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Hola, Carlos',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Text(
              'Administrador General',
              style: TextStyle(color: gris, fontSize: 14),
            ),
            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [azul, Color(0xFF0051D5)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(Icons.storefront, color: Colors.white, size: 30),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Turno Activo',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          'Sede Central',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.circle,
                    color: Color(0xFF6FFBBE),
                    size: 12,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Acciones rápidas',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                _accion(
                  Icons.add_box,
                  '+ Entrada',
                  () => abrirPantalla(
                    const MovimientosScreen(entradaInicial: true),
                  ),
                ),
                const SizedBox(width: 10),
                _accion(
                  Icons.remove_circle,
                  '- Salida',
                  () => abrirPantalla(
                    const MovimientosScreen(entradaInicial: false),
                  ),
                ),
                const SizedBox(width: 10),
                _accion(
                  Icons.category,
                  'Categorías',
                  () => abrirPantalla(const InventarioScreen()),
                ),
              ],
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  abrirPantalla(const UsuariosAdminScreen());
                },
                icon: const Icon(Icons.manage_accounts),
                label: const Text('Control de usuarios'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: azul,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Resumen del almacén',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: const [
                _Indicador(
                  titulo: 'Stock Total',
                  valor: '1,420',
                  icono: Icons.inventory_2,
                  color: azul,
                ),
                _Indicador(
                  titulo: 'Valor',
                  valor: '\$184,520',
                  icono: Icons.attach_money,
                  color: Color(0xFF00563A),
                ),
                _Indicador(
                  titulo: 'Stock Crítico',
                  valor: '3',
                  icono: Icons.warning_amber,
                  color: Colors.red,
                ),
                _Indicador(
                  titulo: 'Movimientos Hoy',
                  valor: '28',
                  icono: Icons.swap_horiz,
                  color: Color(0xFF0051D5),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Alertas de inventario',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _alerta('iPhone 15 Pro 128GB', 'Solo quedan 2 unidades'),
            _alerta('MacBook Air M2', 'Solo queda 1 unidad'),
            _alerta('Cargador 65W GaN', 'Solo quedan 3 unidades'),

            const SizedBox(height: 24),

            const Text(
              'Últimos movimientos',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _movimiento('AirPods Pro 2', '+15 unidades', true),
            _movimiento('Dell XPS 15', '-2 unidades', false),

            const SizedBox(height: 25),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: indiceActual,
        selectedItemColor: azul,
        unselectedItemColor: gris,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Movimientos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
        ],
        onTap: navegar,
      ),
    );
  }

  Widget _accion(
    IconData icono,
    String titulo,
    VoidCallback accion,
  ) {
    return Expanded(
      child: InkWell(
        onTap: accion,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          height: 85,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, color: azul, size: 25),
              const SizedBox(height: 7),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _alerta(String producto, String detalle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  detalle,
                  style: const TextStyle(color: gris, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _movimiento(
    String producto,
    String cantidad,
    bool entrada,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(
            entrada ? Icons.arrow_downward : Icons.arrow_upward,
            color: entrada ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              producto,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            cantidad,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: entrada ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class _Indicador extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;
  final Color color;

  const _Indicador({
    required this.titulo,
    required this.valor,
    required this.icono,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono, color: color, size: 25),
          const SizedBox(height: 8),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            titulo,
            style: const TextStyle(color: gris, fontSize: 12),
          ),
        ],
      ),
    );
  }
}