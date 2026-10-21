import '../data/almacen_local.dart';
import '../model/incidencia.dart';

class GestorIncidencias {
  final AlmacenLocal datos = AlmacenLocal();
  List<Incidencia> incidencias = [];

  Future<void> iniciar() async {
    incidencias = await datos.leer();
  }

  List<Incidencia> buscar(String texto) {
    final consulta = texto.trim().toLowerCase();
    if (consulta.isEmpty) return incidencias;
    return incidencias
        .where((x) =>
            x.titulo.toLowerCase().contains(consulta) ||
            x.descripcion.toLowerCase().contains(consulta))
        .toList();
  }

  static const estados = ['Pendiente', 'En proceso', 'Resuelta'];
  static const todosLosEstados = 'Todos';
  static const todasLasPrioridades = 'Todas';

  // Aplica a la vez el texto, el estado y la prioridad. 'Todos' / 'Todas'
  // significan que ese filtro no está activo.
  List<Incidencia> filtrar(String texto, String estado, String prioridad) {
    return buscar(texto)
        .where((x) => estado == todosLosEstados || x.estado == estado)
        .where((x) => prioridad == todasLasPrioridades || x.prioridad == prioridad)
        .toList();
  }

  Incidencia? porId(String id) {
    for (var x in incidencias) {
      if (x.id == id) return x;
    }
    return null;
  }

  int contar(String estado) {
    return incidencias.where((x) => x.estado == estado).length;
  }

  Future<void> cambiarEstado(String id, String estado) async {
    for (var i = 0; i < incidencias.length; i++) {
      if (incidencias[i].id == id) {
        incidencias[i].estado = estado;
        break;
      }
    }
    await datos.guardar(incidencias);
  }

  Future<void> cambiarPrioridad(String id, String prioridad) async {
    if (!Incidencia.prioridades.contains(prioridad)) {
      throw ArgumentError('Prioridad no válida: $prioridad');
    }
    for (var i = 0; i < incidencias.length; i++) {
      if (incidencias[i].id == id) {
        incidencias[i].prioridad = prioridad;
        break;
      }
    }
    await datos.guardar(incidencias);
  }

  Future<void> crear(String titulo, String descripcion, String cliente,
      String categoria, String prioridad) async {
    final nuevo = Incidencia(
      id: 'INC-${DateTime.now().microsecondsSinceEpoch}',
      titulo: titulo,
      descripcion: descripcion,
      cliente: cliente,
      categoria: categoria,
      estado: 'Pendiente',
      fecha: DateTime.now().toIso8601String().split('T').first,
      prioridad: Incidencia.prioridadValida(prioridad),
    );
    incidencias.insert(0, nuevo);
    await datos.guardar(incidencias);
  }

  Future<void> reiniciarDemo() async {
    await datos.restaurarDatosDeEjemplo();
    await iniciar();
  }
}
