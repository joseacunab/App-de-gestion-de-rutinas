import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../componentes/barra_aplicacion_personalizada.dart';
import '../componentes/grafico_dona.dart';
import '../componentes/selector_fecha_global.dart';
import '../controladores/controlador_actividades.dart';
import '../controladores/controlador_areas.dart';
import '../controladores/controlador_seleccion_temporal.dart';
import '../dominio/enumeracion_rango_temporal.dart';
import '../modelos/modelo_actividad.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/decoraciones_aplicacion.dart';
import '../temas/estilos_texto_aplicacion.dart';
import '../utilidades/utilidad_consultas_actividad.dart' as consultas;
import '../utilidades/utilidad_fecha.dart';

/// Estadísticas: donut de horas y detalle por área.
class PantallaEstados extends StatelessWidget {
  const PantallaEstados({super.key});

  double _divisorPromedio(ControladorSeleccionTemporal temporal) {
    switch (temporal.modo) {
      case EnumeracionRangoTemporal.dia:
        return 1;
      case EnumeracionRangoTemporal.semana:
        return 7;
      case EnumeracionRangoTemporal.mes:
        return 30;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controladorAreas = context.watch<ControladorAreas>();
    final controladorActividades = context.watch<ControladorActividades>();
    final temporal = context.watch<ControladorSeleccionTemporal>();

    final (ini, fin) = rangoParaReferencia(temporal.referencia, temporal.modo);
    // ANTES
    /*final actividadesPeriodo = temporal.suprimirDatosVisuales
        ? <ActividadModelo>[]
        : consultas.actividadesEnRango(
            controladorActividades.actividades, ini, fin);
*/
// DESPUÉS
    final actividadesPeriodo = temporal.suprimirDatosVisuales
        ? <ActividadModelo>[]
        : consultas
            .actividadesEnRango(controladorActividades.actividades, ini, fin)
            .where((a) => a.completada)
            .toList();

    final sinDatosEnPeriodo = actividadesPeriodo.isEmpty;

    late final List<PorcionHorasArea> porciones;
    late final double totalHoras;
    late final int hechas;
    late final int pendientes;
    late final int cumplido;

    if (sinDatosEnPeriodo) {
      porciones = [];
      totalHoras = 0;
      hechas = 0;
      pendientes = 0;
      cumplido = 0;
    } else {
      final mapaHoras =
          consultas.horasPorAreaEnRango(actividadesPeriodo, ini, fin);
      totalHoras = mapaHoras.values.fold<double>(0, (a, b) => a + b);
      (hechas, pendientes, cumplido) =
          consultas.resumenEstadisticas(actividadesPeriodo, ini, fin);

      porciones = [];
      for (final a in controladorAreas.areas) {
        final h = mapaHoras[a.id] ?? 0;
        if (h <= 0) continue;
        final pct = totalHoras <= 0 ? 0 : ((h / totalHoras) * 100).round();
        porciones.add(PorcionHorasArea(area: a, horas: h, porcentaje: pct));
      }
      porciones.sort((x, y) => y.horas.compareTo(x.horas));
    }

    final mostrarBloqueDatos = !sinDatosEnPeriodo;
    final mostrarGraficos = mostrarBloqueDatos && porciones.isNotEmpty;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(
          child: BarraAplicacionPersonalizada(
            estilo: EstiloEncabezadoBarra.saludoArriba,
            titulo: 'Estados',
            subtitulo: 'Tu progreso',
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
          sliver: SliverToBoxAdapter(
            child: SelectorFechaGlobal(
              modo: temporal.modo,
              referencia: temporal.referencia,
              alCambiarModo: (m) => context
                  .read<ControladorSeleccionTemporal>()
                  .establecerModo(m),
              alAnterior: () =>
                  context.read<ControladorSeleccionTemporal>().desplazar(-1),
              alSiguiente: () =>
                  context.read<ControladorSeleccionTemporal>().desplazar(1),
            ),
          ),
        ),
        //Aca muestro un mensaje si no hay datos
        if (sinDatosEnPeriodo)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bar_chart_rounded, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'Sin actividad completada',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Completá una tarea para ver tus estadísticas',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        if (mostrarBloqueDatos)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: _TarjetaMiniEstadistica(
                      icono: Icons.check_circle_rounded,
                      colorIcono: ColoresAplicacion.exito,
                      valor: '$hechas',
                      etiqueta: 'Hechas',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _TarjetaMiniEstadistica(
                      icono: Icons.fact_check_rounded,
                      colorIcono: ColoresAplicacion.advertencia,
                      valor: '$pendientes',
                      etiqueta: 'Pendientes',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _TarjetaMiniEstadistica(
                      icono: Icons.timelapse_rounded,
                      colorIcono: ColoresAplicacion.azulPrincipal,
                      valor: '$cumplido%',
                      etiqueta: 'Cumplido',
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (mostrarGraficos) ...[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
            sliver: SliverToBoxAdapter(
              child:
                  GraficoDona(porciones: porciones, horasTotales: totalHoras),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverToBoxAdapter(
              child: ListaResumenDona(
                porciones: porciones,
                horasTotales: totalHoras,
                divisorPromedioDiario: _divisorPromedio(temporal),
              ),
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _TarjetaMiniEstadistica extends StatelessWidget {
  const _TarjetaMiniEstadistica({
    required this.icono,
    required this.colorIcono,
    required this.valor,
    required this.etiqueta,
  });

  final IconData icono;
  final Color colorIcono;
  final String valor;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: DecoracionesAplicacion.tarjetaElevada(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: colorIcono.withValues(alpha: 0.15),
            child: Icon(icono, color: colorIcono, size: 20),
          ),
          const SizedBox(height: 10),
          Text(valor,
              style:
                  EstilosTextoAplicacion.tituloPantalla.copyWith(fontSize: 22)),
          Text(etiqueta, style: EstilosTextoAplicacion.cuerpoSecundario),
        ],
      ),
    );
  }
}
