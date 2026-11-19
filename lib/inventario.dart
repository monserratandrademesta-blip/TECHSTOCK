import 'package:flutter/material.dart';
import 'inicio.dart';
import 'movimientos.dart';
import 'historial.dart';

const Color azul = Color(0xFF00288E);
const Color fondoInventario = Color(0xFFFAF8FF);

/// Modelo de producto. Se usa tanto en Inventario como en Movimientos.
/// stock NO es final: así Movimientos puede modificarlo directamente
/// cuando se registra una entrada o una salida.
class Producto {
  final String sku;
  String nombre;
  String detalle;
  double precio;
  int stock;
  String categoria;

  Producto({
    required this.sku,
    required this.nombre,
    required this.detalle,
    required this.precio,
    required this.stock,
    required this.categoria,
  });
}

/// Repositorio en memoria COMPARTIDO entre Inventario y Movimientos.
/// Al ser una lista estática, ambos módulos leen y escriben sobre
/// los mismos objetos Producto: si Movimientos descuenta stock,
/// Inventario lo ve reflejado automáticamente (y viceversa).
class InventarioRepositorio {
  InventarioRepositorio._();

  static final List<Producto> productos = [
    Producto(
      sku: 'CEL-IPH-15PM',
      nombre: 'iPhone 15 Pro Max',
      detalle: '256GB Titanio Natural',
      precio: 1199.00,
      stock: 14,
      categoria: 'Celulares',
    ),
    Producto(
      sku: 'COM-MBP-14M3',
      nombre: 'MacBook Pro 14" M3 Pro',
      detalle: '18GB / 512GB Gris Espacial',
      precio: 1999.00,
      stock: 2,
      categoria: 'Computadoras',
    ),
    Producto(
      sku: 'CEL-SAM-S24U',
      nombre: 'Galaxy S24 Ultra',
      detalle: '512GB Negro Titanio',
      precio: 1299.00,
      stock: 8,
      categoria: 'Celulares',
    ),
    Producto(
      sku: 'ACC-SNY-XM5',
      nombre: 'Sony WH-1000XM5',
      detalle: 'Cancelación de Ruido ANC',
      precio: 349.00,
      stock: 22,
      categoria: 'Accesorios',
    ),
    Producto(
      sku: 'COM-ASU-G16',
      nombre: 'ROG Zephyrus G16 OLED',
      detalle: '32GB RAM / 1TB SSD RTX 4070',
      precio: 1799.00,
      stock: 5,
      categoria: 'Computadoras',
    ),
  ];

