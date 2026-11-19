import 'package:flutter/material.dart';
import 'inventario.dart';
import 'inicio.dart';
import 'historial.dart';

class MovimientosScreen extends StatefulWidget {
  /// Nombre de un producto para preseleccionarlo al entrar desde
  /// el botón "Registrar movimiento" de Inventario. Si no se manda
  /// (o no coincide con ninguno), se usa el primer producto de la lista.
  final String? productoInicial;

  const MovimientosScreen({super.key, this.productoInicial});

  @override
  State<MovimientosScreen> createState() => _MovimientosScreenState();
}

class _MovimientosScreenState extends State<MovimientosScreen> {
  bool esEntrada = true;
  int cantidad = 1;

  final referenciaController = TextEditingController();
  final costoController = TextEditingController();
  final notasController = TextEditingController();

  late Producto productoSeleccionado;
  String proveedor = 'Apple Direct';

  @override
  void initState() {
    super.initState();

    final productos = InventarioRepositorio.productos;
    productoSeleccionado = productos.firstWhere(
      (p) => p.nombre == widget.productoInicial,
      orElse: () => productos.first,
    );

    costoController.text = productoSeleccionado.precio.toStringAsFixed(2);
  }

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

  // BOTÓN "Confirmar entrada" / "Confirmar salida"
  void registrarMovimiento() {
    if (cantidad < 1) {
      _mensaje('La cantidad debe ser mayor que cero');
      return;
    }

    if (!esEntrada && cantidad > productoSeleccionado.stock) {
      _mensaje('No hay suficiente inventario para esta salida');
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar movimiento'),
        content: Text(
          '${esEntrada ? "Entrada" : "Salida"} de $cantidad unidad(es) de '
          '${productoSeleccionado.nombre}.\n'
          'Total: \$${total.toStringAsFixed(2)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Aquí es donde realmente se actualiza el stock
              // compartido con Inventario (InventarioRepositorio).
              setState(() {
                if (esEntrada) {
                  productoSeleccionado.stock += cantidad;
                } else {
                  productoSeleccionado.stock -= cantidad;
                }
                cantidad = 1;
                referenciaController.clear();
                notasController.clear();
              });

              Navigator.pop(dialogContext);
              _mensaje(
                '${esEntrada ? "Entrada" : "Salida"} registrada. '
                'Nuevo stock de ${productoSeleccionado.nombre}: '
                '${productoSeleccionado.stock} unidades',
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _mensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  void _irA(Widget pantalla) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => pantalla));
  }

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF00288E);
    final productos = InventarioRepositorio.productos;

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

            // BOTONES "Entrada" / "Salida"
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

            // DROPDOWN de producto -> ahora sí tomado del inventario real
            DropdownButtonFormField<Producto>(
              value: productoSeleccionado,
              isExpanded: true,
              decoration: _decoracion('Selecciona un producto'),
              items: productos.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Text(
                    p.nombre,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (valor) {
                if (valor != null) {
                  setState(() {
                    productoSeleccionado = valor;
                    cantidad = 1;
                    costoController.text =
                        productoSeleccionado.precio.toStringAsFixed(2);
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
                    productoSeleccionado.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text('SKU: ${productoSeleccionado.sku}'),
                  const SizedBox(height: 5),
                  Text(
                    'Stock actual: ${productoSeleccionado.stock} unidades',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 23),
            _titulo('Cantidad de unidades'),

            // STEPPER de cantidad -> respeta el stock real del producto
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
                        if (esEntrada ||
                            cantidad < productoSeleccionado.stock) {
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
                      Text(
                        esEntrada
                            ? 'Stock después de la entrada'
                            : 'Stock después de la salida',
                      ),
                      Text(
                        '${esEntrada ? productoSeleccionado.stock + cantidad : productoSeleccionado.stock - cantidad}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
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
      // MENÚ INFERIOR conectado a las demás pantallas del admin
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
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
            case 1:
              _irA(const InventarioScreen());
              break;
            case 3:
              _irA(const HistorialScreen());
              break;
          }
        },
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
