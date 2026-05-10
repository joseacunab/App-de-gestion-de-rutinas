import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../componentes/barra_aplicacion_personalizada.dart';
import '../componentes/grafico_dona.dart';
import '../componentes/selector_fecha_global.dart';
import '../controladores/controlador_actividades.dart';
import '../controladores/controlador_areas.dart';
import '../dominio/enumeracion_rango_temporal.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/decoraciones_aplicacion.dart';
import '../temas/estilos_texto_aplicacion.dart';
import '../utilidades/utilidad_consultas_actividad.dart' as consultas;
import '../utilidades/utilidad_fecha.dart';

/// Estadísticas: donut de horas y detalle por área.
class PantallaEstados extends StatefulWidget {
  const PantallaEstados({super.key});

  @override
  State<PantallaEstados> createState() => _PantallaEstadosState();
}

class _PantallaEstadosState extends State<PantallaEstados> {
  EnumeracionRangoTemporal _modo = EnumeracionRangoTemporal.semana;
  DateTime _referencia = DateTime.now();

  double _divisorPromedio() {
    switch (_modo) {
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

    final (ini, fin) = rangoParaReferencia(_referencia, _modo);
    final mapaHoras = consultas.horasPorAreaEnRango(controladorActividades.actividades, ini, fin);
    final totalHoras = mapaHoras.values.fold<double>(0, (a, b) => a + b);
    final (hechas, pendientes, cumplido) =
        consultas.resumenEstadisticas(controladorActividades.actividades, ini, fin);

    final porciones = <PorcionHorasArea>[];
    for (final a in controladorAreas.areas) {
      final h = mapaHoras[a.id] ?? 0;
      final pct = totalHoras <= 0 ? 0 : ((h / totalHoras) * 100).round();
      porciones.add(PorcionHorasArea(area: a, horas: h, porcentaje: pct));
    }
    porciones.sort((x, y) => y.horas.compareTo(x.horas));

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
              modo: _modo,
              referencia: _referencia,
              alCambiarModo: (m) => setState(() => _modo = m),
              alAnterior: () => setState(() {
                _referencia = desplazarReferencia(_referencia, _modo, -1);
              }),
              alSiguiente: () => setState(() {
                _referencia = desplazarReferencia(_referencia, _modo, 1);
              }),
            ),
          ),
        ),
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
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
          sliver: SliverToBoxAdapter(
            child: GraficoDona(porciones: porciones, horasTotales: totalHoras),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          sliver: SliverToBoxAdapter(
            child: ListaResumenDona(
              porciones: porciones,
              horasTotales: totalHoras,
              divisorPromedioDiario: _divisorPromedio(),
            ),
          ),
        ),
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
          Text(valor, style: EstilosTextoAplicacion.tituloPantalla.copyWith(fontSize: 22)),
          Text(etiqueta, style: EstilosTextoAplicacion.cuerpoSecundario),
        ],
      ),
    );
  }
}
