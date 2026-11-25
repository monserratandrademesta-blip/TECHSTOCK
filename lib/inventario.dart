import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'historial.dart';
import 'inicio.dart';
import 'movimientos.dart';

const Color azul = Color(0xFF00288E);
const Color fondoInventario = Color(0xFFFAF8FF);

class ApiException implements Exception {
  final String mensaje;
  const ApiException(this.mensaje);
  @override
  String toString() => mensaje;
}

int _entero(dynamic valor) =>
    valor is int ? valor : int.tryParse(valor?.toString() ?? '') ?? 0;

double _decimal(dynamic valor) => valor is num
    ? valor.toDouble()
    : double.tryParse(valor?.toString() ?? '') ?? 0;

class Categoria {
  final int id;
  final String nombre;
  final String? descripcion;

  const Categoria({required this.id, required this.nombre, this.descripcion});

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
    id: _entero(json['id']),
    nombre: json['nombre']?.toString() ?? '',
    descripcion: json['descripcion']?.toString(),
  );
}

class Producto {
  final int id;
  String sku;
  String nombre;
  String detalle;
  double precio;
  double costo;
  int stock;
  int? categoriaId;
  String categoria;

  Producto({
    required this.id,
    required this.sku,
    required this.nombre,
    required this.detalle,
    required this.precio,
    required this.costo,
    required this.stock,
    required this.categoriaId,
    required this.categoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
    id: _entero(json['id']),
    sku: json['sku']?.toString() ?? '',
    nombre: json['nombre']?.toString() ?? '',
    detalle: json['detalle']?.toString() ?? '',
    precio: _decimal(json['precio']),
    costo: _decimal(json['costo']),
    stock: _entero(json['existencias']),
    categoriaId: json['categoria_id'] == null
        ? null
        : _entero(json['categoria_id']),
    categoria: json['categoria']?.toString() ?? 'Sin categoría',
  );
}

class MovimientoInventario {
  final String folio;
  final String tipo;
  final String producto;
  final String sku;
  final int cantidad;
  final int stockAnterior;
  final int stockNuevo;
  final double costoUnitario;
  final DateTime fecha;
  final String responsable;
  final String referencia;
  final String destino;
  final String notas;

  MovimientoInventario({
    required this.folio,
    required this.tipo,
    required this.producto,
    required this.sku,
    required this.cantidad,
    required this.stockAnterior,
    required this.stockNuevo,
    required this.costoUnitario,
    required this.fecha,
    required this.responsable,
    required this.referencia,
    required this.destino,
    required this.notas,
  });

  double get total => cantidad * costoUnitario;
}

/// Repositorio compartido: Flutter solamente se comunica con la API Node.
class InventarioRepositorio {
  InventarioRepositorio._();

  /// Sobrescribe esta URL al ejecutar:
  /// flutter run --dart-define=API_BASE_URL=http://IP_DE_UBUNTU:3001
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3001',
  );

  static const int administradorId = int.fromEnvironment(
    'ADMIN_ID',
    defaultValue: 1,
  );

  static List<Producto> productos = [];
  static List<Categoria> categorias = [];
  static final List<MovimientoInventario> movimientos = [];
  static int _consecutivoEntrada = 9022;
  static int _consecutivoSalida = 4413;

  static String get _base => apiBaseUrl.endsWith('/')
      ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
      : apiBaseUrl;

  static Uri _uri(String ruta) => Uri.parse('$_base$ruta');

  static Map<String, String> get _json => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> get _admin => {
    ..._json,
    'x-usuario-id': administradorId.toString(),
  };

  static dynamic _respuesta(http.Response respuesta) {
    dynamic datos;
    try {
      datos = respuesta.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(respuesta.body);
    } catch (_) {
      throw const ApiException('La API devolvió una respuesta no válida.');
    }

    if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
      return datos;
    }

