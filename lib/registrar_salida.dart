import 'package:flutter/material.dart';

import 'inicio_empleado.dart';
import 'inventario_empleado.dart';
import 'miturno.dart';

class RegistrarSalidaScreen extends StatefulWidget {
  const RegistrarSalidaScreen({super.key});

  @override
  State<RegistrarSalidaScreen> createState() =>
      _RegistrarSalidaScreenState();
}

class _RegistrarSalidaScreenState extends State<RegistrarSalidaScreen> {
  final TextEditingController clienteController = TextEditingController();
  final TextEditingController notasController = TextEditingController();

  String productoSeleccionado = 'iPhone 15 Pro Max 256GB Titan';
  String ticket = 'TCK-1093';
  String entrega = 'Mostrador';
  int cantidad = 1;

  final Map<String, Map<String, dynamic>> productos = {
    'iPhone 15 Pro Max 256GB Titan': {
      'sku': 'APL-15PM-256',
      'precio': 1199.0,
      'stock': 14,
    },
    'MacBook Pro 14 M3': {
      'sku': 'APL-MBP-14M3',
      'precio': 1999.0,
      'stock': 2,
    },
    'Galaxy S24 Ultra 512GB': {
      'sku': 'SAM-S24U-512',
      'precio': 1299.0,
      'stock': 8,
    },
    'Sony WH-1000XM5': {
      'sku': 'SNY-WH1005',
      'precio': 349.0,
      'stock': 22,
    },
    'ASUS ROG Zephyrus G16': {
      'sku': 'ASU-ROG-G16',
      'precio': 1799.0,
      'stock': 5,
    },
  };

  Map<String, dynamic> get producto => productos[productoSeleccionado]!;

  int get stockActual => producto['stock'] as int;

  double get total => (producto['precio'] as double) * cantidad;

  @override
  void dispose() {
    clienteController.dispose();
    notasController.dispose();
    super.dispose();
  }

  void confirmarSalida() {
    if (cantidad < 1) {
      mostrarMensaje('La cantidad debe ser mayor que cero');
      return;
    }

    if (cantidad > stockActual) {
      mostrarMensaje('No hay suficiente inventario disponible');
      return;
    }

    if (ticket.trim().isEmpty) {
      mostrarMensaje('Ingresa el número de ticket');
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar salida'),
          content: Text(
            '¿Registrar la salida de $cantidad unidad(es) de '
            '$productoSeleccionado por \$${total.toStringAsFixed(2)}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  productos[productoSeleccionado]!['stock'] =
                      stockActual - cantidad;
                });

                Navigator.pop(dialogContext);
                mostrarMensaje('Salida registrada correctamente');
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int stockRestante = stockActual - cantidad;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF00288E)),
        title: const Text(
          'Registrar salida',
          style: TextStyle(
            color: Color(0xFF00288E),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.point_of_sale,
                        color: Color(0xFF00288E), size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nueva salida de inventario',
                            style: TextStyle(
                              color: Color(0xFF00288E),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Registra los productos entregados al cliente',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              _titulo('1. Seleccionar producto'),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: productoSeleccionado,
                isExpanded: true,
                decoration: _decoracion('Producto'),
                items: productos.keys.map((nombre) {
                  return DropdownMenuItem(
                    value: nombre,
                    child: Text(
                      nombre,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (valor) {
                  if (valor != null) {
                    setState(() {
                      productoSeleccionado = valor;
                      cantidad = 1;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productoSeleccionado,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'SKU: ${producto['sku']}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Precio unitario: \$${(producto['precio'] as double).toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFF00288E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Stock: $stockActual',
                          style: TextStyle(
                            color: stockActual <= 5 ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              _titulo('2. Cantidad a entregar'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black12),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Unidades',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      onPressed: cantidad > 1
                          ? () => setState(() => cantidad--)
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      '$cantidad',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                    IconButton(
                      onPressed: cantidad < stockActual
                          ? () => setState(() => cantidad++)
                          : null,
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: Color(0xFF00288E),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.inventory_2_outlined,
                      color: Colors.black54, size: 18),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      'Después de la salida quedarán $stockRestante unidades',
                      style: TextStyle(
                        color: stockRestante < 0 ? Colors.red : Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _titulo('3. Información del ticket'),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: ticket,
                decoration: _decoracion('Número de ticket'),
                onChanged: (valor) => ticket = valor,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: clienteController,
                decoration: _decoracion('Nombre del cliente (opcional)'),
              ),
              const SizedBox(height: 22),
              _titulo('4. Método de entrega'),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: entrega,
                decoration: _decoracion('Método de entrega'),
                items: const [
                  DropdownMenuItem(
                    value: 'Mostrador',
                    child: Text('Entrega en mostrador'),
                  ),
                  DropdownMenuItem(
                    value: 'Despacho',
                    child: Text('Despacho / Envío'),
                  ),
                ],
                onChanged: (valor) {
                  if (valor != null) {
                    setState(() => entrega = valor);
                  }
                },
              ),
              const SizedBox(height: 22),
              _titulo('5. Notas adicionales'),
              const SizedBox(height: 10),
              TextField(
                controller: notasController,
                maxLines: 3,
                decoration: _decoracion('Escribe alguna observación...'),
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resumen de la salida',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _filaResumen('Producto', productoSeleccionado),
                    _filaResumen('Cantidad', '$cantidad unidades'),
                    _filaResumen('Entrega', entrega),
                    const Divider(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFF00288E),
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Row(
                children: [
                  Icon(Icons.person_outline, color: Color(0xFF00288E)),
                  SizedBox(width: 8),
                  Text(
                    'Empleado: Lucía Torres · EMP-042',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: confirmarSalida,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00288E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    'Confirmar salida',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
      // Barra agregada (igual a la de Mi turno) para poder navegar. Bórrala si no la quieres.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => InicioEmpleadoScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => InventarioEmpleadoScreen()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MiTurnoScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _titulo(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Color(0xFF131B2E),
      ),
    );
  }

  InputDecoration _decoracion(String texto) {
    return InputDecoration(
      labelText: texto,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFF00288E), width: 1.5),
      ),
    );
  }

  Widget _filaResumen(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
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