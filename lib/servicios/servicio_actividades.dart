import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/modelo_actividad.dart';

/// Colección `actividades`. Índice: `usuarioId` + `fecha` (desc).
class ServicioActividades {
  ServicioActividades({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  Stream<List<ActividadModelo>> obtenerActividades(String usuarioId) {
    return _db
        .collection('actividades')
        .where('usuarioId', isEqualTo: usuarioId)
        .orderBy('fecha', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => ActividadModelo.fromMap(d.id, d.data())).toList());
  }

  Future<String> crearActividad(ActividadModelo actividad) async {
    final datos = <String, dynamic>{
      'titulo': actividad.titulo,
      'descripcion': actividad.descripcion,
      'areaId': actividad.areaId,
      'usuarioId': actividad.usuarioId,
      'prioridad': actividad.prioridad,
      'duracionMinutos': actividad.duracionMinutos,
      'completada': actividad.completada,
      'fecha': actividad.fecha,
      'hora': actividad.hora,
      'fechaCompletada': actividad.fechaCompletada,
      'creadoEn': FieldValue.serverTimestamp(),
      'actualizadoEn': FieldValue.serverTimestamp(),
    };
    final ref = await _db.collection('actividades').add(datos);
    return ref.id;
  }

  Future<void> actualizarActividad(ActividadModelo actividad) async {
    await _db.collection('actividades').doc(actividad.id).update({
      'titulo': actividad.titulo,
      'descripcion': actividad.descripcion,
      'areaId': actividad.areaId,
      'usuarioId': actividad.usuarioId,
      'prioridad': actividad.prioridad,
      'duracionMinutos': actividad.duracionMinutos,
      'completada': actividad.completada,
      'fecha': actividad.fecha,
      'hora': actividad.hora,
      'fechaCompletada': actividad.fechaCompletada,
      'actualizadoEn': FieldValue.serverTimestamp(),
    });
  }

  Future<void> alternarCompletada(String id, bool completada) async {
    await _db.collection('actividades').doc(id).update({
      'completada': completada,
      'fechaCompletada': completada ? FieldValue.serverTimestamp() : null,
      'actualizadoEn': FieldValue.serverTimestamp(),
    });
  }

  Future<void> eliminarActividad(String id) async {
    await _db.collection('actividades').doc(id).delete();
  }
}
