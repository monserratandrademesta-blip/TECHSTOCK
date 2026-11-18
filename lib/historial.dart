import 'package:flutter/material.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  String periodo = 'Hoy';
  String filtro = 'Todos';
  bool mostrarPersonal = false;

  final List<Map<String, dynamic>> movimientos = [
    {
      'tipo': 'Entrada',
      'titulo': 'Entrada por Compra',
      'folio': 'ENT-9021',
      'producto': 'iPhone 15 Pro Max 256GB',
      'cantidad': '+10 unidades',
      'fecha': 'Hoy · 11:45 AM',
      'usuario': 'Carlos Mendoza · Admin',
      'detalle': 'Apple Direct · FAC-2024-8841',
    },
    {
      'tipo': 'Salida',
      'titulo': 'Salida por Venta en Tienda',
      'folio': 'SAL-4412',
      'producto': 'MacBook Air M2 256GB',
      'cantidad': '-1 unidad',
      'fecha': 'Hoy · 10:30 AM',
      'usuario': 'Lucía Torres · Ventas',
      'detalle': 'TCK-1092',
    },
    {
      'tipo': 'Salida',
      'titulo': 'Salida por Venta en Línea',
      'folio': 'SAL-4411',
      'producto': 'Sony WH-1000XM5',
      'cantidad': '-2 unidades',
      'fecha': 'Hoy · 09:15 AM',
      'usuario': 'Carlos Mendoza · Admin',
      'detalle': 'TCK-1091',
    },
    {
      'tipo': 'Entrada',
      'titulo': 'Ingreso de Importación',
      'folio': 'ENT-9020',
      'producto': 'ASUS ROG Zephyrus G16',
      'cantidad': '+5 unidades',
      'fecha': 'Ayer · 16:40 PM',
      'usuario': 'Carlos Mendoza · Admin',
      'detalle': 'Almacén Central Tech',
    },
    {
      'tipo': 'Ajuste',
      'titulo': 'Ajuste por Auditoría Física',
      'folio': 'AJU-012',
      'producto': 'Cables USB-C 100W',
      'cantidad': '-1 unidad',
      'fecha': 'Ayer · 14:10 PM',
      'usuario': 'Carlos Mendoza · Auditor',
      'detalle': 'Motivo: Muestra dañada',
    },
  ];

  final List<Map<String, String>> empleados = [
    {
      'nombre': 'Elena Morales',
      'puesto': 'Supervisora TI & Stock',
      'correo': 'elena.m@techstock.internal',
      'rol': 'Administrador',
    },
    {
      'nombre': 'Lucía Torres',
      'puesto': 'Ventas & Salidas',
      'correo': 'lucia.t@techstock.internal',
      'rol': 'Empleado',
    },
    {
      'nombre': 'Javier Ortiz',
      'puesto': 'Operador de Logística',
      'correo': 'javier.o@techstock.internal',
      'rol': 'Empleado',
    },
  ];

  List<Map<String, dynamic>> get movimientosFiltrados {
    if (filtro == 'Todos') return movimientos;
    return movimientos.where((m) => m['tipo'] == filtro).toList();
  }

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF00288E);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Historial y Auditoría',
          style: TextStyle(color: azul, fontWeight: FontWeight.bold),
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(19),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [azul, Color(0xFF0051D5)],
                ),
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OPERACIONES REGISTRADAS',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    '1,842',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Total de transacciones',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            const Text(
              'Periodo de consulta',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 7,
              children: ['Hoy', 'Esta semana', 'Este mes', 'Personalizado']
                  .map((p) => ChoiceChip(
                        label: Text(p),
                        selected: periodo == p,
                        selectedColor: const Color(0xFF00288E),
                        labelStyle: TextStyle(
                          color: periodo == p ? Colors.white : Colors.black87,
                        ),
                        onSelected: (_) {
                          setState(() => periodo = p);
                        },
                      ))
                  .toList(),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 7,
                children: ['Todos', 'Entrada', 'Salida', 'Ajuste']
                    .map((f) => ChoiceChip(
                          label: Text(f),
                          selected: filtro == f,
                          selectedColor: azul,
                          labelStyle: TextStyle(
                            color: filtro == f ? Colors.white : Colors.black87,
                          ),
                          onSelected: (_) => setState(() => filtro = f),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 14),
              ...movimientosFiltrados.map((m) => _tarjetaMovimiento(m)),
            ] else ...[
              const Text(
                'Gestión de personal',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Expanded(
                    child: _resumenPersonal('Administradores', '2'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _resumenPersonal('Empleados', '4'),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...empleados.map((e) => _tarjetaEmpleado(e)),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _pestana(String texto, bool seleccionada, VoidCallback accion) {
    return InkWell(
      onTap: accion,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: seleccionada ? const Color(0xFF00288E) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: seleccionada ? Colors.white : const Color(0xFF444653),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _tarjetaMovimiento(Map<String, dynamic> m) {
    final esEntrada = m['tipo'] == 'Entrada';
    final esAjuste = m['tipo'] == 'Ajuste';

    final color = esEntrada
        ? Colors.green
        : esAjuste
            ? Colors.orange
            : Colors.red;

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
                    : esAjuste
                        ? Icons.tune
                        : Icons.arrow_upward,
                color: color,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  m['titulo'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                m['cantidad'],
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 22),
          Text(
            m['producto'],
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Text(
            'Folio: ${m['folio']}',
            style: const TextStyle(color: Color(0xFF444653), fontSize: 12),
          ),
          Text(
            '${m['fecha']} · ${m['usuario']}',
            style: const TextStyle(color: Color(0xFF444653), fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            m['detalle'],
            style: const TextStyle(
              color: Color(0xFF0051D5),
              fontSize: 12,
            ),
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
            child: Icon(Icons.person, color: Color(0xFF00288E)),
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
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'La administración de roles está reservada al SuperAdmin',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.manage_accounts),
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
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              ListTile(
                leading: const Icon(Icons.table_chart, color: Colors.green),
                title: const Text('Excel (.xlsx)'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text('Prepararemos la exportación a Excel'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                title: const Text('PDF'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text('Prepararemos la exportación a PDF'),
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