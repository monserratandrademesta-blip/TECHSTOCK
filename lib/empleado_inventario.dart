import 'package:flutter/material.dart';

const Color _fondoInventario = Color(0xFFFAF8FF);
const Color _primarioInventario = Color(0xFF00288E);
const Color _secundarioInventario = Color(0xFF0051D5);
const Color _textoInventario = Color(0xFF131B2E);
const Color _textoSuaveInventario = Color(0xFF444653);
const Color _errorInventario = Color(0xFFBA1A1A);
const Color _exitoInventario = Color(0xFF003D27);

class EmpleadoInventarioScreen extends StatefulWidget {
  const EmpleadoInventarioScreen({super.key});

  @override
  State<EmpleadoInventarioScreen> createState() =>
      _EmpleadoInventarioScreenState();
}

class _EmpleadoInventarioScreenState extends State<EmpleadoInventarioScreen> {
  final TextEditingController _buscador = TextEditingController();

  String _categoriaSeleccionada = 'Todos (41)';
  String _textoBusqueda = '';

  static const List<_Producto> _productos = [
    _Producto(
      nombre: 'iPhone 15 Pro Max 256GB',
      sku: 'SKU-APL-15PM-256',
      categoria: 'Celulares',
      ubicacion: 'Pasillo A · Vitrina 2 (Mostrador)',
      precio: '\$1,199.00',
      stock: 14,
      mostrador: 14,
      bodega: 8,
      etiqueta: '5G',
      icono: Icons.phone_iphone_rounded,
      iconoUbicacion: Icons.location_on_rounded,
    ),
    _Producto(
      nombre: 'MacBook Pro 14" M3 Space Black',
      sku: 'SKU-APL-MBP-14M3',
      categoria: 'Computadoras',
      ubicacion: 'Bodega B · Estante 4 (Gaveta C)',
      precio: '\$1,999.00',
      stock: 2,
      mostrador: 0,
      bodega: 2,
      etiqueta: 'M3',
      icono: Icons.laptop_mac_rounded,
      iconoUbicacion: Icons.warehouse_rounded,
      ultimasUnidades: true,
    ),
    _Producto(
      nombre: 'Galaxy S24 Ultra 512GB',
      sku: 'SKU-SAM-S24U-512',
      categoria: 'Celulares',
      ubicacion: 'Vitrina Central · Nivel 1',
      precio: '\$1,299.00',
      stock: 8,
      mostrador: 3,
      bodega: 5,
      etiqueta: 'AI',
      icono: Icons.phone_android_rounded,
      iconoUbicacion: Icons.location_on_rounded,
    ),
    _Producto(
      nombre: 'Sony WH-1000XM5 Black',
      sku: 'SKU-SNY-WH1005',
      categoria: 'Accesorios',
      ubicacion: 'Pasillo Accesorios · Cabecera 3',
      precio: '\$349.00',
      stock: 22,
      mostrador: 10,
      bodega: 12,
      etiqueta: 'NC',
      icono: Icons.headphones_rounded,
      iconoUbicacion: Icons.location_on_rounded,
    ),
    _Producto(
      nombre: 'Asus ROG Zephyrus G16 OLED',
      sku: 'SKU-ASU-ROG-G16',
      categoria: 'Computadoras',
      ubicacion: 'Bodega Principal · Rack A-12',
      precio: '\$1,799.00',
      stock: 5,
      mostrador: 1,
      bodega: 4,
      etiqueta: 'RTX',
      icono: Icons.laptop_windows_rounded,
      iconoUbicacion: Icons.warehouse_rounded,
    ),
  ];

  @override
  void dispose() {
    _buscador.dispose();
    super.dispose();
  }

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

