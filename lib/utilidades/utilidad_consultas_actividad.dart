import '../modelos/modelo_actividad.dart';

/// Consultas puras sobre listas de actividades (sin estado).

bool actividadEnDia(ActividadModelo actividad, DateTime dia) {
  final m = actividad.momentoAgendado;
  return m.year == dia.year && m.month == dia.month && m.day == dia.day;
}

List<ActividadModelo> actividadesDelDia(List<ActividadModelo> todas, DateTime dia) {
  final d = DateTime(dia.year, dia.month, dia.day);
  final lista = todas.where((t) => actividadEnDia(t, d)).toList()
    ..sort((a, b) => a.momentoAgendado.compareTo(b.momentoAgendado));
  return lista;
}

List<ActividadModelo> actividadesEnRango(
  List<ActividadModelo> todas,
  DateTime inicio,
  DateTime fin,
) {
  final i = DateTime(inicio.year, inicio.month, inicio.day);
  final f = DateTime(fin.year, fin.month, fin.day, 23, 59, 59);
  final lista = todas.where((t) {
    final m = t.momentoAgendado;
    return !m.isBefore(i) && !m.isAfter(f);
  }).toList()
    ..sort((a, b) => a.momentoAgendado.compareTo(b.momentoAgendado));
  return lista;
}

List<ActividadModelo> actividadesPorArea(List<ActividadModelo> todas, String areaId) {
  final lista = todas.where((t) => t.areaId == areaId).toList()
    ..sort((a, b) => a.momentoAgendado.compareTo(b.momentoAgendado));
  return lista;
}

/// Horas por id de área en el rango de fechas de los momentos agendados.
Map<String, double> horasPorAreaEnRango(
  List<ActividadModelo> todas,
  DateTime inicio,
  DateTime fin,
) {
  final mapa = <String, double>{};
  for (final t in actividadesEnRango(todas, inicio, fin)) {
    final h = t.duracionMinutos / 60.0;
    mapa[t.areaId] = (mapa[t.areaId] ?? 0) + h;
  }
  return mapa;
}

ActividadModelo? proximaActividadPendiente(List<ActividadModelo> todas, DateTime dia) {
  final lista =
      actividadesDelDia(todas, dia).where((t) => !t.completada).toList();
  if (lista.isEmpty) return null;
  return lista.first;
}

(int total, int hechas, int porcentaje) resumenProgresoDia(List<ActividadModelo> todas, DateTime dia) {
  final lista = actividadesDelDia(todas, dia);
  final total = lista.length;
  final hechas = lista.where((t) => t.completada).length;
  final pct = total == 0 ? 0 : ((hechas / total) * 100).round();
  return (total, hechas, pct);
}

(int pendientes, int porcentaje) resumenArea(
  List<ActividadModelo> todas,
  String idArea,
) {
  final lista = todas.where((t) => t.areaId == idArea).toList();
  if (lista.isEmpty) return (0, 0);
  final hechas = lista.where((t) => t.completada).length;
  final pendientes = lista.length - hechas;
  final pct = ((hechas / lista.length) * 100).round();
  return (pendientes, pct);
}

(int hechas, int pendientes, int cumplidoPct) resumenEstadisticas(
  List<ActividadModelo> todas,
  DateTime inicio,
  DateTime fin,
) {
  final lista = actividadesEnRango(todas, inicio, fin);
  final hechas = lista.where((t) => t.completada).length;
  final pendientes = lista.where((t) => !t.completada).length;
  final total = lista.length;
  final pct = total == 0 ? 0 : ((hechas / total) * 100).round();
  return (hechas, pendientes, pct);
}