    if (datos is Map) {
      final mensaje = datos['mensaje'] ?? datos['error'];
      if (mensaje != null) throw ApiException(mensaje.toString());
    }
    throw ApiException(
      'La operación no pudo completarse (' +
          respuesta.statusCode.toString() +
          ').',
    );
  }

  static Future<List<dynamic>> _lista(String ruta) async {
    try {
      final respuesta = await http
          .get(_uri(ruta), headers: _json)
          .timeout(const Duration(seconds: 15));
      final datos = _respuesta(respuesta);
      if (datos is! List) {
        throw const ApiException('La API no devolvió una lista válida.');
      }
      return datos;
    } on TimeoutException {
      throw const ApiException('La API tardó demasiado en responder.');
    } on http.ClientException {
      throw const ApiException(
        'No fue posible conectar con la API. Verifica su IP y el puerto 3001.',
      );
    }
  }

  static Future<void> cargarInventario() async {
    final respuestas = await Future.wait([
      _lista('/api/categorias'),
      _lista('/api/productos'),
    ]);

    categorias = respuestas[0]
        .map((e) => Categoria.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    productos = respuestas[1]
        .map((e) => Producto.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  static Future<Producto> crearProducto({
    required String sku,
    required String nombre,
    required double precio,
    required int existencias,
    required int categoriaId,
  }) async {
    return _guardarProducto(
      ruta: '/api/productos',
      metodo: 'POST',
      sku: sku,
      nombre: nombre,
      detalle: 'Producto registrado',
      precio: precio,
      costo: 0,
      existencias: existencias,
      categoriaId: categoriaId,
      motivo: 'Alta de producto',
    );
  }

  static Future<Producto> actualizarProducto({
    required Producto producto,
    required String sku,
    required String nombre,
    required String detalle,
    required double precio,
    required int existencias,
    required int categoriaId,
  }) async {
    return _guardarProducto(
      ruta: '/api/productos/' + producto.id.toString(),
      metodo: 'PUT',
      sku: sku,
      nombre: nombre,
      detalle: detalle,
      precio: precio,
      costo: producto.costo,
      existencias: existencias,
      categoriaId: categoriaId,
      motivo: 'Ajuste desde la edición de inventario',
    );
  }

  static Future<Producto> _guardarProducto({
    required String ruta,
    required String metodo,
    required String sku,
    required String nombre,
    required String detalle,
    required double precio,
    required double costo,
    required int existencias,
    required int categoriaId,
    required String motivo,
  }) async {
    try {
      final cuerpo = jsonEncode({
        'sku': sku,
        'nombre': nombre,
        'detalle': detalle,
        'precio': precio,
        'costo': costo,
        'existencias': existencias,
        'categoria_id': categoriaId,
        'motivo': motivo,
      });
      final Future<http.Response> solicitud = metodo == 'POST'
          ? http.post(_uri(ruta), headers: _admin, body: cuerpo)
          : http.put(_uri(ruta), headers: _admin, body: cuerpo);
      final respuesta = await solicitud.timeout(const Duration(seconds: 15));
      final datos = Map<String, dynamic>.from(_respuesta(respuesta) as Map);
      return Producto.fromJson(
        Map<String, dynamic>.from(datos['producto'] as Map),
      );
    } on TimeoutException {
      throw const ApiException('La API tardó demasiado en responder.');
    } on http.ClientException {
      throw const ApiException('No fue posible conectar con la API.');
    }
  }

  static Future<void> eliminarProducto(Producto producto) async {
    try {
      final respuesta = await http
          .delete(
            _uri('/api/productos/' + producto.id.toString()),
            headers: _admin,
          )
          .timeout(const Duration(seconds: 15));
      _respuesta(respuesta);
    } on TimeoutException {
      throw const ApiException('La API tardó demasiado en responder.');
    } on http.ClientException {
      throw const ApiException('No fue posible conectar con la API.');
    }
  }

  static Future<void> registrarMovimientoRemoto({
    required Producto producto,
    required bool esEntrada,
    required int cantidad,
    required double costoUnitario,
    required String folio,
    required String referencia,
    required String destino,
    required String notas,
  }) async {
    if (producto.id <= 0) {
      throw const ApiException('El producto no tiene un identificador válido.');
    }
    try {
      final respuesta = await http
          .post(
            _uri('/api/movimientos'),
            headers: _admin,
            body: jsonEncode({
              'producto_id': producto.id,
              'tipo': esEntrada ? 'entrada' : 'salida',
              'cantidad': cantidad,
              'costo_unitario': costoUnitario,
              'folio': folio,
              'referencia': referencia,
              'destino': destino,
              'notas': notas,
            }),
          )
          .timeout(const Duration(seconds: 15));
      _respuesta(respuesta);
    } on TimeoutException {
      throw const ApiException('La API tardó demasiado en responder.');
    } on http.ClientException {
      throw const ApiException('No fue posible conectar con la API.');
    }
  }

  /// Conserva la interfaz utilizada por movimientos.dart e historial.dart.
  static MovimientoInventario registrarMovimiento({
    required Producto producto,
    required bool esEntrada,
    required int cantidad,
    required double costoUnitario,
    required String responsable,
    String referencia = '',
    String destino = '',
    String notas = '',
  }) {
    if (!productos.contains(producto)) {
      throw ArgumentError('El producto no pertenece al inventario.');
    }
    if (cantidad <= 0)
      throw ArgumentError('La cantidad debe ser mayor que cero.');
    if (!costoUnitario.isFinite || costoUnitario < 0) {
      throw ArgumentError('El costo o precio no es válido.');
    }
    if (!esEntrada && cantidad > producto.stock) {
      throw StateError('No hay suficiente inventario para esta salida.');
    }

    final anterior = producto.stock;
    final nuevo = esEntrada ? anterior + cantidad : anterior - cantidad;
    final folio = esEntrada
        ? 'ENT-' + (_consecutivoEntrada++).toString()
        : 'SAL-' + (_consecutivoSalida++).toString();
    final movimiento = MovimientoInventario(
      folio: folio,
      tipo: esEntrada ? 'Entrada' : 'Salida',
      producto: producto.nombre,
      sku: producto.sku,
      cantidad: cantidad,
      stockAnterior: anterior,
      stockNuevo: nuevo,
      costoUnitario: costoUnitario,
      fecha: DateTime.now(),
      responsable: responsable,
      referencia: referencia.trim(),
      destino: destino.trim(),
      notas: notas.trim(),
    );

    producto.stock = nuevo;
    movimientos.insert(0, movimiento);
    unawaited(
      registrarMovimientoRemoto(
        producto: producto,
        esEntrada: esEntrada,
        cantidad: cantidad,
        costoUnitario: costoUnitario,
        folio: folio,
        referencia: referencia,
        destino: destino,
        notas: notas,
      ).catchError((error) {
        debugPrint('No se pudo sincronizar el movimiento: $error');
      }),
    );
    return movimiento;
  }

  static void agregar(Producto producto) => productos.add(producto);
}

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});
  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  final buscarController = TextEditingController();
  String categoriaSeleccionada = 'Todos';
  bool ordenarPorPrecio = false;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    if (mounted) setState(() => cargando = true);
    try {
      await InventarioRepositorio.cargarInventario();
      if (!mounted) return;
      setState(() {
        if (!filtros.contains(categoriaSeleccionada))
          categoriaSeleccionada = 'Todos';
        cargando = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => cargando = false);
      _mensaje(e.mensaje);
    } catch (_) {
      if (!mounted) return;
      setState(() => cargando = false);
      _mensaje('No fue posible cargar el inventario.');
    }
  }

  List<String> get filtros => [
    'Todos',
    ...InventarioRepositorio.categorias.map((e) => e.nombre),
    'Bajo Stock',
  ];

  List<Producto> get productosFiltrados {
    final busqueda = buscarController.text.toLowerCase();
    final resultado = InventarioRepositorio.productos.where((producto) {
      final coincideTexto =
          producto.nombre.toLowerCase().contains(busqueda) ||
          producto.sku.toLowerCase().contains(busqueda);
      final coincideCategoria =
          categoriaSeleccionada == 'Todos' ||
          (categoriaSeleccionada == 'Bajo Stock'
              ? producto.stock <= 3
              : producto.categoria == categoriaSeleccionada);
      return coincideTexto && coincideCategoria;
    }).toList();
    resultado.sort(
      (a, b) => ordenarPorPrecio
          ? b.precio.compareTo(a.precio)
          : a.stock.compareTo(b.stock),
    );
    return resultado;
  }

  @override
  void dispose() {
    buscarController.dispose();
    super.dispose();
  }

  static Widget _campo(
    TextEditingController controlador,
    String etiqueta, {
    TextInputType? teclado,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: controlador,
      keyboardType: teclado,
      decoration: InputDecoration(
        labelText: etiqueta,
        border: const OutlineInputBorder(),
      ),
    ),
  );

  Future<void> agregarProducto() => _formularioProducto();

  Future<void> _editarProducto(Producto producto) =>
      _formularioProducto(producto: producto);

  Future<void> _formularioProducto({Producto? producto}) async {
    final esEdicion = producto != null;
    final nombre = TextEditingController(text: producto?.nombre ?? '');
    final sku = TextEditingController(text: producto?.sku ?? '');
    final detalle = TextEditingController(text: producto?.detalle ?? '');
    final precio = TextEditingController(
      text: producto?.precio.toStringAsFixed(2) ?? '',
    );
    final stock = TextEditingController(text: producto?.stock.toString() ?? '');
    Categoria? categoria;
    for (final item in InventarioRepositorio.categorias) {
      if (item.id == producto?.categoriaId) categoria = item;
    }
    categoria ??= InventarioRepositorio.categorias.isEmpty
        ? null
        : InventarioRepositorio.categorias.first;
    var guardando = false;

    await showDialog<void>(
      context: context,
      builder: (contextoDialogo) => StatefulBuilder(
        builder: (contextoDialogo, actualizarDialogo) => AlertDialog(
          title: Text(esEdicion ? 'Editar producto' : 'Nuevo producto'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _campo(nombre, 'Nombre del producto'),
                _campo(sku, 'SKU'),
                if (esEdicion) _campo(detalle, 'Descripción'),
                _campo(
                  precio,
                  'Precio',
                  teclado: const TextInputType.numberWithOptions(decimal: true),
                ),
                _campo(
                  stock,
                  esEdicion ? 'Existencias' : 'Cantidad inicial',
                  teclado: TextInputType.number,
                ),
                DropdownButtonFormField<Categoria>(
                  value: categoria,
                  isExpanded: true,
                  hint: const Text('No hay categorías registradas'),
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(),
                  ),
                  items: InventarioRepositorio.categorias
                      .map(
                        (e) =>
                            DropdownMenuItem(value: e, child: Text(e.nombre)),
                      )
                      .toList(),
                  onChanged: InventarioRepositorio.categorias.isEmpty
                      ? null
                      : (valor) => actualizarDialogo(() => categoria = valor),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: guardando
                  ? null
                  : () => Navigator.pop(contextoDialogo),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: guardando
                  ? null
                  : () async {
                      final precioIngresado = double.tryParse(precio.text);
                      final stockIngresado = int.tryParse(stock.text);
                      if (nombre.text.trim().isEmpty ||
                          sku.text.trim().isEmpty ||
                          precioIngresado == null ||
                          precioIngresado < 0 ||
                          stockIngresado == null ||
                          stockIngresado < 0 ||
                          categoria == null) {
                        _mensaje(
                          categoria == null
                              ? 'Primero registra una categoría en la API.'
                              : 'Revisa los datos ingresados.',
                        );
                        return;
                      }
                      actualizarDialogo(() => guardando = true);
                      try {
                        if (esEdicion) {
                          await InventarioRepositorio.actualizarProducto(
                            producto: producto!,
                            sku: sku.text.trim(),
                            nombre: nombre.text.trim(),
                            detalle: detalle.text.trim(),
                            precio: precioIngresado,
                            existencias: stockIngresado,
                            categoriaId: categoria!.id,
                          );
                        } else {
                          await InventarioRepositorio.crearProducto(
                            sku: sku.text.trim(),
                            nombre: nombre.text.trim(),
                            precio: precioIngresado,
                            existencias: stockIngresado,
                            categoriaId: categoria!.id,
                          );
                        }
                        await InventarioRepositorio.cargarInventario();
                        if (!mounted) return;
                        Navigator.pop(contextoDialogo);
                        setState(() {});
                        _mensaje(
                          esEdicion
                              ? 'Producto actualizado correctamente.'
                              : nombre.text.trim() + ' agregado al inventario.',
                        );
                      } on ApiException catch (e) {
                        actualizarDialogo(() => guardando = false);
                        _mensaje(e.mensaje);
                      } catch (_) {
                        actualizarDialogo(() => guardando = false);
                        _mensaje('No fue posible guardar el producto.');
                      }
                    },
              child: Text(guardando ? 'Guardando...' : 'Guardar'),
            ),
          ],
        ),
      ),
    );
    nombre.dispose();
    sku.dispose();
    detalle.dispose();
    precio.dispose();
    stock.dispose();
  }

  Future<void> _eliminarProducto(Producto producto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contextoDialogo) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text(
          '¿Deseas eliminar ' + producto.nombre + ' del inventario?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contextoDialogo, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(contextoDialogo, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await InventarioRepositorio.eliminarProducto(producto);
      await InventarioRepositorio.cargarInventario();
      if (!mounted) return;
      setState(() {});
      _mensaje('Producto eliminado correctamente.');
    } on ApiException catch (e) {
      _mensaje(e.mensaje);
    } catch (_) {
      _mensaje('No fue posible eliminar el producto.');
    }
  }

  void _detalle(Producto producto) {
    showDialog(
      context: context,
      builder: (contextoDialogo) => AlertDialog(
        title: const Text('Detalle del producto'),
        content: Text(
          producto.nombre +
              '\n\nCategoría: ' +
              producto.categoria +
              '\nSKU: ' +
              producto.sku +
              '\nPrecio: \$' +
              producto.precio.toStringAsFixed(2) +
              '\nStock actual: ' +
              producto.stock.toString(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contextoDialogo),
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(contextoDialogo);
              _editarProducto(producto);
            },
            child: const Text('Editar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(contextoDialogo);
              _eliminarProducto(producto);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(contextoDialogo);
              _irA(MovimientosScreen(productoInicial: producto.nombre));
            },
            child: const Text('Registrar movimiento'),
          ),
        ],
      ),
    );
  }

  void _mensaje(String mensaje) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensaje)));
    }
  }

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

  void _irA(Widget pantalla) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => pantalla));

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
              children: filtros
                  .map(
                    (categoria) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(categoria),
                        selected: categoriaSeleccionada == categoria,
                        selectedColor: azul,
                        labelStyle: TextStyle(
                          color: categoriaSeleccionada == categoria
                              ? Colors.white
                              : Colors.black87,
                        ),
                        onSelected: (_) =>
                            setState(() => categoriaSeleccionada = categoria),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 15, 18, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    productosFiltrados.length.toString() +
                        ' productos encontrados',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton.icon(
                  onPressed: () =>
                      setState(() => ordenarPorPrecio = !ordenarPorPrecio),
                  icon: const Icon(Icons.sort),
                  label: Text(ordenarPorPrecio ? 'Precio' : 'Stock'),
                ),
              ],
            ),
          ),
          Expanded(
            child: cargando
                ? const Center(child: CircularProgressIndicator())
                : productosFiltrados.isEmpty
                ? const Center(child: Text('No se encontraron productos'))
                : RefreshIndicator(
                    onRefresh: _cargar,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: productosFiltrados.length,
                      itemBuilder: (context, index) {
                        final producto = productosFiltrados[index];
                        final critico = producto.stock <= 3;
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
                                    IconButton(
                                      onPressed: () => _detalle(producto),
                                      icon: const Icon(Icons.info_outline),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'SKU: ' + producto.sku,
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
                                      '\$' + producto.precio.toStringAsFixed(2),
                                      style: const TextStyle(
                                        color: azul,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      'Stock: ' + producto.stock.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      critico ? 'Crítico' : 'Disponible',
                                      style: TextStyle(
                                        color: critico
                                            ? Colors.red
                                            : Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => _detalle(producto),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: azul,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Detalle'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        selectedItemColor: azul,
        unselectedItemColor: const Color(0xFF444653),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Inicio'),
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
          if (index == 0) _irA(const InicioScreen());
          if (index == 2) _irA(const MovimientosScreen());
          if (index == 3) _irA(const HistorialScreen());
        },
      ),
    );
  }
}
