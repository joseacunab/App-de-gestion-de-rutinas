import 'package:cloud_firestore/cloud_firestore.dart';

/// Área en Firestore (`areas`).
class AreaModelo {
  AreaModelo({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.icono,
    required this.colorHex,
    required this.orden,
    required this.usuarioId,
    this.creadoEn,
    this.actualizadoEn,
  });

  final String id;
  final String nombre;
  final String descripcion;
  final String icono;
  final String colorHex;
  final int orden;
  final String usuarioId;
  final Timestamp? creadoEn;
  final Timestamp? actualizadoEn;

  factory AreaModelo.fromMap(String id, Map<String, dynamic> datos) {
    return AreaModelo(
      id: id,
      nombre: datos['nombre'] as String? ?? '',
      descripcion: datos['descripcion'] as String? ?? '',
      icono: datos['icono'] as String? ?? '',
      colorHex: datos['colorHex'] as String? ?? '#3B82F6',
      orden: (datos['orden'] as num?)?.toInt() ?? 0,
      usuarioId: datos['usuarioId'] as String? ?? '',
      creadoEn: datos['creadoEn'] as Timestamp?,
      actualizadoEn: datos['actualizadoEn'] as Timestamp?,
    );
  }

  /// Mapa para persistir (timestamps los gestiona el servicio con FieldValue si aplica).
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'icono': icono,
      'colorHex': colorHex,
      'orden': orden,
      'usuarioId': usuarioId,
      if (creadoEn != null) 'creadoEn': creadoEn,
      if (actualizadoEn != null) 'actualizadoEn': actualizadoEn,
    };
  }
}
