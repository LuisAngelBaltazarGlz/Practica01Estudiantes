import 'package:flutter_test/flutter_test.dart';
import 'package:nexasoft_incidencias/model/incidencia.dart';

void main() {
  test('Una incidencia antigua puede convertirse desde JSON', () {
    final registro = Incidencia.desdeJson({
      'id': 'INC-DEMO',
      'titulo': 'Prueba',
      'descripcion': 'Caso de ejemplo',
      'cliente': 'Cliente ficticio',
      'categoria': 'Redes',
      'estado': 'Pendiente',
      'fecha': '2026-10-12',
    });
    expect(registro.id, 'INC-DEMO');
    expect(registro.toJson()['estado'], 'Pendiente');
    expect(registro.prioridad, 'Media');
  });

  test('Una prioridad fuera de Baja, Media o Alta se toma como Media', () {
    final registro = Incidencia.desdeJson({'id': 'INC-X', 'prioridad': 'Urgente'});
    expect(registro.prioridad, 'Media');
    expect(Incidencia.desdeJson({'id': 'INC-Y', 'prioridad': 'Alta'}).prioridad, 'Alta');
  });
}
