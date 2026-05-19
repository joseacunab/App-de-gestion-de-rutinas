import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../modelos/modelo_area.dart';
import '../utilidades/utilidad_color.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/decoraciones_aplicacion.dart';
import '../temas/estilos_texto_aplicacion.dart';
import '../utilidades/mapeador_iconos_area.dart';

/// Datos para una porción del gráfico (horas por área).
class PorcionHorasArea {
  PorcionHorasArea({
    required this.area,
    required this.horas,
    required this.porcentaje,
  });

  final AreaModelo area;
  final double horas;
  final int porcentaje;
}

class GraficoDona extends StatefulWidget {
  const GraficoDona({
    super.key,
    required this.porciones,
    required this.horasTotales,
  });

  final List<PorcionHorasArea> porciones;
  final double horasTotales;

  @override
  State<GraficoDona> createState() => _GraficoDonaState();
}

class _GraficoDonaState extends State<GraficoDona> with SingleTickerProviderStateMixin {
  late AnimationController _animacion;

  @override
  void initState() {
    super.initState();
    _animacion = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();
  }

  @override
  void dispose() {
    _animacion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final secciones = widget.porciones;
    final totalHoras = widget.horasTotales;

    if (secciones.isEmpty) {
      return Container(
        height: 220,
        alignment: Alignment.center,
        decoration: DecoracionesAplicacion.tarjetaElevada(context),
        child: Text(
          'Sin datos en este periodo',
          style: EstilosTextoAplicacion.cuerpoSecundario(context),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: DecoracionesAplicacion.tarjetaElevada(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Horas por área', style: EstilosTextoAplicacion.tituloTarjeta(context)),
          const SizedBox(height: 4),
          Text(
            'Distribución de tiempo invertido',
            style: EstilosTextoAplicacion.cuerpoSecundario(context),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 220,
            child: AnimatedBuilder(
              animation: _animacion,
              builder: (context, child) {
                final factor = Curves.easeOutCubic.transform(_animacion.value);
                final valores = secciones
                    .map((p) => (p.horas <= 0 ? 0.0001 : p.horas) * factor)
                    .toList();
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        startDegreeOffset: -90,
                        sectionsSpace: 2,
                        centerSpaceRadius: 70,
                        borderData: FlBorderData(show: false),
                        sections: List.generate(secciones.length, (i) {
                          final p = secciones[i];
                          return PieChartSectionData(
                            color: colorDesdeHex(p.area.colorHex),
                            value: valores[i],
                            title: '',
                            radius: 46,
                          );
                        }),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${totalHoras.toStringAsFixed(1)}h',
                          style: EstilosTextoAplicacion.tituloPantalla(context).copyWith(fontSize: 28),
                        ),
                        Text('TOTAL', style: EstilosTextoAplicacion.etiquetaSeccion(context)),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          ...secciones.map((p) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: colorDesdeHex(p.area.colorHex), shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  Icon(iconoDesdeClave(p.area.icono), size: 18, color: colorDesdeHex(p.area.colorHex)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(p.area.nombre, style: EstilosTextoAplicacion.cuerpo(context))),
                  Text(
                    '${p.porcentaje}%',
                    style: EstilosTextoAplicacion.cuerpo(context).copyWith(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Lista resumida bajo el gráfico (pantalla Estados).
class ListaResumenDona extends StatelessWidget {
  const ListaResumenDona({
    super.key,
    required this.porciones,
    required this.horasTotales,
    required this.divisorPromedioDiario,
  });

  final List<PorcionHorasArea> porciones;
  final double horasTotales;
  final double divisorPromedioDiario;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: DecoracionesAplicacion.tarjetaElevada(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detalle por área', style: EstilosTextoAplicacion.tituloTarjeta(context)),
          const SizedBox(height: 14),
          ...porciones.map((p) {
            final prom = divisorPromedioDiario > 0 ? p.horas / divisorPromedioDiario : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: colorDesdeHex(p.area.colorHex).withValues(alpha: 0.15),
                        child: Icon(iconoDesdeClave(p.area.icono), color: colorDesdeHex(p.area.colorHex), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.area.nombre, style: EstilosTextoAplicacion.tituloTarjeta(context)),
                            Text(
                              '${p.horas.toStringAsFixed(1)} h · prom ${prom.toStringAsFixed(1)} h/día',
                              style: EstilosTextoAplicacion.cuerpoSecundario(context),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${p.porcentaje}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: ColoresAplicacion.azulPrincipal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (p.porcentaje / 100.0).clamp(0.0, 1.0),
                      minHeight: 8,
                      color: p.porcentaje > 0
                          ? ColoresAplicacion.azulPrincipal
                          : context.superficieContenedor,
                      backgroundColor: context.superficieContenedor,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
