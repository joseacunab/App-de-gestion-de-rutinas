import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import '../dominio/enumeracion_rango_temporal.dart';
import '../utilidades/utilidad_fecha.dart';

/// Período global (día / semana / mes) compartido por las pantallas que filtran por fecha.
///
/// Por defecto la referencia es siempre el **presente** ([DateTime.now]): solo el día/semana/mes
/// en curso. El usuario puede abrir **historial** con las flechas; al volver al período que contiene
/// hoy, se desactiva de nuevo el modo historial.
class ControladorSeleccionTemporal extends ChangeNotifier {
  ControladorSeleccionTemporal() {
    final n = DateTime.now();
    _ultimoDiaCalendarioObservado = DateTime(n.year, n.month, n.day);
    _referenciaHistorica = n;
  }

  EnumeracionRangoTemporal _modo = EnumeracionRangoTemporal.dia;
  late DateTime _referenciaHistorica;
  bool _viendoHistorialManual = false;
  bool _suprimirDatosVisuales = false;
  int _tokenSincro = 0;
  late DateTime _ultimoDiaCalendarioObservado;

  EnumeracionRangoTemporal get modo => _modo;

  /// Fecha de anclaje para el selector y el filtrado: “ahora” salvo que el usuario navegue el historial.
  DateTime get referencia =>
      _viendoHistorialManual ? _referenciaHistorica : DateTime.now();

  bool get viendoHistorialManual => _viendoHistorialManual;

  /// Tras cambiar el período, un frame sin datos para no mostrar valores del rango anterior.
  bool get suprimirDatosVisuales => _suprimirDatosVisuales;

  void establecerModo(EnumeracionRangoTemporal m) {
    if (_modo == m) return;
    _modo = m;
    _viendoHistorialManual = false;
    _programarLiberacionVisual();
  }

  void desplazar(int pasos) {
    if (pasos == 0) return;
    final base = _viendoHistorialManual ? _referenciaHistorica : DateTime.now();
    _referenciaHistorica = desplazarReferencia(base, _modo, pasos);
    _viendoHistorialManual = !_periodoIncluyeHoy(_referenciaHistorica);
    _programarLiberacionVisual();
  }

  /// Al cerrar sesión vuelve al presente (día en curso, modo día).
  void reiniciar() {
    _modo = EnumeracionRangoTemporal.dia;
    _viendoHistorialManual = false;
    _suprimirDatosVisuales = false;
    _tokenSincro++;
    final n = DateTime.now();
    _referenciaHistorica = n;
    _ultimoDiaCalendarioObservado = DateTime(n.year, n.month, n.day);
    notifyListeners();
  }

  /// Si cambia el día civil del dispositivo, refresca vistas ancladas al “hoy”.
  /// Si el usuario estaba en historial y el período deja de ser válido respecto al calendario, vuelve al presente.
  void comprobarAvanceCalendario() {
    final now = DateTime.now();
    final hoy = DateTime(now.year, now.month, now.day);
    if (hoy == _ultimoDiaCalendarioObservado) return;

    if (!_viendoHistorialManual) {
      _ultimoDiaCalendarioObservado = hoy;
      notifyListeners();
      return;
    }

    final ref = referencia;
    final (ini, fin) = rangoParaReferencia(ref, _modo);
    final ayer = _ultimoDiaCalendarioObservado;
    final estabaEnPeriodo = diaCalendarioEnRango(ayer, ini, fin);
    final sigueEnPeriodo = diaCalendarioEnRango(hoy, ini, fin);
    if (estabaEnPeriodo && !sigueEnPeriodo) {
      _referenciaHistorica = now;
      _viendoHistorialManual = false;
      _programarLiberacionVisual();
    }
    _ultimoDiaCalendarioObservado = hoy;
  }

  bool _periodoIncluyeHoy(DateTime ref) {
    final (ini, fin) = rangoParaReferencia(ref, _modo);
    final hoy = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return diaCalendarioEnRango(hoy, ini, fin);
  }

  void _programarLiberacionVisual() {
    final t = ++_tokenSincro;
    _suprimirDatosVisuales = true;
    notifyListeners();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_tokenSincro != t) return;
      _suprimirDatosVisuales = false;
      notifyListeners();
    });
  }
}
