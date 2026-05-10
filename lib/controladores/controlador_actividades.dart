import 'dart:async';

import 'package:flutter/material.dart';
import '../modelos/modelo_actividad.dart';
import '../servicios/servicio_actividades.dart';

/// Lista reactiva de actividades del usuario actual.
class ControladorActividades extends ChangeNotifier {
  ControladorActividades({ServicioActividades? servicio})
      : _servicio = servicio ?? ServicioActividades();

  final ServicioActividades _servicio;
  StreamSubscription<List<ActividadModelo>>? _suscripcion;

  List<ActividadModelo> actividades = [];

  void vincularUsuario(String usuarioId) {
    _suscripcion?.cancel();
    _suscripcion = _servicio.obtenerActividades(usuarioId).listen((lista) {
      actividades = lista;
      notifyListeners();
    });
  }

  void desvincularUsuario() {
    _suscripcion?.cancel();
    _suscripcion = null;
    actividades = [];
    notifyListeners();
  }

  Future<void> crearActividad(ActividadModelo modelo) async {
    await _servicio.crearActividad(modelo);
  }

  Future<void> actualizarActividad(ActividadModelo modelo) async {
    await _servicio.actualizarActividad(modelo);
  }

  Future<void> alternarCompletada(String idActividad, bool completada) async {
    await _servicio.alternarCompletada(idActividad, completada);
  }

  Future<void> eliminarActividad(String id) async {
    await _servicio.eliminarActividad(id);
  }

  @override
  void dispose() {
    _suscripcion?.cancel();
    super.dispose();
  }
}
