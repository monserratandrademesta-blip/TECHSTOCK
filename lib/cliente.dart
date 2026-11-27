import 'package:flutter/material.dart';
import 'login.dart';
import 'inventario.dart';

const Color azulCliente = Color(0xFF00288E);
const Color fondoCliente = Color(0xFFFAF8FF);

// --------------------------------------------------
// MODELOS Y REPOSITORIO DE PEDIDOS
// --------------------------------------------------

class DetallePedido {
  final String sku;
  final String nombre;
  final double precio;
  final int cantidad;

  DetallePedido({
    required this.sku,
    required this.nombre,
    required this.precio,
    required this.cantidad,
  });

  double get subtotal => precio * cantidad;
}

class PedidoCliente {
  final String folio;
  final List<DetallePedido> productos;
  final String metodoPago;
  final DateTime fecha;
  String estado;

  PedidoCliente({
    required this.folio,
    required this.productos,
    required this.metodoPago,
    required this.fecha,
    required this.estado,
  });

  double get total =>
      productos.fold(0, (suma, producto) => suma + producto.subtotal);
}

class PedidosRepositorio {
  static final List<PedidoCliente> pedidos = [];
  static int consecutivo = 1001;

  static PedidoCliente crearPedido({
    required List<DetallePedido> productos,
    required String metodoPago,
  }) {
    final pedido = PedidoCliente(
      folio: 'PED-${consecutivo++}',
      productos: productos,
      metodoPago: metodoPago,
      fecha: DateTime.now(),
      estado: metodoPago == 'Pago en línea'
          ? 'Pendiente de pago'
          : 'Pendiente de confirmación',
    );

    pedidos.insert(0, pedido);
    return pedido;
  }
}

// --------------------------------------------------
// INICIO DEL CLIENTE
// --------------------------------------------------
class ClienteScreen extends StatefulWidget {
  final int usuarioId;
  final String nombreCliente;

  const ClienteScreen({
    super.key,
    required this.usuarioId,
    required this.nombreCliente,
  });

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final Map<String, int> carrito = {};

  int get cantidadCarrito =>
      carrito.values.fold(0, (suma, cantidad) => suma + cantidad);

  void cerrarSesion() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  void agregarProducto(Producto producto) {
    if (producto.stock <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Este producto no tiene existencias.')),
      );
      return;
    }

    final cantidadActual = carrito[producto.sku] ?? 0;

