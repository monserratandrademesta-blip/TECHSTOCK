import 'package:flutter/material.dart';

const Color azul = Color(0xFF00288E);
const Color fondo = Color(0xFFFAF8FF);
const Color gris = Color(0xFF444653);

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
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
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Inicio',
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'Hola, Carlos',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
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
                  Icon(Icons.circle, color: Color(0xFF6FFBBE), size: 12),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Acciones rápidas',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _accion(context, Icons.add_box, '+ Entrada'),
                const SizedBox(width: 10),
                _accion(context, Icons.remove_circle, '- Salida'),
                const SizedBox(width: 10),
                _accion(context, Icons.category, 'Categorías'),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Resumen del almacén',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
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
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _alerta('iPhone 15 Pro 128GB', 'Solo quedan 2 unidades'),
            _alerta('MacBook Air M2', 'Solo queda 1 unidad'),
            _alerta('Cargador 65W GaN', 'Solo quedan 3 unidades'),
            const SizedBox(height: 24),
            const Text(
              'Últimos movimientos',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
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
        currentIndex: 0,
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
        onTap: (index) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Conectaremos esta sección próximamente'),
            ),
          );
        },
      ),
    );
  }

  static Widget _accion(
    BuildContext context,
    IconData icono,
    String titulo,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$titulo: sección pendiente de conectar')),
          );
        },
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
                Text(producto, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(detalle, style: const TextStyle(color: gris, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _movimiento(String producto, String cantidad, bool entrada) {
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