/// Perfil en Firestore (`usuarios/{id}`).
class UsuarioModelo {
  UsuarioModelo({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.notificaciones,
  });

  final String? id;
  final String nombre;
  final String apellido;
  final String correo;
  final bool notificaciones;

  factory UsuarioModelo.fromMap(String idDocumento, Map<String, dynamic> datos) {
    return UsuarioModelo(
      id: idDocumento,
      nombre: datos['nombre'] as String? ?? '',
      apellido: datos['apellido'] as String? ?? '',
      correo: datos['correo'] as String? ?? '',
      notificaciones: datos['notificaciones'] as bool? ?? false,
    );
  }

  /// Para crear documento: sin campo `id` en el mapa (el id es el del Auth).
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'notificaciones': notificaciones,
    };
  }

  UsuarioModelo copiarCon({
    String? nombre,
    String? apellido,
    String? correo,
    bool? notificaciones,
  }) {
    return UsuarioModelo(
      id: id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      correo: correo ?? this.correo,
      notificaciones: notificaciones ?? this.notificaciones,
    );
  }
}
