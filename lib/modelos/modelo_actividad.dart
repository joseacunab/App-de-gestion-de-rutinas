import 'package:cloud_firestore/cloud_firestore.dart';

/// Actividad en Firestore (`actividades`).
/// `fecha` y `hora` son timestamps; `hora` guarda el momento completo agendado.
class ActividadModelo {
  ActividadModelo({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.areaId,
    required this.usuarioId,
    required this.prioridad,
    required this.duracionMinutos,
    required this.completada,
    required this.fecha,
    required this.hora,
    this.fechaCompletada,
    this.creadoEn,
    this.actualizadoEn,
  });

  final String id;
  final String titulo;
  final String descripcion;
  final String areaId;
  final String usuarioId;
  /// Valores: `alta`, `media`, `baja`.
  final String prioridad;
  final double duracionMinutos;
  final bool completada;
  final Timestamp fecha;
  final Timestamp hora;
  final Timestamp? fechaCompletada;
  final Timestamp? creadoEn;
  final Timestamp? actualizadoEn;

  factory ActividadModelo.fromMap(String id, Map<String, dynamic> datos) {
    final ahora = Timestamp.now();
    final fechaTs = datos['fecha'] as Timestamp? ?? ahora;
    final horaTs = datos['hora'] as Timestamp? ?? fechaTs;

    return ActividadModelo(
      id: id,
      titulo: datos['titulo'] as String? ?? '',
      descripcion: datos['descripcion'] as String? ?? '',
      areaId: datos['areaId'] as String? ?? '',
      usuarioId: datos['usuarioId'] as String? ?? '',
      prioridad: datos['prioridad'] as String? ?? 'media',
      duracionMinutos: (datos['duracionMinutos'] as num?)?.toDouble() ?? 0,
      completada: datos['completada'] as bool? ?? false,
      fecha: fechaTs,
      hora: horaTs,
      fechaCompletada: datos['fechaCompletada'] as Timestamp?,
      creadoEn: datos['creadoEn'] as Timestamp?,
      actualizadoEn: datos['actualizadoEn'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'areaId': areaId,
      'usuarioId': usuarioId,
      'prioridad': prioridad,
      'duracionMinutos': duracionMinutos,
      'completada': completada,
      'fecha': fecha,
      'hora': hora,
      'fechaCompletada': fechaCompletada,
      if (creadoEn != null) 'creadoEn': creadoEn,
      if (actualizadoEn != null) 'actualizadoEn': actualizadoEn,
    };
  }

  /// Momento único de la actividad (usa `hora`).
  DateTime get momentoAgendado => hora.toDate();
}
