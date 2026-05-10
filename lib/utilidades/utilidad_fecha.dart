import '../dominio/enumeracion_rango_temporal.dart';

String etiquetaRango(EnumeracionRangoTemporal r) {
  switch (r) {
    case EnumeracionRangoTemporal.dia:
      return 'Día';
    case EnumeracionRangoTemporal.semana:
      return 'Semana';
    case EnumeracionRangoTemporal.mes:
      return 'Mes';
  }
}

(DateTime inicio, DateTime fin) rangoParaReferencia(
  DateTime referencia,
  EnumeracionRangoTemporal modo,
) {
  switch (modo) {
    case EnumeracionRangoTemporal.dia:
      final d = DateTime(referencia.year, referencia.month, referencia.day);
      return (d, d);
    case EnumeracionRangoTemporal.semana:
      final d = DateTime(referencia.year, referencia.month, referencia.day);
      final diff = d.weekday - DateTime.monday;
      final inicio = d.subtract(Duration(days: diff));
      final fin = inicio.add(const Duration(days: 6));
      return (inicio, fin);
    case EnumeracionRangoTemporal.mes:
      final inicio = DateTime(referencia.year, referencia.month, 1);
      final fin = DateTime(referencia.year, referencia.month + 1, 0);
      return (inicio, fin);
  }
}

DateTime desplazarReferencia(
  DateTime referencia,
  EnumeracionRangoTemporal modo,
  int pasos,
) {
  switch (modo) {
    case EnumeracionRangoTemporal.dia:
      return referencia.add(Duration(days: pasos));
    case EnumeracionRangoTemporal.semana:
      return referencia.add(Duration(days: 7 * pasos));
    case EnumeracionRangoTemporal.mes:
      return DateTime(referencia.year, referencia.month + pasos, referencia.day);
  }
}
