import 'package:flutter/material.dart';
import 'inventario_empleado.dart';
import 'inventario.dart';
import 'login.dart';

const Color azulEmpleado = Color(0xFF00288E);
const Color fondoEmpleado = Color(0xFFFAF8FF);

class InicioEmpleadoScreen extends StatelessWidget {
  final int usuarioId;
  final String nombreEmpleado;

  const InicioEmpleadoScreen({
    super.key,
    required this.usuarioId,
    required this.nombreEmpleado,
  });

  void cerrarSesion(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoEmpleado,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.inventory_2, color: azulEmpleado),
            SizedBox(width: 9),
            Text(
              'TechStock',
              style: TextStyle(
                color: azulEmpleado,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tienes 3 alertas de stock bajo'),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none,
              color: azulEmpleado,
            ),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: () => cerrarSesion(context),
            icon: const Icon(
              Icons.logout,
              color: azulEmpleado,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hola, $nombreEmpleado',
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF131B2E),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Asesora de Ventas · Operador Tienda',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.storefront,
                      color: azulEmpleado,
                      size: 25,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Turno activo',
                            style: TextStyle(
                              color: azulEmpleado,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Sede Central · Sector Tecnológico',
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 11,
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
                  Expanded(
                    child: _AccionEmpleado(
                      icono: Icons.add_box_outlined,
                      titulo: 'Registrar entrada',
                      color: azulEmpleado,
                      alPresionar: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const RegistrarEntradaEmpleadoScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _AccionEmpleado(
                      icono: Icons.search,
                      titulo: 'Consultar stock',
                      color: const Color(0xFF00856A),
                      alPresionar: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InventarioEmpleadoScreen(
                                  usuarioId: usuarioId,
                                  nombreEmpleado: nombreEmpleado,
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Resumen de hoy',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              const Row(
                children: [
                  Expanded(
                    child: _IndicadorEmpleado(
                      titulo: 'Unidades despachadas',
                      valor: '14',
                      icono: Icons.shopping_bag_outlined,
                      color: azulEmpleado,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _IndicadorEmpleado(
                      titulo: 'Tickets generados',
                      valor: '8',
                      icono: Icons.receipt_long,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Row(
                children: [
                  Expanded(
                    child: _IndicadorEmpleado(
                      titulo: 'Stock físico',
                      valor: '1,420',
                      icono: Icons.inventory_2_outlined,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _IndicadorEmpleado(
                      titulo: 'Alertas de stock',
                      valor: '3',
                      icono: Icons.warning_amber,
                      color: Colors.orange,
                    ),
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

              const _AlertaEmpleado(
                nombre: 'iPhone 15 Pro',
                detalle: 'Solo quedan 2 unidades',
                cantidad: '2',
                color: Colors.red,
              ),
              const _AlertaEmpleado(
                nombre: 'MacBook Air M2',
                detalle: 'Solo queda 1 unidad',
                cantidad: '1',
                color: Colors.red,
              ),
              const _AlertaEmpleado(
                nombre: 'Sony WH-1000XM5',
                detalle: 'Quedan 3 unidades',
                cantidad: '3',
                color: Colors.orange,
              ),

              const SizedBox(height: 24),

              const Text(
                'Movimientos recientes',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              const _MovimientoEmpleado(
                nombre: 'Venta de iPad',
                detalle: 'Ticket TCK-1092',
                hora: '10:30 AM',
                icono: Icons.shopping_bag_outlined,
                cantidad: '-1',
                color: Colors.red,
              ),
              const _MovimientoEmpleado(
                nombre: 'Consulta AirPods',
                detalle: 'Consulta de inventario',
                hora: '10:15 AM',
                icono: Icons.search,
                cantidad: 'Consulta',
                color: azulEmpleado,
              ),
              const _MovimientoEmpleado(
                nombre: 'Venta de cargador',
                detalle: 'Ticket TCK-1081',
                hora: '09:55 AM',
                icono: Icons.shopping_bag_outlined,
                cantidad: '-3',
                color: Colors.red,
              ),
              const _MovimientoEmpleado(
                nombre: 'Recepción Hub Anker',
                detalle: 'Entrada de mercancía',
                hora: '09:20 AM',
                icono: Icons.inventory,
                cantidad: '+5',
                color: Colors.green,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: azulEmpleado,
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
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InventarioEmpleadoScreen(
                  usuarioId: usuarioId,
                  nombreEmpleado: nombreEmpleado,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class _AccionEmpleado extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final Color color;
  final VoidCallback alPresionar;

  const _AccionEmpleado({
    required this.icono,
    required this.titulo,
    required this.color,
    required this.alPresionar,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: alPresionar,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 105,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, color: color, size: 27),
            const SizedBox(height: 9),
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
    );
  }
}

class _IndicadorEmpleado extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;
  final Color color;

  const _IndicadorEmpleado({
    required this.titulo,
    required this.valor,
    required this.icono,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: color, size: 25),
          const SizedBox(height: 12),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertaEmpleado extends StatelessWidget {
  final String nombre;
  final String detalle;
  final String cantidad;
  final Color color;

  const _AlertaEmpleado({
    required this.nombre,
    required this.detalle,
    required this.cantidad,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: color,
            size: 27,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detalle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            cantidad,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
        ],
      ),
    );
  }
}

class _MovimientoEmpleado extends StatelessWidget {
  final String nombre;
  final String detalle;
  final String hora;
  final IconData icono;
  final String cantidad;
  final Color color;

  const _MovimientoEmpleado({
    required this.nombre,
    required this.detalle,
    required this.hora,
    required this.icono,
    required this.cantidad,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.10),
            child: Icon(icono, color: color, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detalle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                cantidad,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                hora,
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// PANTALLA PARA REGISTRAR ENTRADAS

class RegistrarEntradaEmpleadoScreen extends StatefulWidget {
  const RegistrarEntradaEmpleadoScreen({super.key});

  @override
  State<RegistrarEntradaEmpleadoScreen> createState() =>
      _RegistrarEntradaEmpleadoScreenState();
}

class _RegistrarEntradaEmpleadoScreenState
    extends State<RegistrarEntradaEmpleadoScreen> {
  Producto? productoSeleccionado;

  final TextEditingController cantidadController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    if (InventarioRepositorio.productos.isNotEmpty) {
      productoSeleccionado =
          InventarioRepositorio.productos.first;
    }
  }

  @override
  void dispose() {
    cantidadController.dispose();
    super.dispose();
  }

  void registrarEntrada() {
    final cantidad =
        int.tryParse(cantidadController.text.trim());

    if (productoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona un producto'),
        ),
      );
      return;
    }

    if (cantidad == null || cantidad <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa una cantidad válida'),
        ),
      );
      return;
    }

    productoSeleccionado!.stock += cantidad;

    final messenger = ScaffoldMessenger.of(context);
    final nombreProducto = productoSeleccionado!.nombre;

    Navigator.pop(context);

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'Entrada registrada: $cantidad unidades de $nombreProducto',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoEmpleado,
      appBar: AppBar(
        title: const Text('Registrar entrada'),
        backgroundColor: azulEmpleado,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Entrada de mercancía',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selecciona el producto y registra la cantidad recibida.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 25),

            const Text(
              'Producto',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<Producto>(
              value: productoSeleccionado,
              isExpanded: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              hint: const Text('Selecciona un producto'),
              items: InventarioRepositorio.productos.map(
                (producto) {
                  return DropdownMenuItem<Producto>(
                    value: producto,
                    child: Text(
                      producto.nombre,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ).toList(),
              onChanged: (producto) {
                setState(() {
                  productoSeleccionado = producto;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Cantidad recibida',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: cantidadController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Ej. 10',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: registrarEntrada,
                icon: const Icon(Icons.add),
                label: const Text('Guardar entrada'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: azulEmpleado,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}