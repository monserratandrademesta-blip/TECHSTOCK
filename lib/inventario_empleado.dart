import 'package:flutter/material.dart';
import 'inicio_empleado.dart';
import 'inventario.dart';

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

  List<Producto> get productosFiltrados {
    return InventarioRepositorio.productos.where((producto) {
      final nombre = producto.nombre.toLowerCase();
      final sku = producto.sku.toLowerCase();
      final busqueda = buscador.text.toLowerCase();

      final coincideBusqueda =
          nombre.contains(busqueda) || sku.contains(busqueda);

      final coincideCategoria =
          categoriaSeleccionada == 'Todos' ||
          (categoriaSeleccionada == 'Bajo stock'
              ? producto.stock <= 5
              : producto.categoria == categoriaSeleccionada);

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
        iconTheme: const IconThemeData(
          color: Color(0xFF00288E),
        ),
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
                  final seleccionada =
                      categoriaSeleccionada == categoria;

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
                  const Icon(
                    Icons.filter_list,
                    color: Color(0xFF00288E),
                  ),
                ],
              ),
            ),
            Expanded(
              child: productosFiltrados.isEmpty
                  ? const Center(
                      child: Text('No se encontraron productos'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        4,
                        16,
                        16,
                      ),
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
            const SnackBar(
              content: Text('Escáner de código próximamente'),
            ),
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
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const InicioEmpleadoScreen(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _tarjetaProducto(Producto producto) {
    final int stock = producto.stock;
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
                      producto.categoria == 'Computadoras'
                          ? Icons.laptop_mac
                          : producto.categoria == 'Celulares'
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
                          producto.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'SKU: ${producto.sku}',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          '\$${producto.precio.toStringAsFixed(2)}',
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
                        'Existencias',
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
                  const Icon(
                    Icons.category_outlined,
                    size: 17,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      producto.categoria,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 17,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Stock: $stock',
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
                    Icon(
                      Icons.warning_amber,
                      color: Colors.red,
                      size: 16,
                    ),
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

  void _mostrarDetalle(Producto producto) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
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
                  producto.nombre,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('SKU: ${producto.sku}'),
                const SizedBox(height: 16),
                _datoDetalle('Categoría', producto.categoria),
                _datoDetalle(
                  'Precio',
                  '\$${producto.precio.toStringAsFixed(2)}',
                ),
                _datoDetalle(
                  'Existencias disponibles',
                  '${producto.stock}',
                ),
                _datoDetalle('Descripción', producto.detalle),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.check),
                    label: const Text('Cerrar detalle'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF00288E),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
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

  Widget _datoDetalle(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              valor,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}