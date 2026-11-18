import 'package:flutter/material.dart';

class MovimientosScreen extends StatefulWidget {
  const MovimientosScreen({super.key});

  @override
  State<MovimientosScreen> createState() => _MovimientosScreenState();
}

class _MovimientosScreenState extends State<MovimientosScreen> {
  bool esEntrada = true;
  int cantidad = 1;

  final referenciaController = TextEditingController();
  final costoController = TextEditingController(text: '1199');
  final notasController = TextEditingController();

  String producto = 'iPhone 15 Pro Max 256GB';
  String proveedor = 'Apple Direct';
  final int stockActual = 14;

  @override
  void dispose() {
    referenciaController.dispose();
    costoController.dispose();
    notasController.dispose();
    super.dispose();
  }

  double get total {
    return (double.tryParse(costoController.text) ?? 0) * cantidad;
  }

  void registrarMovimiento() {
    if (cantidad < 1) return;

    if (!esEntrada && cantidad > stockActual) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay suficiente inventario para esta salida'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Movimiento registrado'),
        content: Text(
          '${esEntrada ? "Entrada" : "Salida"} de $cantidad unidades de $producto.\n'
          'Total: \$${total.toStringAsFixed(2)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF00288E);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: AppBar(
        title: const Text(
          'Movimientos',
          style: TextStyle(
            color: azul,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: azul),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registrar movimiento',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 7),
            const Text(
              'Controla las entradas y salidas de tu inventario.',
              style: TextStyle(color: Color(0xFF444653)),
            ),
            const SizedBox(height: 22),

            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _tipoMovimiento(
                      'Entrada',
                      Icons.arrow_downward,
                      esEntrada,
                      () {
                        setState(() {
                          esEntrada = true;
                          cantidad = 1;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: _tipoMovimiento(
                      'Salida / Venta',
                      Icons.arrow_upward,
                      !esEntrada,
                      () {
                        setState(() {
                          esEntrada = false;
                          cantidad = 1;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _titulo('Producto seleccionado'),

            DropdownButtonFormField<String>(
              value: producto,
              isExpanded: true,
              decoration: _decoracion('Selecciona un producto'),
              items: const [
                DropdownMenuItem(
                  value: 'iPhone 15 Pro Max 256GB',
                  child: Text('iPhone 15 Pro Max 256GB'),
                ),
                DropdownMenuItem(
                  value: 'MacBook Air M2',
                  child: Text('MacBook Air M2'),
                ),
                DropdownMenuItem(
                  value: 'Sony WH-1000XM5',
                  child: Text('Sony WH-1000XM5'),
                ),
                DropdownMenuItem(
                  value: 'Galaxy S24 Ultra',
                  child: Text('Galaxy S24 Ultra'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    producto = value;
                  });
                }
              },
            ),

            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'INFORMACIÓN DE INVENTARIO',
                    style: TextStyle(
                      color: Color(0xFF444653),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    producto,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text('SKU: APL-15PM-256'),
                  const SizedBox(height: 5),
                  Text('Stock actual: $stockActual unidades'),
                ],
              ),
            ),

            const SizedBox(height: 23),
            _titulo('Cantidad de unidades'),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Cantidad',
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (esEntrada || cantidad < stockActual) {
                          cantidad++;
                        }
                      });
                    },
                    icon: const Icon(Icons.add_circle, color: azul),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 23),
            _titulo(esEntrada ? 'Proveedor' : 'Destino'),

            DropdownButtonFormField<String>(
              value: proveedor,
              decoration: _decoracion('Selecciona una opción'),
              items: const [
                DropdownMenuItem(
                  value: 'Apple Direct',
                  child: Text('Apple Direct'),
                ),
                DropdownMenuItem(
                  value: 'Almacén Central',
                  child: Text('Almacén Central'),
                ),
                DropdownMenuItem(
                  value: 'Venta en tienda',
                  child: Text('Venta en tienda'),
                ),
                DropdownMenuItem(
                  value: 'Venta en línea',
                  child: Text('Venta en línea'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    proveedor = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),
            _titulo('Referencia del documento'),
            TextField(
              controller: referenciaController,
              decoration: _decoracion('Ej. FAC-2024-8841'),
            ),

            const SizedBox(height: 20),
            _titulo(esEntrada ? 'Costo unitario' : 'Precio unitario'),
            TextField(
              controller: costoController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => setState(() {}),
              decoration: _decoracion('\$0.00').copyWith(
                prefixText: '\$ ',
              ),
            ),

            const SizedBox(height: 20),
            _titulo('Notas adicionales'),
            TextField(
              controller: notasController,
              maxLines: 3,
              decoration: _decoracion('Escribe alguna observación...'),
            ),

            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E7FF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Text(
                    'IMPACTO DEL MOVIMIENTO',
                    style: TextStyle(
                      color: azul,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Unidades'),
                      Text('$cantidad'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total'),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          color: azul,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: registrarMovimiento,
                icon: const Icon(Icons.check_circle_outline),
                label: Text(
                  esEntrada ? 'Confirmar entrada' : 'Confirmar salida',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: azul,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _titulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  InputDecoration _decoracion(String texto) {
    return InputDecoration(
      hintText: texto,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _tipoMovimiento(
    String texto,
    IconData icono,
    bool seleccionado,
    VoidCallback accion,
  ) {
    return InkWell(
      onTap: accion,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: seleccionado ? const Color(0xFF00288E) : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          children: [
            Icon(
              icono,
              color: seleccionado ? Colors.white : const Color(0xFF444653),
            ),
            const SizedBox(height: 5),
            Text(
              texto,
              style: TextStyle(
                color: seleccionado ? Colors.white : const Color(0xFF444653),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}