    if (cantidadActual >= producto.stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No puedes agregar más unidades que las disponibles.'),
        ),
      );
      return;
    }

    setState(() {
      carrito[producto.sku] = cantidadActual + 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${producto.nombre} agregado al carrito.'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void actualizarCarrito(Map<String, int> nuevoCarrito) {
    setState(() {
      carrito
        ..clear()
        ..addAll(nuevoCarrito);
    });
  }

  void abrirCatalogo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CatalogoClienteScreen(
          alAgregar: agregarProducto,
        ),
      ),
    );
  }

  void abrirCarrito() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarritoClienteScreen(
          carrito: Map<String, int>.from(carrito),
          alActualizar: actualizarCarrito,
        ),
      ),
    );
  }

  void abrirPedidos() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MisPedidosClienteScreen(),
      ),
    );
  }

  void abrirCuenta() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CuentaClienteScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoCliente,
      appBar: AppBar(
        backgroundColor: azulCliente,
        foregroundColor: Colors.white,
        title: const Text(
          'TechStock',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                tooltip: 'Mi carrito',
                onPressed: abrirCarrito,
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
              if (cantidadCarrito > 0)
                Positioned(
                  right: 5,
                  top: 5,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$cantidadCarrito',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: cerrarSesion,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¡Bienvenido a TechStock!',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: azulCliente,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Encuentra los productos que necesitas.',
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
              const SizedBox(height: 25),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: azulCliente,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.devices_other,
                      color: Colors.white,
                      size: 35,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Tecnología para ti',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Explora nuestro catálogo y realiza tu pedido.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                '¿Qué deseas hacer?',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _OpcionCliente(
                icono: Icons.storefront_outlined,
                titulo: 'Ver catálogo',
                descripcion: 'Consulta los productos y existencias.',
                alPresionar: abrirCatalogo,
              ),
              _OpcionCliente(
                icono: Icons.shopping_cart_outlined,
                titulo: 'Mi carrito',
                descripcion: 'Consulta los productos que deseas comprar.',
                alPresionar: abrirCarrito,
                indicador: cantidadCarrito > 0 ? '$cantidadCarrito' : null,
              ),
              _OpcionCliente(
                icono: Icons.receipt_long_outlined,
                titulo: 'Mis pedidos',
                descripcion: 'Consulta el estado de tus compras.',
                alPresionar: abrirPedidos,
              ),
              _OpcionCliente(
                icono: Icons.person_outline,
                titulo: 'Mi cuenta',
                descripcion: 'Consulta tu información de cliente.',
                alPresionar: abrirCuenta,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// OPCIONES DEL INICIO
// --------------------------------------------------

class _OpcionCliente extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String descripcion;
  final VoidCallback alPresionar;
  final String? indicador;

  const _OpcionCliente({
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.alPresionar,
    this.indicador,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE8F0FF),
          child: Icon(icono, color: azulCliente),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(descripcion),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (indicador != null)
              CircleAvatar(
                radius: 11,
                backgroundColor: azulCliente,
                child: Text(
                  indicador!,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        onTap: alPresionar,
      ),
    );
  }
}

// --------------------------------------------------
// CATÁLOGO
// --------------------------------------------------

class CatalogoClienteScreen extends StatefulWidget {
  final void Function(Producto) alAgregar;

  const CatalogoClienteScreen({
    super.key,
    required this.alAgregar,
  });

  @override
  State<CatalogoClienteScreen> createState() =>
      _CatalogoClienteScreenState();
}

class _CatalogoClienteScreenState extends State<CatalogoClienteScreen> {
  final TextEditingController buscador = TextEditingController();
  String categoria = 'Todos';

  @override
  void dispose() {
    buscador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productos = InventarioRepositorio.productos;
    final categorias = [
      'Todos',
      ...productos.map((p) => p.categoria).toSet(),
    ];

    final filtrados = productos.where((producto) {
      final coincideTexto =
          producto.nombre.toLowerCase().contains(buscador.text.toLowerCase()) ||
          producto.sku.toLowerCase().contains(buscador.text.toLowerCase());

      final coincideCategoria =
          categoria == 'Todos' || producto.categoria == categoria;

      return coincideTexto && coincideCategoria;
    }).toList();

    return Scaffold(
      backgroundColor: fondoCliente,
      appBar: AppBar(
        backgroundColor: azulCliente,
        foregroundColor: Colors.white,
        title: const Text('Catálogo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: buscador,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar producto o SKU',
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
              children: categorias.map((nombre) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(nombre),
                    selected: categoria == nombre,
                    onSelected: (_) => setState(() => categoria = nombre),
                    selectedColor: const Color(0xFFDCE7FF),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: filtrados.isEmpty
                ? const Center(child: Text('No se encontraron productos.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtrados.length,
                    itemBuilder: (context, index) {
                      final producto = filtrados[index];

                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Color(0xFFE8F0FF),
                                    child: Icon(
                                      Icons.devices,
                                      color: azulCliente,
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
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          producto.sku,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '\$${producto.precio.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: azulCliente,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                producto.detalle,
                                style: const TextStyle(color: Colors.black54),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    producto.stock > 0
                                        ? 'Disponibles: ${producto.stock}'
                                        : 'Agotado',
                                    style: TextStyle(
                                      color: producto.stock > 0
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  FilledButton.icon(
                                    onPressed: producto.stock > 0
                                        ? () => widget.alAgregar(producto)
                                        : null,
                                    icon: const Icon(
                                      Icons.add_shopping_cart,
                                      size: 18,
                                    ),
                                    label: const Text('Agregar'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: azulCliente,
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
    );
  }
}

// --------------------------------------------------
// CARRITO Y CONFIRMACIÓN DE PEDIDO
// --------------------------------------------------

class CarritoClienteScreen extends StatefulWidget {
  final Map<String, int> carrito;
  final void Function(Map<String, int>) alActualizar;

  const CarritoClienteScreen({
    super.key,
    required this.carrito,
    required this.alActualizar,
  });

  @override
  State<CarritoClienteScreen> createState() => _CarritoClienteScreenState();
}

class _CarritoClienteScreenState extends State<CarritoClienteScreen> {
  late Map<String, int> carrito;
  String metodoPago = 'Pago al recoger';

  @override
  void initState() {
    super.initState();
    carrito = Map<String, int>.from(widget.carrito);
  }

  Producto? buscarProducto(String sku) {
    for (final producto in InventarioRepositorio.productos) {
      if (producto.sku == sku) return producto;
    }
    return null;
  }

  double get total {
    double suma = 0;

    for (final entrada in carrito.entries) {
      final producto = buscarProducto(entrada.key);
      if (producto != null) {
        suma += producto.precio * entrada.value;
      }
    }

    return suma;
  }

  void cambiarCantidad(String sku, int nuevaCantidad) {
    final producto = buscarProducto(sku);

    if (producto == null) return;

    if (nuevaCantidad <= 0) {
      carrito.remove(sku);
    } else if (nuevaCantidad <= producto.stock) {
      carrito[sku] = nuevaCantidad;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay suficientes existencias.')),
      );
      return;
    }

    widget.alActualizar(carrito);
    setState(() {});
  }

  void confirmarPedido() {
    if (carrito.isEmpty) return;

    final detalles = <DetallePedido>[];

    for (final entrada in carrito.entries) {
      final producto = buscarProducto(entrada.key);

      if (producto == null || entrada.value > producto.stock) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Las existencias cambiaron. Revisa las cantidades de tu carrito.',
            ),
          ),
        );
        return;
      }

      detalles.add(
        DetallePedido(
          sku: producto.sku,
          nombre: producto.nombre,
          precio: producto.precio.toDouble(),
          cantidad: entrada.value,
        ),
      );
    }

    final pedido = PedidosRepositorio.crearPedido(
      productos: detalles,
      metodoPago: metodoPago,
    );

    carrito.clear();
    widget.alActualizar(carrito);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TicketClienteScreen(pedido: pedido),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entradas = carrito.entries.toList();

    return Scaffold(
      backgroundColor: fondoCliente,
      appBar: AppBar(
        backgroundColor: azulCliente,
        foregroundColor: Colors.white,
        title: const Text('Mi carrito'),
      ),
      body: carrito.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 65,
                    color: Colors.black26,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Tu carrito está vacío.',
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(height: 5),
                  Text('Agrega productos desde el catálogo.'),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: entradas.length,
                    itemBuilder: (context, index) {
                      final entrada = entradas[index];
                      final producto = buscarProducto(entrada.key);

                      if (producto == null) {
                        return const SizedBox.shrink();
                      }

                      return Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                producto.nombre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '\$${producto.precio.toStringAsFixed(2)} por unidad',
                                style: const TextStyle(color: Colors.black54),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => cambiarCantidad(
                                      entrada.key,
                                      entrada.value - 1,
                                    ),
                                    icon: const Icon(Icons.remove_circle_outline),
                                  ),
                                  Text(
                                    '${entrada.value}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => cambiarCantidad(
                                      entrada.key,
                                      entrada.value + 1,
                                    ),
                                    icon: const Icon(Icons.add_circle_outline),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '\$${(producto.precio * entrada.value).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: azulCliente,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        cambiarCantidad(entrada.key, 0),
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Existencias actuales: ${producto.stock}',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(18),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Método de pago',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Pagar al recoger'),
                        value: 'Pago al recoger',
                        groupValue: metodoPago,
                        onChanged: (valor) {
                          if (valor != null) {
                            setState(() => metodoPago = valor);
                          }
                        },
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Pago en línea'),
                        subtitle: const Text(
                          'La pasarela de pago se integrará posteriormente.',
                        ),
                        value: 'Pago en línea',
                        groupValue: metodoPago,
                        onChanged: (valor) {
                          if (valor != null) {
                            setState(() => metodoPago = valor);
                          }
                        },
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total del pedido',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 21,
                              color: azulCliente,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: confirmarPedido,
                          style: FilledButton.styleFrom(
                            backgroundColor: azulCliente,
                            padding: const EdgeInsets.all(15),
                          ),
                          child: const Text('Confirmar pedido'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

// --------------------------------------------------
// TICKET
// --------------------------------------------------

class TicketClienteScreen extends StatelessWidget {
  final PedidoCliente pedido;

  const TicketClienteScreen({
    super.key,
    required this.pedido,
  });

  String fechaTexto(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year} '
        '${fecha.hour.toString().padLeft(2, '0')}:'
        '${fecha.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoCliente,
      appBar: AppBar(
        backgroundColor: azulCliente,
        foregroundColor: Colors.white,
        title: const Text('Ticket de pedido'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 55,
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    '¡Pedido registrado!',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: azulCliente,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Folio: ${pedido.folio}'),
                Text('Fecha: ${fechaTexto(pedido.fecha)}'),
                Text('Método de pago: ${pedido.metodoPago}'),
                const SizedBox(height: 10),
                const Divider(),
                const Text(
                  'Productos',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...pedido.productos.map(
                  (producto) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '${producto.cantidad} x ${producto.nombre}',
                          ),
                        ),
                        Text(
                          '\$${producto.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TOTAL',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${pedido.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: azulCliente,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Estado: ${pedido.estado}',
                    style: const TextStyle(
                      color: azulCliente,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Este comprobante confirma el registro de tu pedido. '
                  'La compra todavía debe ser confirmada por el administrador.',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: azulCliente,
                    ),
                    child: const Text('Volver al inicio'),
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

// --------------------------------------------------
// MIS PEDIDOS
// --------------------------------------------------

class MisPedidosClienteScreen extends StatefulWidget {
  const MisPedidosClienteScreen({super.key});

  @override
  State<MisPedidosClienteScreen> createState() =>
      _MisPedidosClienteScreenState();
}

class _MisPedidosClienteScreenState extends State<MisPedidosClienteScreen> {
  @override
  Widget build(BuildContext context) {
    final pedidos = PedidosRepositorio.pedidos;

    return Scaffold(
      backgroundColor: fondoCliente,
      appBar: AppBar(
        backgroundColor: azulCliente,
        foregroundColor: Colors.white,
        title: const Text('Mis pedidos'),
      ),
      body: pedidos.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 60,
                    color: Colors.black26,
                  ),
                  SizedBox(height: 12),
                  Text('Todavía no tienes pedidos.'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final pedido = pedidos[index];

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE8F0FF),
                      child: Icon(Icons.receipt_long, color: azulCliente),
                    ),
                    title: Text(
                      pedido.folio,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${pedido.productos.length} productos\n'
                      '${pedido.estado}',
                    ),
                    isThreeLine: true,
                    trailing: Text(
                      '\$${pedido.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: azulCliente,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TicketClienteScreen(pedido: pedido),
                        ),
                      ).then((_) => setState(() {}));
                    },
                  ),
                );
              },
            ),
    );
  }
}

// --------------------------------------------------
// MI CUENTA
// --------------------------------------------------

class CuentaClienteScreen extends StatelessWidget {
  const CuentaClienteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoCliente,
      appBar: AppBar(
        backgroundColor: azulCliente,
        foregroundColor: Colors.white,
        title: const Text('Mi cuenta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: Colors.white,
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: Color(0xFFE8F0FF),
                  child: Icon(
                    Icons.person,
                    color: azulCliente,
                    size: 42,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Cliente TechStock',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Cuenta de demostración',
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(height: 15),
                Text(
                  'Los datos personales y la información de acceso '
                  'se conectarán cuando integremos el registro de clientes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}