  List<_Producto> get _productosVisibles {
    return _productos.where((producto) {
      final coincideCategoria = _categoriaSeleccionada.startsWith('Todos') ||
          producto.categoria == _categoriaSeleccionada;

      final texto = _textoBusqueda.toLowerCase().trim();
      final coincideBusqueda = texto.isEmpty ||
          producto.nombre.toLowerCase().contains(texto) ||
          producto.sku.toLowerCase().contains(texto) ||
          producto.ubicacion.toLowerCase().contains(texto);

      return coincideCategoria && coincideBusqueda;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final productos = _productosVisibles;

    return Scaffold(
      backgroundColor: _fondoInventario,
      appBar: AppBar(
        backgroundColor: _fondoInventario,
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
                color: _primarioInventario,
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
                          color: _primarioInventario,
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
                            color: _textoSuaveInventario,
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
                      color: _textoSuaveInventario,
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
                color: _textoSuaveInventario,
              ),
            ),
            const CircleAvatar(
              radius: 16,
              backgroundColor: _primarioInventario,
              child: Icon(Icons.person_rounded, color: Colors.white, size: 19),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _buscador,
              onChanged: (valor) {
                setState(() => _textoBusqueda = valor);
              },
              decoration: InputDecoration(
                hintText: 'Buscar por modelo, SKU o código...',
                hintStyle: const TextStyle(
                  color: Color(0xFF757684),
                  fontSize: 12,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: _textoSuaveInventario,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: _secundarioInventario,
                    width: 1.3,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                _chipCategoria('Todos (41)'),
                _chipCategoria('Celulares (18)'),
                _chipCategoria('Computadoras (12)'),
                _chipCategoria('Accesorios (11)'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${productos.length} productos destacados en vitrina',
                    style: const TextStyle(
                      color: _textoSuaveInventario,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(
                  Icons.storefront_rounded,
                  size: 14,
                  color: _textoSuaveInventario,
                ),
                const SizedBox(width: 3),
                const Text(
                  'Sucursal Norte',
                  style: TextStyle(
                    color: _textoSuaveInventario,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: productos.isEmpty
                ? const Center(
                    child: Text(
                      'No se encontraron productos.',
                      style: TextStyle(color: _textoSuaveInventario),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 2, 16, 18),
                    itemCount: productos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, indice) => _tarjetaProducto(productos[indice]),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _barraInferior(),
    );
  }

  Widget _chipCategoria(String titulo) {
    final seleccionada = titulo == _categoriaSeleccionada;

    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 6, bottom: 6),
      child: ChoiceChip(
        label: Text(titulo),
        selected: seleccionada,
        onSelected: (_) {
          setState(() => _categoriaSeleccionada = titulo);
        },
        selectedColor: _primarioInventario,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: seleccionada ? Colors.white : _textoInventario,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
        shape: StadiumBorder(
          side: BorderSide(
            color: seleccionada ? _primarioInventario : Colors.transparent,
          ),
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  Widget _tarjetaProducto(_Producto producto) {
    final colorStock =
        producto.ultimasUnidades ? _errorInventario : _textoInventario;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F3FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      producto.icono,
                      color: _primarioInventario,
                      size: 35,
                    ),
                  ),
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        producto.etiqueta,
                        style: const TextStyle(
                          color: _textoInventario,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
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
                            producto.sku,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _textoSuaveInventario,
                              fontSize: 9,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        _estadoProducto(producto),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      producto.nombre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _textoInventario,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          producto.iconoUbicacion,
                          size: 14,
                          color: _secundarioInventario,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            producto.ubicacion,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _textoSuaveInventario,
                              fontSize: 9,
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
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PVP al Cliente',
                      style: TextStyle(
                        color: Color(0xFF757684),
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        text: producto.precio,
                        style: const TextStyle(
                          color: _primarioInventario,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                        children: const [
                          TextSpan(
                            text: ' USD',
                            style: TextStyle(
                              color: _textoSuaveInventario,
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Stock Tienda',
                    style: TextStyle(
                      color: Color(0xFF757684),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      text: '${producto.stock}',
                      style: TextStyle(
                        color: colorStock,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      children: const [
                        TextSpan(
                          text: ' unids',
                          style: TextStyle(
                            color: _textoSuaveInventario,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _mostrarDisponibilidad(producto),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primarioInventario,
                    backgroundColor: const Color(0xFFEAEDFF),
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.hub_rounded, size: 16),
                  label: const Text(
                    'Disponibilidad',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _mensaje(
                    'Añadido a orden de mostrador: ${producto.nombre}',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primarioInventario,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.point_of_sale_rounded, size: 16),
                  label: const Text(
                    'Vender',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _estadoProducto(_Producto producto) {
    final colorFondo = producto.ultimasUnidades
        ? const Color(0xFFFFDAD6)
        : const Color(0xFF6FFBBE);
    final colorTexto =
        producto.ultimasUnidades ? _errorInventario : _exitoInventario;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: colorTexto,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            producto.ultimasUnidades
                ? 'Últimas ${producto.stock} unids'
                : 'Disponible',
            style: TextStyle(
              color: colorTexto,
              fontSize: 8,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDisponibilidad(_Producto producto) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (contextoModal) {
        return SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
            decoration: const BoxDecoration(
              color: _fondoInventario,
              borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC4C5D5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            producto.sku,
                            style: const TextStyle(
                              color: _secundarioInventario,
                              fontSize: 10,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            producto.nombre,
                            style: const TextStyle(
                              color: _textoInventario,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(contextoModal),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _datoDisponibilidad(
                      titulo: 'Mostrador / Exhibición',
                      valor: '${producto.mostrador} unids',
                      detalle: 'Listos para entrega',
                      colorValor: _textoInventario,
                    ),
                    const SizedBox(width: 10),
                    _datoDisponibilidad(
                      titulo: 'Bodega Trasera',
                      valor: '${producto.bodega} unids',
                      detalle: 'Requiere retiro interno',
                      colorValor: _secundarioInventario,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E7FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: _secundarioInventario,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Precios de coste mayorista y márgenes de ganancia ocultos bajo directiva de seguridad.',
                          style: TextStyle(
                            color: _textoSuaveInventario,
                            fontSize: 10,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(contextoModal),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primarioInventario,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.check_rounded),
                    label: const Text(
                      'Entendido',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _datoDisponibilidad({
    required String titulo,
    required String valor,
    required String detalle,
    required Color colorValor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 7,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                color: Color(0xFF757684),
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              valor,
              style: TextStyle(
                color: colorValor,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              detalle,
              style: const TextStyle(
                color: _textoSuaveInventario,
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
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
              seleccionado: false,
              onTap: () => Navigator.maybePop(context),
            ),
            _itemNavegacion(
              icono: Icons.inventory_2_rounded,
              titulo: 'Inventario',
              seleccionado: true,
              onTap: () {},
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
    final color = seleccionado ? _secundarioInventario : _textoSuaveInventario;

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
}

class _Producto {
  final String nombre;
  final String sku;
  final String categoria;
  final String ubicacion;
  final String precio;
  final int stock;
  final int mostrador;
  final int bodega;
  final String etiqueta;
  final IconData icono;
  final IconData iconoUbicacion;
  final bool ultimasUnidades;

  const _Producto({
    required this.nombre,
    required this.sku,
    required this.categoria,
    required this.ubicacion,
    required this.precio,
    required this.stock,
    required this.mostrador,
    required this.bodega,
    required this.etiqueta,
    required this.icono,
    required this.iconoUbicacion,
    this.ultimasUnidades = false,
  });
}