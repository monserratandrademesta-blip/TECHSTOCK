import 'package:flutter/material.dart';
import 'empleado_inventario.dart';

const Color _fondoInicio = Color(0xFFFAF8FF);
const Color _primarioInicio = Color(0xFF00288E);
const Color _secundarioInicio = Color(0xFF0051D5);
const Color _textoInicio = Color(0xFF131B2E);
const Color _textoSuaveInicio = Color(0xFF444653);
const Color _contenedorInicio = Color(0xFFEAEDFF);
const Color _errorInicio = Color(0xFFBA1A1A);
const Color _exitoInicio = Color(0xFF00563A);

class EmpleadoInicioScreen extends StatefulWidget {
  const EmpleadoInicioScreen({super.key});

  @override
  State<EmpleadoInicioScreen> createState() => _EmpleadoInicioScreenState();
}

class _EmpleadoInicioScreenState extends State<EmpleadoInicioScreen> {
  void _mensaje(String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(texto),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondoInicio,
      appBar: AppBar(
        backgroundColor: _fondoInicio,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 64,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _primarioInicio,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.inventory_2_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'TechStock',
                        style: TextStyle(
                          color: _primarioInicio,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDAE2FD),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Empleado',
                          style: TextStyle(
                            color: _textoSuaveInicio,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Lucía Torres · Ventas/Alm',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _textoSuaveInicio,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Cerrar sesión',
              onPressed: () => _mensaje('Sesión cerrada'),
              icon: const Icon(
                Icons.logout_rounded,
                color: _textoSuaveInicio,
              ),
            ),
            const CircleAvatar(
              radius: 16,
              backgroundColor: _primarioInicio,
              child: Icon(Icons.person_rounded, color: Colors.white, size: 19),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _perfil(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _accesoRapido(
                      icono: Icons.shopping_cart_checkout_rounded,
                      titulo: 'Registrar\nSalida',
                      subtitulo: 'Venta rápida',
                      colorFondo: const Color(0xFFDBE1FF),
                      onTap: () => _mensaje('Registrar salida seleccionado'),
                    ),
                    const SizedBox(width: 8),
                    _accesoRapido(
                      icono: Icons.manage_search_rounded,
                      titulo: 'Consultar\nStock',
                      subtitulo: 'Por modelo o SKU',
                      colorFondo: const Color(0xFFDDE1FF),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmpleadoInventarioScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _accesoRapido(
                      icono: Icons.move_to_inbox_rounded,
                      titulo: 'Recepción',
                      subtitulo: 'Albaranes',
                      colorFondo: const Color(0xFFDAE2FD),
                      onTap: () => _mensaje('Recepción seleccionada'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _tituloSeccion(
                  'Tu Rendimiento Hoy',
                  accion: 'Turno Mañana',
                  onTap: null,
                ),
                const SizedBox(height: 8),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.35,
                  children: [
                    _metrica(
                      titulo: 'Mis salidas',
                      valor: '14',
                      unidad: 'unids',
                      detalle: '+3 frente a ayer',
                      icono: Icons.outbox_rounded,
                      colorDetalle: _exitoInicio,
                    ),
                    _metrica(
                      titulo: 'Búsquedas stock',
                      valor: '38',
                      unidad: 'consultas',
                      detalle: '100% resueltas',
                      icono: Icons.search_rounded,
                      colorDetalle: _textoSuaveInicio,
                    ),
                    _metrica(
                      titulo: 'Físico en tienda',
                      valor: '1,420',
                      unidad: 'piezas',
                      detalle: 'Conteo regular',
                      icono: Icons.inventory_2_outlined,
                      colorDetalle: _textoSuaveInicio,
                    ),
                    _metrica(
                      titulo: 'Stock Mínimo',
                      valor: '3',
                      unidad: 'alertas',
                      detalle: 'Prioridad cliente',
                      icono: Icons.warning_amber_rounded,
                      esAlerta: true,
                      colorDetalle: _errorInicio,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _tituloAlerta(),
                const SizedBox(height: 8),
                _alertaStock(
                  icono: Icons.phone_iphone_rounded,
                  nombre: 'iPhone 15 Pro 128GB',
                  sku: 'SKU: APL-15P-128T',
                  cantidad: '2 unids',
                  ubicacion: 'Solo en mostrador principal',
                  iconoUbicacion: Icons.storefront_rounded,
                  esCritico: true,
                ),
                const SizedBox(height: 8),
                _alertaStock(
                  icono: Icons.laptop_mac_rounded,
                  nombre: 'MacBook Air M2 256GB',
                  sku: 'SKU: APL-MBA-M2SL',
                  cantidad: '1 unid',
                  ubicacion: 'Exhibición en vitrina B2',
                  iconoUbicacion: Icons.lock_rounded,
                  esCritico: true,
                ),
                const SizedBox(height: 8),
                _alertaStock(
                  icono: Icons.headphones_rounded,
                  nombre: 'Sony WH-1000XM5 ANC',
                  sku: 'SKU: SNY-WH5-BLK',
                  cantidad: '3 unids',
                  ubicacion: 'Almacén pasillo 3, nivel 1',
                  iconoUbicacion: Icons.archive_outlined,
                  esCritico: false,
                ),
                const SizedBox(height: 20),
                _tituloSeccion(
                  'Mis Movimientos Recientes',
                  accion: 'Ver registro completo',
                  onTap: () => _mensaje('Mostrando registro completo'),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: _decoracionTarjeta(),
                  child: Column(
                    children: [
                      _movimiento(
                        titulo: 'Salida: iPad 10th Gen 64GB',
                        detalle: 'Ticket #TK-4892 · Venta mostrador',
                        cantidad: '-1 unid',
                        hora: '11:42 AM',
                      ),
                      _divisor(),
                      _movimiento(
                        titulo: 'Consulta: AirPods Pro 2da Gen',
                        detalle: 'Ubicación física: Gaveta 4',
                        cantidad: 'En stock (8)',
                        hora: '11:15 AM',
                        colorCantidad: _exitoInicio,
                      ),
                      _divisor(),
                      _movimiento(
                        titulo: 'Salida: Cargador USB-C 20W',
                        detalle: 'Ticket #TK-4888 · Accesorio',
                        cantidad: '-2 unids',
                        hora: '10:30 AM',
                      ),
                      _divisor(),
                      _movimiento(
                        titulo: 'Recepción interna: Hub Anker 7-in-1',
                        detalle: 'Traspaso desde almacén central',
                        cantidad: '+5 unids',
                        hora: '09:12 AM',
                        colorCantidad: _secundarioInicio,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              backgroundColor: _secundarioInicio,
              foregroundColor: Colors.white,
              onPressed: () => _mensaje(
                'Cámara iniciada · Escaneando código de producto...',
              ),
              child: const Icon(Icons.qr_code_scanner_rounded),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _barraInferior(),
    );
  }

  Widget _perfil() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _decoracionTarjeta(),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDAE2FD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: _primarioInicio,
                      size: 30,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6FFBBE),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Hola, Lucía Torres!',
                      style: TextStyle(
                        color: _textoInicio,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Asesora de Ventas & Almacén Tienda Norte',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _textoSuaveInicio,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: _contenedorInicio,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: IconButton(
                  tooltip: 'Cerrar turno',
                  onPressed: () => _mensaje('Turno cerrado'),
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: _textoSuaveInicio,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E7FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 14,
                    color: Color(0xFF173BAB),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Rol: Operador de Tienda',
                    style: TextStyle(
                      color: Color(0xFF173BAB),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _accesoRapido({
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required Color colorFondo,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            height: 118,
            padding: const EdgeInsets.all(10),
            decoration: _decoracionTarjeta(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorFondo,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icono, color: _primarioInicio, size: 22),
                ),
                const SizedBox(height: 6),
                Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _textoInicio,
                    fontSize: 10,
                    height: 1.1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitulo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _textoSuaveInicio,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tituloSeccion(
    String titulo, {
    required String accion,
    required VoidCallback? onTap,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(
              color: _textoInicio,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (onTap == null)
          Text(
            accion,
            style: const TextStyle(
              color: _secundarioInicio,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          )
        else
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              foregroundColor: _secundarioInicio,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 26),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              accion,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }

  Widget _metrica({
    required String titulo,
    required String valor,
    required String unidad,
    required String detalle,
    required IconData icono,
    required Color colorDetalle,
    bool esAlerta = false,
  }) {
    final colorPrincipal = esAlerta ? _errorInicio : _textoInicio;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _decoracionTarjeta(
        color: esAlerta ? const Color(0xFFFFEFED) : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  titulo,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: esAlerta ? _errorInicio : _textoSuaveInicio,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                icono,
                size: 17,
                color: esAlerta ? _errorInicio : _secundarioInicio,
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                valor,
                style: TextStyle(
                  color: colorPrincipal,
                  fontSize: 28,
                  height: 0.9,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  unidad,
                  style: TextStyle(
                    color: esAlerta ? _errorInicio : _textoSuaveInicio,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            detalle,
            style: TextStyle(
              color: colorDetalle,
              fontSize: 8,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tituloAlerta() {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: _errorInicio,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        const Expanded(
          child: Text(
            'Atención: Últimas Unidades',
            style: TextStyle(
              color: _textoInicio,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFFFDAD6),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'Mostrador',
            style: TextStyle(
              color: Color(0xFF93000A),
              fontSize: 8,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _alertaStock({
    required IconData icono,
    required String nombre,
    required String sku,
    required String cantidad,
    required String ubicacion,
    required IconData iconoUbicacion,
    required bool esCritico,
  }) {
    final colorCantidad = esCritico ? _errorInicio : _secundarioInicio;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: _decoracionTarjeta(),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E7FF),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icono, color: _primarioInicio, size: 30),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        nombre,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _textoInicio,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: esCritico
                            ? const Color(0xFFFFDAD6)
                            : const Color(0xFFDAE2FD),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cantidad,
                        style: TextStyle(
                          color: colorCantidad,
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  sku,
                  style: const TextStyle(
                    color: _textoSuaveInicio,
                    fontSize: 9,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(iconoUbicacion, size: 13, color: colorCantidad),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        ubicacion,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorCantidad,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _movimiento({
    required String titulo,
    required String detalle,
    required String cantidad,
    required String hora,
    Color colorCantidad = _textoInicio,
  }) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _textoInicio,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detalle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _textoSuaveInicio,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                cantidad,
                style: TextStyle(
                  color: colorCantidad,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                hora,
                style: const TextStyle(
                  color: _textoSuaveInicio,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divisor() {
    return const Divider(height: 1, color: Color(0xFFF2F3FF));
  }

  Widget _barraInferior() {
    return SafeArea(
      top: false,
      child: Container(
        height: 65,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 12,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          children: [
            _itemNavegacion(
              icono: Icons.dashboard_rounded,
              titulo: 'Inicio',
              seleccionado: true,
              onTap: () {},
            ),
            _itemNavegacion(
              icono: Icons.inventory_2_rounded,
              titulo: 'Inventario',
              seleccionado: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EmpleadoInventarioScreen(),
                  ),
                );
              },
            ),
            _itemNavegacion(
              icono: Icons.swap_horiz_rounded,
              titulo: 'Movimientos',
              seleccionado: false,
              onTap: () => _mensaje('Módulo Movimientos pendiente de integrar'),
            ),
            _itemNavegacion(
              icono: Icons.badge_rounded,
              titulo: 'Mi Turno',
              seleccionado: false,
              onTap: () => _mensaje('Módulo Mi Turno pendiente de integrar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemNavegacion({
    required IconData icono,
    required String titulo,
    required bool seleccionado,
    required VoidCallback onTap,
  }) {
    final color = seleccionado ? _secundarioInicio : _textoSuaveInicio;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, color: color, size: 21),
            const SizedBox(height: 3),
            Text(
              titulo,
              style: TextStyle(
                color: color,
                fontSize: 8,
                fontWeight: seleccionado ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _decoracionTarjeta({Color color = Colors.white}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
}