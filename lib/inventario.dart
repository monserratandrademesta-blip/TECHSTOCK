import 'package:flutter/material.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  final TextEditingController buscarController = TextEditingController();

  String categoriaSeleccionada = 'Todos';
  bool ordenarPorPrecio = false;

  final List<Map<String, dynamic>> productos = [
    {
      'nombre': 'iPhone 15 Pro Max',
      'detalle': '256GB Titanio Natural',
      'sku': 'CEL-IPH-15PM',
      'precio': 1199.00,
      'stock': 14,
      'categoria': 'Celulares',
    },
    {
      'nombre': 'MacBook Pro 14" M3 Pro',
      'detalle': '18GB / 512GB Gris Espacial',
      'sku': 'COM-MBP-14M3',
      'precio': 1999.00,
      'stock': 2,
      'categoria': 'Computadoras',
    },
    {
      'nombre': 'Galaxy S24 Ultra',
      'detalle': '512GB Negro Titanio',
      'sku': 'CEL-SAM-S24U',
      'precio': 1299.00,
      'stock': 8,
      'categoria': 'Celulares',
    },
    {
      'nombre': 'Sony WH-1000XM5',
      'detalle': 'Cancelación de Ruido ANC',
      'sku': 'ACC-SNY-XM5',
      'precio': 349.00,
      'stock': 22,
      'categoria': 'Accesorios',
    },
    {
      'nombre': 'ROG Zephyrus G16 OLED',
      'detalle': '32GB RAM / 1TB SSD RTX 4070',
      'sku': 'COM-ASU-G16',
      'precio': 1799.00,
      'stock': 5,
      'categoria': 'Computadoras',
    },
  ];

  List<Map<String, dynamic>> get productosFiltrados {
    final busqueda = buscarController.text.toLowerCase();

    final resultado = productos.where((producto) {
      final coincideBusqueda =
          producto['nombre'].toString().toLowerCase().contains(busqueda) ||
          producto['sku'].toString().toLowerCase().contains(busqueda);

      final coincideCategoria = categoriaSeleccionada == 'Todos' ||
          (categoriaSeleccionada == 'Bajo Stock'
              ? producto['stock'] <= 3
              : producto['categoria'] == categoriaSeleccionada);

      return coincideBusqueda && coincideCategoria;
    }).toList();

    resultado.sort((a, b) {
      if (ordenarPorPrecio) {
        return b['precio'].compareTo(a['precio']);
      }
      return a['stock'].compareTo(b['stock']);
    });

    return resultado;
  }

  @override
  void dispose() {
    buscarController.dispose();
    super.dispose();
  }

  void agregarProducto() {
    final nombre = TextEditingController();
    final sku = TextEditingController();
    final precio = TextEditingController();
    final stock = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nuevo producto'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _campo(nombre, 'Nombre del producto'),
              _campo(sku, 'SKU'),
              _campo(precio, 'Precio'),
              _campo(stock, 'Cantidad inicial'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nombre.text.trim().isEmpty ||
                  sku.text.trim().isEmpty ||
                  double.tryParse(precio.text) == null ||
                  int.tryParse(stock.text) == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Completa correctamente todos los campos'),
                  ),
                );
                return;
              }

              setState(() {
                productos.add({
                  'nombre': nombre.text.trim(),
                  'detalle': 'Producto registrado',
                  'sku': sku.text.trim(),
                  'precio': double.parse(precio.text),
                  'stock': int.parse(stock.text),
                  'categoria': 'Accesorios',
                });
              });

              Navigator.pop(dialogContext);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  static Widget _campo(TextEditingController controller, String etiqueta) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: etiqueta,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF00288E);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Inventario',
          style: TextStyle(color: azul, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: azul),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: buscarController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar por modelo, SKU o código...',
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
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                'Todos',
                'Celulares',
                'Computadoras',
                'Accesorios',
                'Bajo Stock',
              ].map((categoria) {
                final seleccionado = categoriaSeleccionada == categoria;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(categoria),
                    selected: seleccionado,
                    selectedColor: azul,
                    labelStyle: TextStyle(
                      color: seleccionado ? Colors.white : Colors.black87,
                    ),
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
            padding: const EdgeInsets.fromLTRB(18, 15, 18, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${productosFiltrados.length} productos encontrados',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      ordenarPorPrecio = !ordenarPorPrecio;
                    });
                  },
                  icon: const Icon(Icons.sort),
                  label: Text(ordenarPorPrecio ? 'Precio' : 'Stock'),
                ),
              ],
            ),
          ),
          Expanded(
            child: productosFiltrados.isEmpty
                ? const Center(child: Text('No se encontraron productos'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: productosFiltrados.length,
                    itemBuilder: (context, index) {
                      final producto = productosFiltrados[index];
                      final stock = producto['stock'] as int;
                      final critico = stock <= 3;

                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE2E7FF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.devices,
                                      color: azul,
                                      size: 27,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          producto['nombre'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          producto['detalle'],
                                          style: const TextStyle(
                                            color: Color(0xFF444653),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text(producto['nombre']),
                                          content: Text(
                                            'SKU: ${producto['sku']}\n'
                                            'Precio: \$${producto['precio']}\n'
                                            'Existencias: $stock unidades',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cerrar'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.info_outline),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Text(
                                'SKU: ${producto['sku']}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF444653),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${(producto['precio'] as num).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: azul,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    'Stock: $stock',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    critico ? 'Crítico' : 'Disponible',
                                    style: TextStyle(
                                      color: critico ? Colors.red : Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        final cantidad =
                                            TextEditingController(
                                          text: '$stock',
                                        );
                                        showDialog(
                                          context: context,
                                          builder: (dialogContext) =>
                                              AlertDialog(
                                            title: const Text('Editar stock'),
                                            content: TextField(
                                              controller: cantidad,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration:
                                                  const InputDecoration(
                                                labelText: 'Existencias',
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(dialogContext),
                                                child: const Text('Cancelar'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  final nuevoStock =
                                                      int.tryParse(cantidad.text);
                                                  if (nuevoStock == null ||
                                                      nuevoStock < 0) {
                                                    return;
                                                  }
                                                  setState(() {
                                                    producto['stock'] =
                                                        nuevoStock;
                                                  });
                                                  Navigator.pop(dialogContext);
                                                },
                                                child: const Text('Guardar'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.edit_outlined),
                                      label: const Text('Editar'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: const Text('Detalle'),
                                            content: Text(
                                              '${producto['nombre']}\n'
                                              'Categoría: ${producto['categoria']}\n'
                                              'SKU: ${producto['sku']}\n'
                                              'Precio: \$${producto['precio']}\n'
                                              'Stock: $stock',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('Cerrar'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: azul,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Detalle'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: agregarProducto,
        backgroundColor: azul,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo producto'),
      ),
    );
  }
}