import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../dominio/enumeracion_rango_temporal.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/decoraciones_aplicacion.dart';
import '../temas/estilos_texto_aplicacion.dart';
import '../utilidades/utilidad_fecha.dart';

class SelectorFechaGlobal extends StatelessWidget {
  const SelectorFechaGlobal({
    super.key,
    required this.modo,
    required this.referencia,
    required this.alCambiarModo,
    required this.alAnterior,
    required this.alSiguiente,
  });

  final EnumeracionRangoTemporal modo;
  final DateTime referencia;
  final ValueChanged<EnumeracionRangoTemporal> alCambiarModo;
  final VoidCallback alAnterior;
  final VoidCallback alSiguiente;

  String _etiquetaCentral() {
    final hoy = DateTime.now();
    switch (modo) {
      case EnumeracionRangoTemporal.dia:
        final esHoy = referencia.year == hoy.year &&
            referencia.month == hoy.month &&
            referencia.day == hoy.day;
        if (esHoy) return 'Hoy';
        return DateFormat('dd/MM/yyyy').format(referencia);

      case EnumeracionRangoTemporal.semana:
        final (ini, fin) = rangoParaReferencia(hoy, modo);
        final esSemanaActual = diaCalendarioEnRango(referencia, ini, fin);
        if (esSemanaActual) return 'Esta semana';
        return DateFormat('dd/MM/yyyy').format(referencia);

      case EnumeracionRangoTemporal.mes:
        final esMesActual =
            referencia.year == hoy.year && referencia.month == hoy.month;
        if (esMesActual) return 'Este mes';
        return DateFormat('MMMM yyyy', 'es').format(referencia);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: context.superficieSutil,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            children: EnumeracionRangoTemporal.values.map((r) {
              final activo = r == modo;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    color:
                        activo ? context.superficie : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: activo
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: TextButton(
                    onPressed: () => alCambiarModo(r),
                    style: TextButton.styleFrom(
                      foregroundColor: activo
                          ? ColoresAplicacion.azulPrincipal
                          : ColoresAplicacion.grisMedio,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      etiquetaRango(r),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: activo
                            ? ColoresAplicacion.azulPrincipal
                            : ColoresAplicacion.grisMedio,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: DecoracionesAplicacion.tarjetaElevada(context),
          child: Row(
            children: [
              IconButton(
                onPressed: alAnterior,
                icon: const Icon(Icons.chevron_left_rounded),
                color: Theme.of(context).colorScheme.onSurface,
              ),
              Expanded(
                child: Text(
                  _etiquetaCentral(),
                  textAlign: TextAlign.center,
                  style: EstilosTextoAplicacion.tituloTarjeta(context)
                      .copyWith(fontSize: 15),
                ),
              ),
              IconButton(
                onPressed: alSiguiente,
                icon: const Icon(Icons.chevron_right_rounded),
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
