import 'package:flutter/material.dart';

const Color fondo = Color(0xFFFAF8FF);
const Color tarjeta = Colors.white;
const Color azul = Color(0xFF00288E);
const Color azulSecundario = Color(0xFF0051D5);
const Color texto = Color(0xFF131B2E);
const Color gris = Color(0xFF444653);
const Color verde = Color(0xFF00563A);
const Color rojo = Color(0xFFBA1A1A);
const Color superficie = Color(0xFFF2F3FF);

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  int paginaSeleccionada = 0;

  void mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,

      // ENCABEZADO
      appBar: AppBar(
        backgroundColor: fondo,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.inventory_2, color: azul, size: 30),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TechStock',
                  style: TextStyle(
                    color: texto,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Inicio',
                  style: TextStyle(
                    color: gris,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Admin',
                    style: TextStyle(
                        color: texto,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
                Text('En línea',
                    style: TextStyle(color: verde, fontSize: 10)),
              ],
            ),
            const SizedBox(width: 10),
            const CircleAvatar(
              radius: 17,
              backgroundColor: Color(0xFFDAE2FD),
              child: Icon(Icons.person, color: azul),
            ),
          ],
        ),
      ),

      // CONTENIDO PRINCIPAL
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // SALUDO Y ESTADO
            _tarjeta(
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFFDAE2FD),
                        child: Icon(Icons.person,
                            color: azul, size: 30),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    'Hola, Carlos',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: texto,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(Icons.verified,
                                    color: azulSecundario, size: 17),
                              ],
                            ),
                            Text(
                              'Administrador General',
                              style: TextStyle(
                                  color: gris, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => mostrarMensaje(
                            'Cerrar sesión'),
                        icon: const Icon(Icons.logout, color: gris),
                        style: IconButton.styleFrom(
                          backgroundColor: superficie,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5F5EC),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '●  TURNO ACTIVO • SEDE CENTRAL',
                            style: TextStyle(
                              color: verde,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('08:42 AM',
                          style: TextStyle(
                              color: gris, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ACCIONES INMEDIATAS
            _titulo('ACCIONES INMEDIATAS'),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _accion(
                    Icons.add_box,
                    '+ Entrada',
                    const Color(0xFFE5F5EC),
                    verde,
                    () => mostrarMensaje('Registrar entrada'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _accion(
                    Icons.indeterminate_check_box,
                    '- Salida',
                    const Color(0xFFFFDAD6),
                    rojo,
                    () => mostrarMensaje('Registrar salida'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _accion(
                    Icons.category,
                    'Categorías',
                    const Color(0xFFDDE1FF),
                    azul,
                    () => mostrarMensaje('Consultar categorías'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // MÉTRICAS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _titulo('MÉTRICAS DE ALMACÉN'),
                const Text('Sincronizado',
                    style: TextStyle(
                        color: azulSecundario, fontSize: 11)),
              ],
            ),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.45,
              children: [
                _metrica(
                  Icons.inventory_2,
                  '1,420',
                  'Stock Total (Unidades)',
                  '+4.2%',
                  verde,
                  const Color(0xFFE2E7FF),
                ),
                _metrica(
                  Icons.payments,
                  '\$184,520',
                  'Valor en Almacén',
                  'USD',
                  azulSecundario,
                  const Color(0xFFDDE1FF),
                ),
                _metrica(
                  Icons.warning,
                  '3',
                  'Reponer pronto',
                  'Crítico',
                  rojo,
                  const Color(0xFFFFDAD6),
                ),
                _metrica(
                  Icons.sync_alt,
                  '28',
                  '18 ventas • 10 ingresos',
                  'Hoy',
                  gris,
                  const Color(0xFFEAEDFF),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ALERTAS DE STOCK BAJO
            Row(
              children: [
                Expanded(child: _titulo('ALERTAS DE STOCK BAJO')),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: rojo,
                    shape: BoxShape.circle,
                  ),
                  child: const Text('3',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () =>
                      mostrarMensaje('Ver todas las alertas'),
                  child: const Text('Ver todas'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            _alerta(
              'iPhone 15 Pro 128GB',
              'SKU-APL-15P',
              'Quedan 2 unids.',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDCF1TOzRa98rGVDB-EHkaYhTkbIqtFEaW9UhnSk4-CfJdGEsrSw3UJSxY_9SVSXttPBccB-0KCwJwH7D9iW5f4bdpTHDKKji_88ZaHFSM4C82X90P-s4nNudbIXqTf3VAVuxM1_1VmYbxQZYK7N64K2WqK6S0WJQtFp5nC7cq3UC2K1uK3uX9PzMwKaYFSeRfhANASJvb0c0MPv7BCo5DgMHO_B3c7kCOtMUrVsBUp',
            ),
            _alerta(
              'MacBook Air M2 256GB',
              'SKU-APL-M2A',
              'Queda 1 unid.',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCdDz1nFup6xo5znY84zRC-ASviToPdZ_awx03r0RhIx8fFCwf7Om1fOVv1FVrEvHJEPFZ3qKwMH5ETdLUld9TkmELUdimfXbHo7WyvO-CiSLmAzlweuBZMFKmiOQ42vbZJAzUbvroY398SjKKebfDPfYmdd5A86DT_d16xOA0lO6Rd6rKT63513Wnm-RLyZKYTUZtqXwOh76gIrqLXEUEwS2G6iQMgC_lIpcB2Ov1p',
            ),
            _alerta(
              'Cargador Rápido 65W GaN',
              'SKU-ACC-65G',
              'Quedan 3 unids.',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDWuZpE0lICWllHuagGK2vfxh749plzwIlo56TSVCa2WZJva9dxG0opKwKkEFwX8oiB7ux52m8wgLvlkOah0ZH7dJny84hM8tSN8qg58ek8mPP0wvOxxIeh7QTeLyOf-oTyXauvO5pTqNLCez61cDxDp2enlbTSv1eAyKbkNCDBgIVJiV8V1JS4iHRHEfjSAZKI5Wst5ox9vSjg2hNFVf9wr-0PW-l08R7KAXN-xIQg',
            ),

            const SizedBox(height: 24),

            // ÚLTIMOS MOVIMIENTOS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _titulo('ÚLTIMOS MOVIMIENTOS'),
                TextButton(
                  onPressed: () =>
                      mostrarMensaje('Abrir historial completo'),
                  child: const Text('Historial completo'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            _movimiento(
              Icons.arrow_downward,
              'AirPods Pro 2da Gen',
              '+15',
              'Ingreso por recepción de proveedor',
              '08:15 AM',
              'Completado',
              verde,
            ),
            _movimiento(
              Icons.arrow_upward,
              'Dell XPS 15 OLED',
              '-2',
              'Venta en mostrador #04',
              '07:50 AM',
              'Facturado',
              rojo,
            ),
          ],
        ),
      ),

      // NAVEGACIÓN INFERIOR
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _nav(Icons.dashboard, 'Inicio', 0),
              _nav(Icons.inventory_2, 'Inventario', 1),
              _nav(Icons.swap_vert, 'Movimientos', 2),
              _nav(Icons.history, 'Historial', 3),
            ],
          ),
        ),
      ),
    );
  }

  // FUNCIONES AUXILIARES

  Widget _titulo(String textoTitulo) {
    return Text(
      textoTitulo,
      style: const TextStyle(
        color: gris,
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.7,
      ),
    );
  }

  Widget _tarjeta({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tarjeta,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _accion(
    IconData icono,
    String nombre,
    Color fondoIcono,
    Color colorIcono,
    VoidCallback accion,
  ) {
    return GestureDetector(
      onTap: accion,
      child: _tarjeta(
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: fondoIcono,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icono, color: colorIcono),
            ),
            const SizedBox(height: 8),
            Text(
              nombre,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: texto),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metrica(
    IconData icono,
    String valor,
    String descripcion,
    String etiqueta,
    Color color,
    Color fondoIcono,
  ) {
    return _tarjeta(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: fondoIcono,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icono, color: color, size: 19),
              ),
              Flexible(
                child: Text(
                  etiqueta,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  valor,
                  style: TextStyle(
                    color: color == rojo ? rojo : texto,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                descripcion,
                style: const TextStyle(
                  color: gris,
                  fontSize: 10,
                ),
                maxLines: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _alerta(
    String nombre,
    String sku,
    String cantidad,
    String imagen,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tarjeta,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imagen,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.devices, color: azul, size: 30),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nombre,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: texto),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(sku,
                    style: const TextStyle(
                        fontSize: 10, color: gris)),
                Text(cantidad,
                    style: const TextStyle(
                        fontSize: 10,
                        color: rojo,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 5),
          ElevatedButton(
            onPressed: () => mostrarMensaje('Solicitar: $nombre'),
            style: ElevatedButton.styleFrom(
              backgroundColor: azul,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(0, 34),
            ),
            child: const Text('Pedir',
                style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _movimiento(
    IconData icono,
    String nombre,
    String cantidad,
    String descripcion,
    String hora,
    String estado,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tarjeta,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color == verde
                  ? const Color(0xFFE5F5EC)
                  : const Color(0xFFFFDAD6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icono, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nombre,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: texto),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text('$cantidad • $descripcion',
                    style: const TextStyle(
                        fontSize: 9, color: gris),
                    maxLines: 2),
              ],
            ),
          ),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(hora,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: texto)),
              Text(estado,
                  style: TextStyle(fontSize: 9, color: color)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _nav(IconData icono, String nombre, int indice) {
    final bool seleccionado = paginaSeleccionada == indice;

    return InkWell(
      onTap: () {
        setState(() {
          paginaSeleccionada = indice;
        });

        if (indice != 0) {
          mostrarMensaje('Pantalla $nombre pendiente de integrar');
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icono,
              color: seleccionado ? azul : gris,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              nombre,
              style: TextStyle(
                fontSize: 10,
                color: seleccionado ? azul : gris,
                fontWeight: seleccionado
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}