  static void agregar(Producto producto) {
    productos.add(producto);
  }
}

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  final TextEditingController buscarController = TextEditingController();

  String categoriaSeleccionada = 'Todos';
  bool ordenarPorPrecio = false;

  List<Producto> get productosFiltrados {
    final busqueda = buscarController.text.toLowerCase();

    final resultado = InventarioRepositorio.productos.where((producto) {
      final coincideBusqueda =
          producto.nombre.toLowerCase().contains(busqueda) ||
          producto.sku.toLowerCase().contains(busqueda);

      final coincideCategoria = categoriaSeleccionada == 'Todos' ||
          (categoriaSeleccionada == 'Bajo Stock'
              ? producto.stock <= 3
              : producto.categoria == categoriaSeleccionada);

      return coincideBusqueda && coincideCategoria;
    }).toList();

    resultado.sort((a, b) {
      if (ordenarPorPrecio) {
        return b.precio.compareTo(a.precio);
      }
      return a.stock.compareTo(b.stock);
    });

    return resultado;
  }

  @override
  void dispose() {
    buscarController.dispose();
    super.dispose();
  }

  // BOTÓN "Nuevo producto" (FloatingActionButton)
  void agregarProducto() {
    final nombre = TextEditingController();
    final sku = TextEditingController();
    final precio = TextEditingController();
    final stock = TextEditingController();
    String categoria = 'Accesorios';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Nuevo producto'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _campo(nombre, 'Nombre del producto'),
                _campo(sku, 'SKU'),
                _campo(precio, 'Precio'),
                _campo(stock, 'Cantidad inicial'),
                DropdownButtonFormField<String>(
                  value: categoria,
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Celulares',
                      child: Text('Celulares'),
                    ),
                    DropdownMenuItem(
                      value: 'Computadoras',
                      child: Text('Computadoras'),
                    ),
                    DropdownMenuItem(
                      value: 'Accesorios',
                      child: Text('Accesorios'),
                    ),
                  ],
                  onChanged: (valor) {
                    if (valor != null) {
                      setDialogState(() => categoria = valor);
                    }
                  },
                ),
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
                      content:
                          Text('Completa correctamente todos los campos'),
                    ),
                  );
                  return;
                }

                setState(() {
                  InventarioRepositorio.agregar(
                    Producto(
                      sku: sku.text.trim(),
                      nombre: nombre.text.trim(),
                      detalle: 'Producto registrado',
                      precio: double.parse(precio.text),
                      stock: int.parse(stock.text),
                      categoria: categoria,
                    ),
                  );
                });

                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${nombre.text} agregado al inventario'),
                  ),
                );
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
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

  // BOTÓN de perfil (ícono persona en el AppBar)
  void _verPerfil() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(0xFFE2E7FF),
                  child: Icon(Icons.person, color: azul),
                ),
                title: Text(
                  'Carlos Mendoza',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Administrador General'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Cerrar sesión'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _irA(Widget pantalla) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => pantalla));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoInventario,
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
            onPressed: _verPerfil,
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
                      final stock = producto.stock;
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
                                      borderRadius:
                                          BorderRadius.circular(12),
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
                                          producto.nombre,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          producto.detalle,
                                          style: const TextStyle(
                                            color: Color(0xFF444653),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // BOTÓN info (ícono) -> detalle rápido
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text(producto.nombre),
                                          content: Text(
                                            'SKU: ${producto.sku}\n'
                                            'Precio: \$${producto.precio.toStringAsFixed(2)}\n'
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
                                'SKU: ${producto.sku}',
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
                                    '\$${producto.precio.toStringAsFixed(2)}',
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
                                      color:
                                          critico ? Colors.red : Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  // BOTÓN "Editar" -> edita el stock real
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
                                            title:
                                                const Text('Editar stock'),
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
                                                    Navigator.pop(
                                                        dialogContext),
                                                child:
                                                    const Text('Cancelar'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  final nuevoStock =
                                                      int.tryParse(
                                                          cantidad.text);
                                                  if (nuevoStock == null ||
                                                      nuevoStock < 0) {
                                                    return;
                                                  }
                                                  setState(() {
                                                    producto.stock =
                                                        nuevoStock;
                                                  });
                                                  Navigator.pop(
                                                      dialogContext);
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
                                  // BOTÓN "Detalle" -> ficha completa +
                                  // acceso directo a registrar movimiento
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (dialogContext) =>
                                              AlertDialog(
                                            title: const Text('Detalle'),
                                            content: Text(
                                              '${producto.nombre}\n'
                                              'Categoría: ${producto.categoria}\n'
                                              'SKU: ${producto.sku}\n'
                                              'Precio: \$${producto.precio.toStringAsFixed(2)}\n'
                                              'Stock: $stock',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(
                                                        dialogContext),
                                                child: const Text('Cerrar'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                      dialogContext);
                                                  _irA(
                                                    MovimientosScreen(
                                                      productoInicial:
                                                          producto.nombre,
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                    'Registrar movimiento'),
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
      // MENÚ INFERIOR conectado a las demás pantallas del admin
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        selectedItemColor: azul,
        unselectedItemColor: const Color(0xFF444653),
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
          switch (index) {
            case 0:
              _irA(const InicioScreen());
              break;
            case 2:
              _irA(const MovimientosScreen());
              break;
            case 3:
              _irA(const HistorialScreen());
              break;
          }
        },
      ),
    );
  }
}
