import 'package:flutter/material.dart';

class InventarioEmpleadoScreen extends StatefulWidget {
  const InventarioEmpleadoScreen({super.key});

  @override
  State<InventarioEmpleadoScreen> createState() =>
      _InventarioEmpleadoScreenState();
}

class _InventarioEmpleadoScreenState
    extends State<InventarioEmpleadoScreen> {
  final TextEditingController buscador = TextEditingController();

  String categoriaSeleccionada = 'Todos';

  final List<Map<String, dynamic>> productos = [
    {
      'nombre': 'iPhone 15 Pro Max 256GB',
      'sku': 'APL-15PM-256',
      'categoria': 'Celulares',
      'precio': 1199,
      'stock': 14,
      'ubicacion': 'Pasillo A · Vitrina 2',
      'bodega': 8,
    },
    {
      'nombre': 'MacBook Pro 14 M3',
      'sku': 'APL-MBP-14M3',
      'categoria': 'Computadoras',
      'precio': 1999,
      'stock': 2,
      'ubicacion': 'Bodega B · Estante 4',
      'bodega': 2,
    },
    {
      'nombre': 'Galaxy S24 Ultra 512GB',
      'sku': 'SAM-S24U-512',
      'categoria': 'Celulares',
      'precio': 1299,
      'stock': 8,
      'ubicacion': 'Vitrina Central',
      'bodega': 5,
    },
    {
      'nombre': 'Sony WH-1000XM5',
      'sku': 'SNY-WH1005',
      'categoria': 'Accesorios',
      'precio': 349,
      'stock': 22,
      'ubicacion': 'Pasillo Accesorios',
      'bodega': 12,
    },
    {
      'nombre': 'ASUS ROG Zephyrus G16',
      'sku': 'ASU-ROG-G16',
      'categoria': 'Computadoras',
      'precio': 1799,
      'stock': 5,
      'ubicacion': 'Pasillo C · Exhibición',
      'bodega': 4,
    },
  ];

  List<Map<String, dynamic>> get productosFiltrados {
    return productos.where((producto) {
      final nombre = producto['nombre'].toString().toLowerCase();
      final sku = producto['sku'].toString().toLowerCase();
      final busqueda = buscador.text.toLowerCase();

      final coincideBusqueda =
          nombre.contains(busqueda) || sku.contains(busqueda);

      final coincideCategoria = categoriaSeleccionada == 'Todos' ||
          (categoriaSeleccionada == 'Bajo stock'
              ? producto['stock'] <= 5
              : producto['categoria'] == categoriaSeleccionada);

      return coincideBusqueda && coincideCategoria;
    }).toList();
  }

  @override
  void dispose() {
    buscador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Consultar inventario',
          style: TextStyle(
            color: Color(0xFF00288E),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF00288E)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: TextField(
                controller: buscador,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Buscar producto, modelo o SKU...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 49,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  'Todos',
                  'Celulares',
                  'Computadoras',
                  'Accesorios',
                  'Bajo stock',
                ].map((categoria) {
                  final seleccionada = categoriaSeleccionada == categoria;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(categoria),
                      selected: seleccionada,
                      selectedColor: const Color(0xFFDCE8FF),
                      onSelected: (_) {
                        setState(() {
                          categoriaSeleccionada = categoria;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${productosFiltrados.length} productos encontrados',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(Icons.filter_list, color: Color(0xFF00288E)),
                ],
              ),
            ),
            Expanded(
              child: productosFiltrados.isEmpty
                  ? const Center(child: Text('No se encontraron productos'))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      itemCount: productosFiltrados.length,
                      itemBuilder: (context, index) {
                        final producto = productosFiltrados[index];
                        return _tarjetaProducto(producto);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00288E),
        foregroundColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Escáner de código próximamente')),
          );
        },
        child: const Icon(Icons.qr_code_scanner),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xFF00288E),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Inventario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Movimientos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Mi turno',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/inicio-empleado');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/registrar-salida');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/mi-turno');
          }
        },
      ),
    );
  }

  Widget _tarjetaProducto(Map<String, dynamic> producto) {
    final int stock = producto['stock'];
    final bool bajoStock = stock <= 5;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _mostrarDetalle(producto),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FF),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      producto['categoria'] == 'Computadoras'
                          ? Icons.laptop_mac
                          : producto['categoria'] == 'Celulares'
                              ? Icons.smartphone
                              : Icons.headphones,
                      color: const Color(0xFF00288E),
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          producto['nombre'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'SKU: ${producto['sku']}',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          '\$${producto['precio']}',
                          style: const TextStyle(
                            color: Color(0xFF00288E),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '$stock',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: bajoStock ? Colors.red : Colors.green,
                        ),
                      ),
                      Text(
                        'En tienda',
                        style: TextStyle(
                          fontSize: 10,
                          color: bajoStock ? Colors.red : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 22),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 17, color: Colors.black54),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      producto['ubicacion'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const Icon(Icons.warehouse_outlined,
                      size: 17, color: Colors.black54),
                  const SizedBox(width: 5),
                  Text(
                    'Bodega: ${producto['bodega']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              if (bajoStock) ...[
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.red, size: 16),
                    SizedBox(width: 5),
                    Text(
                      'Existencia baja',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarDetalle(Map<String, dynamic> producto) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  producto['nombre'],
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('SKU: ${producto['sku']}'),
                const SizedBox(height: 16),
                _datoDetalle('Precio', '\$${producto['precio']}'),
                _datoDetalle('Existencias en tienda', '${producto['stock']}'),
                _datoDetalle('Ubicación', producto['ubicacion']),
                _datoDetalle('Existencias en bodega', '${producto['bodega']}'),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00288E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/registrar-salida');
                    },
                    icon: const Icon(Icons.point_of_sale),
                    label: const Text('Registrar venta'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _datoDetalle(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo, style: const TextStyle(color: Colors.black54)),
          Flexible(
            child: Text(
              valor,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}