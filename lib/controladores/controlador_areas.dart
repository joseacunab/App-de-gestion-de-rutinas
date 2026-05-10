import 'dart:async';

import 'package:flutter/material.dart';
import '../modelos/modelo_actividad.dart';
import '../modelos/modelo_area.dart';
import '../servicios/servicio_areas.dart';
import '../utilidades/utilidad_consultas_actividad.dart' as consultas;

/// Lista reactiva de áreas del usuario actual.
class ControladorAreas extends ChangeNotifier {
  ControladorAreas({ServicioAreas? servicio})
      : _servicio = servicio ?? ServicioAreas();

  final ServicioAreas _servicio;
  StreamSubscription<List<AreaModelo>>? _suscripcion;

  List<AreaModelo> areas = [];

  void vincularUsuario(String usuarioId) {
    _suscripcion?.cancel();
    _suscripcion = _servicio.obtenerAreas(usuarioId).listen((lista) {
      areas = lista;
      notifyListeners();
    });
  }

  void desvincularUsuario() {
    _suscripcion?.cancel();
    _suscripcion = null;
    areas = [];
    notifyListeners();
  }

  AreaModelo? areaPorId(String id) {
    try {
      return areas.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
/*
  Stream<List<AreaModelo>>? streamAreas;

  void escucharAreas(String usuarioId) {
    streamAreas = _servicio.obtenerAreas(usuarioId);

    streamAreas!.listen((data) {
      areas = data;
      notifyListeners();
    });
  }*/

  (int pendientes, int porcentaje) resumenArea(
    String idArea,
    List<ActividadModelo> actividades,
  ) {
    return consultas.resumenArea(actividades, idArea);
  }

  Future<void> crearArea(AreaModelo areaBase, String usuarioId) async {
    final orden = areas.isEmpty
        ? 0
        : areas.map((a) => a.orden).reduce((a, b) => a > b ? a : b) + 1;
    final nueva = AreaModelo(
      id: '',
      nombre: areaBase.nombre,
      descripcion: areaBase.descripcion,
      icono: areaBase.icono,
      colorHex: areaBase.colorHex,
      orden: orden,
      usuarioId: usuarioId,
      creadoEn: null,
      actualizadoEn: null,
    );
    await _servicio.crearArea(nueva);
  }

  Future<void> actualizarArea(AreaModelo area) async {
    await _servicio.actualizarArea(area);
  }

  Future<void> eliminarArea(String idArea) async {
    await _servicio.eliminarAreaYActividades(idArea);
  }

  @override
  void dispose() {
    _suscripcion?.cancel();
    super.dispose();
  }
}
