import 'package:flutter/material.dart';
import 'inventario.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  String periodo = 'Todos';
  String filtro = 'Todos';
  bool mostrarPersonal = false;

  final List<Map<String, String>> empleados = [
    {
      'nombre': 'Carlos Mendoza',
      'puesto': 'Administrador General',
      'correo': 'admin@techstock.com',
      'rol': 'Administrador',
    },
    {
      'nombre': 'Lucía Torres',
      'puesto': 'Ventas y almacén',
      'correo': 'lucia@techstock.com',
      'rol': 'Empleado',
    },
  ];

  List<MovimientoInventario> get movimientosFiltrados {
    final ahora = DateTime.now();

    return InventarioRepositorio.movimientos.where((m) {
      final coincideTipo = filtro == 'Todos' || m.tipo == filtro;

      bool coincidePeriodo = true;

      if (periodo == 'Hoy') {
        coincidePeriodo =
            m.fecha.year == ahora.year &&
            m.fecha.month == ahora.month &&
            m.fecha.day == ahora.day;
      } else if (periodo == 'Esta semana') {
        final inicioSemana =
            DateTime(ahora.year, ahora.month, ahora.day)
                .subtract(Duration(days: ahora.weekday - 1));

        coincidePeriodo = !m.fecha.isBefore(inicioSemana);
      } else if (periodo == 'Este mes') {
        coincidePeriodo =
            m.fecha.year == ahora.year &&
            m.fecha.month == ahora.month;
      }

      return coincideTipo && coincidePeriodo;
    }).toList();
  }

  String formatoFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year;
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');

    return '$dia/$mes/$anio · $hora:$minuto';
  }

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF00288E);
    final movimientos = movimientosFiltrados;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Historial y Auditoría',
          style: TextStyle(
            color: azul,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: azul),
        actions: [
          IconButton(
            onPressed: exportar,
            icon: const Icon(Icons.download_outlined),
            tooltip: 'Exportar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // RESUMEN REAL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(19),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [azul, Color(0xFF0051D5)],
                ),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'OPERACIONES REGISTRADAS',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '${InventarioRepositorio.movimientos.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    'Total de transacciones de esta sesión',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Periodo de consulta',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 7,
              children: [
                'Todos',
                'Hoy',
                'Esta semana',
                'Este mes',
              ].map((p) {
                return ChoiceChip(
                  label: Text(p),
                  selected: periodo == p,
                  selectedColor: azul,
                  labelStyle: TextStyle(
                    color: periodo == p ? Colors.white : Colors.black87,
                  ),
                  onSelected: (_) {
                    setState(() => periodo = p);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 22),

            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _pestana(
                      'Auditoría',
                      !mostrarPersonal,
                      () => setState(() => mostrarPersonal = false),
                    ),
                  ),
                  Expanded(
                    child: _pestana(
                      'Personal y Roles',
                      mostrarPersonal,
                      () => setState(() => mostrarPersonal = true),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (!mostrarPersonal) ...[
              const Text(
                'Movimientos registrados',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 7,
                children: [
                  'Todos',
                  'Entrada',
                  'Salida',
                ].map((f) {
                  return ChoiceChip(
                    label: Text(f),
                    selected: filtro == f,
                    selectedColor: azul,
                    labelStyle: TextStyle(
                      color: filtro == f ? Colors.white : Colors.black87,
                    ),
                    onSelected: (_) => setState(() => filtro = f),
                  );
                }).toList(),
              ),

              const SizedBox(height: 14),

              if (movimientos.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.history,
                        size: 45,
                        color: Color(0xFF8A91A5),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No hay movimientos registrados',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Cuando registres una entrada o salida, aparecerá aquí.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                )
              else
                ...movimientos.map(_tarjetaMovimiento),
            ] else ...[
              const Text(
                'Gestión de personal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Expanded(
                    child: _resumenPersonal('Administradores', '1'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _resumenPersonal('Empleados', '1'),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...empleados.map(_tarjetaEmpleado),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _pestana(
    String texto,
    bool seleccionada,
    VoidCallback accion,
  ) {
    return InkWell(
      onTap: accion,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: seleccionada
              ? const Color(0xFF00288E)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: seleccionada
                ? Colors.white
                : const Color(0xFF444653),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _tarjetaMovimiento(MovimientoInventario m) {
    final esEntrada = m.tipo == 'Entrada';
    final color = esEntrada ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                esEntrada
                    ? Icons.arrow_downward
                    : Icons.arrow_upward,
                color: color,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  esEntrada ? 'Entrada de inventario' : 'Salida de inventario',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${esEntrada ? '+' : '-'}${m.cantidad}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const Divider(height: 22),

          Text(
            m.producto,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 5),
          Text('SKU: ${m.sku}'),
          Text('Folio: ${m.folio}'),
          Text('Fecha: ${formatoFecha(m.fecha)}'),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E7FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                _dato('Stock anterior', '${m.stockAnterior}'),
                _dato('Cantidad del movimiento', '${m.cantidad}'),
                _dato('Stock nuevo', '${m.stockNuevo}'),
                _dato(
                  'Total',
                  '\$${m.total.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          Text(
            'Responsable: ${m.responsable}',
            style: const TextStyle(fontSize: 12),
          ),

          if (m.destino.isNotEmpty)
            Text(
              'Proveedor / Destino: ${m.destino}',
              style: const TextStyle(fontSize: 12),
            ),

          if (m.referencia.isNotEmpty)
            Text(
              'Referencia: ${m.referencia}',
              style: const TextStyle(fontSize: 12),
            ),

          if (m.notas.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              'Notas: ${m.notas}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF0051D5),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _dato(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo),
          Text(
            valor,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaEmpleado(Map<String, String> empleado) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE2E7FF),
            child: Icon(
              Icons.person,
              color: Color(0xFF00288E),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  empleado['nombre']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  empleado['puesto']!,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  empleado['correo']!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF444653),
                  ),
                ),
                Text(
                  empleado['rol']!,
                  style: const TextStyle(
                    color: Color(0xFF0051D5),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void exportar() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Exportar auditoría',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              ListTile(
                leading: const Icon(
                  Icons.table_chart,
                  color: Colors.green,
                ),
                title: const Text('Excel (.xlsx)'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'La exportación a Excel aún está pendiente.',
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red,
                ),
                title: const Text('PDF'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'La exportación a PDF aún está pendiente.',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _resumenPersonal extends StatelessWidget {
  final String titulo;
  final String cantidad;

  const _resumenPersonal(this.titulo, this.cantidad);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            cantidad,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00288E),
            ),
          ),
          Text(titulo, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}