import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/modelo_area.dart';

/// Colección `areas`. Requiere índice compuesto: `usuarioId` + `orden`.
class ServicioAreas {
  ServicioAreas({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  Stream<List<AreaModelo>> obtenerAreas(String usuarioId) {
    return _db
        .collection('areas')
        .where('usuarioId', isEqualTo: usuarioId)
        .orderBy('orden')
        .snapshots()
        .map((snap) => snap.docs.map((d) => AreaModelo.fromMap(d.id, d.data())).toList());
  }

  Future<String> crearArea(AreaModelo area) async {
    final datos = <String, dynamic>{
      'nombre': area.nombre,
      'descripcion': area.descripcion,
      'icono': area.icono,
      'colorHex': area.colorHex,
      'orden': area.orden,
      'usuarioId': area.usuarioId,
      'creadoEn': FieldValue.serverTimestamp(),
      'actualizadoEn': FieldValue.serverTimestamp(),
    };
    final ref = await _db.collection('areas').add(datos);
    return ref.id;
  }

  Future<void> actualizarArea(AreaModelo area) async {
    await _db.collection('areas').doc(area.id).update({
      'nombre': area.nombre,
      'descripcion': area.descripcion,
      'icono': area.icono,
      'colorHex': area.colorHex,
      'orden': area.orden,
      'usuarioId': area.usuarioId,
      'actualizadoEn': FieldValue.serverTimestamp(),
    });
  }

  /// Elimina actividades del área y luego el documento del área.
  Future<void> eliminarAreaYActividades(String idArea) async {
    final batch = _db.batch();
    final acts = await _db.collection('actividades').where('areaId', isEqualTo: idArea).get();
    for (final doc in acts.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_db.collection('areas').doc(idArea));
    await batch.commit();
  }
}
