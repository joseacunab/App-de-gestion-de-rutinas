import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../modelos/modelo_usuario.dart';
import '../servicios/servicio_usuario.dart';

/// Estado de sesión y perfil. Auth aquí; Firestore vía [ServicioUsuario].
class ControladorUsuario extends ChangeNotifier {
  ControladorUsuario({
    FirebaseAuth? auth,
    ServicioUsuario? servicioUsuario,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _servicioUsuario = servicioUsuario ?? ServicioUsuario();

  final FirebaseAuth _auth;
  final ServicioUsuario _servicioUsuario;

  User? usuarioAuth;
  UsuarioModelo? usuario;

  bool cargando = false;
  String? error;

  /// Preferencias solo locales (no campo en Firestore todavía).
  bool modoOscuro = false;

  Future<bool> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    try {
      cargando = true;
      error = null;
      notifyListeners();

      final credencial = await _auth.signInWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );
      usuarioAuth = credencial.user;

      if (usuarioAuth != null) {
        usuario = await _servicioUsuario.obtenerPorId(usuarioAuth!.uid);
      }

      cargando = false;
      notifyListeners();
      return true;
    } catch (e) {
      cargando = false;
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<String?> registrarUsuario({
    required String nombre,
    required String apellido,
    required String correo,
    required String contrasena,
  }) async {
    try {
      cargando = true;
      error = null;
      notifyListeners();

      final credencial = await _auth.createUserWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );
      final uid = credencial.user!.uid;

      final modelo = UsuarioModelo(
        id: uid,
        nombre: nombre,
        apellido: apellido,
        correo: correo,
        notificaciones: true,
      );
      await _servicioUsuario.crearDocumento(uid, modelo);
      await _auth.signOut();

      cargando = false;
      notifyListeners();
      return null;
    } catch (e) {
      cargando = false;
      error = e.toString();
      notifyListeners();
      return e.toString();
    }
  }

  Future<void> establecerNotificaciones(bool valor) async {
    if (usuarioAuth == null) return;
    await _servicioUsuario.actualizarCampos(usuarioAuth!.uid, {
      'notificaciones': valor,
    });
    usuario = usuario?.copiarCon(notificaciones: valor);
    notifyListeners();
  }

  void establecerModoOscuro(bool valor) {
    modoOscuro = valor;
    notifyListeners();
  }

  Future<void> cerrarSesion() async {
    await _auth.signOut();
    usuarioAuth = null;
    usuario = null;
    notifyListeners();
  }
}
