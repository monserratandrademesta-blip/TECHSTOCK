
import 'package:flutter/material.dart';
import 'servicios/api.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  String periodo = 'Todos';
  String filtro = 'Todos';

  bool cargando = true;
  String? errorCarga;

  List<MovimientoHistorial> movimientosApi = [];

  @override
  void initState() {
    super.initState();
    cargarMovimientos();
  }

  // CONSULTAR MOVIMIENTOS REALES DE MYSQL
  Future<void> cargarMovimientos() async {
    setState(() {
      cargando = true;
      errorCarga = null;
    });

    try {
      final id = Api.usuarioId;

      if (id == null) {
        throw Exception(
          'No se encontró la sesión del administrador. Inicia sesión nuevamente.',
        );
      }

      final datos = await Api.obtenerMovimientos(id);

      final lista = datos.map((movimiento) {
        return MovimientoHistorial.fromJson(
          Map<String, dynamic>.from(movimiento),
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        movimientosApi = lista;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
        errorCarga = e.toString();
      });
    }
  }

  // FILTRAR POR TIPO Y PERIODO
  List<MovimientoHistorial> get movimientosFiltrados {
    final ahora = DateTime.now();

    final lista = movimientosApi.where((m) {
      final coincideTipo =
          filtro == 'Todos' || m.tipo == filtro;

      bool coincidePeriodo = true;

      if (periodo == 'Hoy') {
        coincidePeriodo =
            m.fecha.year == ahora.year &&
            m.fecha.month == ahora.month &&
            m.fecha.day == ahora.day;
      } else if (periodo == 'Esta semana') {
        final inicioSemana = DateTime(
          ahora.year,
          ahora.month,
          ahora.day,
        ).subtract(Duration(days: ahora.weekday - 1));

        coincidePeriodo = !m.fecha.isBefore(inicioSemana);
      } else if (periodo == 'Este mes') {
        coincidePeriodo =
            m.fecha.year == ahora.year &&
            m.fecha.month == ahora.month;
      }

      return coincideTipo && coincidePeriodo;
    }).toList();

    // Mostrar primero los movimientos más recientes
    lista.sort((a, b) => b.fecha.compareTo(a.fecha));

    return lista;
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

    final entradas = movimientosApi
        .where((m) => m.tipo == 'Entrada')
        .length;

    final salidas = movimientosApi
        .where((m) => m.tipo == 'Salida')
        .length;

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
            onPressed: cargarMovimientos,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar movimientos',
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // RESUMEN
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
                    '${movimientosApi.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    'Total de transacciones registradas',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _resumenTipo(
                        'Entradas',
                        entradas,
                        Colors.greenAccent,
                      ),
                      const SizedBox(width: 25),
                      _resumenTipo(
                        'Salidas',
                        salidas,
                        Colors.orangeAccent,
                      ),
                    ],
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
                    color: periodo == p
                        ? Colors.white
                        : Colors.black87,
                  ),
                  onSelected: (_) {
                    setState(() => periodo = p);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 22),

            const Text(
              'Movimientos registrados',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),

            const SizedBox(height: 10),

            // FILTRO DE ENTRADAS Y SALIDAS
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
                    color: filtro == f
                        ? Colors.white
                        : Colors.black87,
                  ),
                  onSelected: (_) {
                    setState(() => filtro = f);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 14),

            if (cargando)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: CircularProgressIndicator(
                    color: azul,
                  ),
                ),
              )
            else if (errorCarga != null)
              _mensajeError()
            else if (movimientos.isEmpty)
              _mensajeVacio()
            else
              ...movimientos.map(_tarjetaMovimiento),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // RESUMEN DE ENTRADAS Y SALIDAS
  Widget _resumenTipo(
    String titulo,
    int cantidad,
    Color color,
  ) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          size: 9,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(
          '$titulo: $cantidad',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // MENSAJE DE ERROR
  Widget _mensajeError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off,
            size: 45,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 10),
          const Text(
            'No se pudieron cargar los movimientos',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 7),
          Text(
            errorCarga ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: cargarMovimientos,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  // MENSAJE SIN MOVIMIENTOS
  Widget _mensajeVacio() {
    return Container(
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
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            'Cuando registres una entrada o salida, aparecerá aquí.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // TARJETA DE MOVIMIENTO
  Widget _tarjetaMovimiento(MovimientoHistorial m) {
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
                  esEntrada
                      ? 'Entrada de inventario'
                      : 'Salida de inventario',
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
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),

          Text('SKU: ${m.sku}'),
          Text('Folio: ${m.folio.isEmpty ? 'Sin folio' : m.folio}'),
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

          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 17,
                color: Color(0xFF00288E),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  'Responsable: ${m.responsable}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),

          if (m.motivo.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              'Motivo: ${m.motivo}',
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

  // DATOS DE LA TARJETA
  Widget _dato(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo),
          Text(
            valor,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// MODELO DE MOVIMIENTOS DE LA API
class MovimientoHistorial {
  final String tipo;
  final String producto;
  final String sku;
  final String folio;
  final int cantidad;
  final int stockAnterior;
  final int stockNuevo;
  final double costoUnitario;
  final DateTime fecha;
  final String responsable;
  final String motivo;

  MovimientoHistorial({
    required this.tipo,
    required this.producto,
    required this.sku,
    required this.folio,
    required this.cantidad,
    required this.stockAnterior,
    required this.stockNuevo,
    required this.costoUnitario,
    required this.fecha,
    required this.responsable,
    required this.motivo,
  });

  double get total => cantidad * costoUnitario;

  factory MovimientoHistorial.fromJson(
    Map<String, dynamic> json,
  ) {
    final tipoOriginal =
        json['tipo']?.toString().toLowerCase() ?? '';

    return MovimientoHistorial(
      tipo: tipoOriginal == 'entrada' ? 'Entrada' : 'Salida',
      producto: json['producto']?.toString() ?? 'Sin producto',
      sku: json['sku']?.toString() ?? 'Sin SKU',
      folio: json['folio']?.toString() ?? '',
      cantidad: int.tryParse(
            json['cantidad']?.toString() ?? '',
          ) ??
          0,
      stockAnterior: int.tryParse(
            json['existencias_anteriores']?.toString() ?? '',
          ) ??
          0,
      stockNuevo: int.tryParse(
            json['existencias_nuevas']?.toString() ?? '',
          ) ??
          0,
      costoUnitario: double.tryParse(
            json['costo_unitario']?.toString() ?? '',
          ) ??
          0,
      fecha: DateTime.tryParse(
            json['fecha']?.toString() ?? '',
          ) ??
          DateTime.now(),
      responsable:
          json['responsable']?.toString() ?? 'Sin responsable',
      motivo: json['motivo']?.toString() ?? '',
    );
  }
}
