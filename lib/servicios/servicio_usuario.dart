import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/modelo_usuario.dart';

/// Solo Firestore colección `usuarios`. Sin Auth aquí.
class ServicioUsuario {
  ServicioUsuario({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  Future<UsuarioModelo?> obtenerPorId(String idUsuario) async {
    final doc = await _db.collection('usuarios').doc(idUsuario).get();
    if (!doc.exists || doc.data() == null) return null;
    return UsuarioModelo.fromMap(doc.id, doc.data()!);
  }

  Future<void> crearDocumento(String idUsuario, UsuarioModelo modelo) async {
    await _db.collection('usuarios').doc(idUsuario).set(modelo.toMap());
  }

  Future<void> actualizarCampos(String idUsuario, Map<String, dynamic> datos) async {
    await _db.collection('usuarios').doc(idUsuario).update(datos);
  }
}
