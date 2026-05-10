import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../modelos/modelo_actividad.dart';
import '../modelos/modelo_area.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/decoraciones_aplicacion.dart';
import '../temas/estilos_texto_aplicacion.dart';
import '../utilidades/utilidad_color.dart';
import '../utilidades/utilidad_prioridad.dart';

class TarjetaProximaActividad extends StatelessWidget {
  const TarjetaProximaActividad({
    super.key,
    required this.actividad,
    required this.area,
  });

  final ActividadModelo actividad;
  final AreaModelo area;

  @override
  Widget build(BuildContext context) {
    final hora = DateFormat.Hm().format(actividad.momentoAgendado);
    final dia = actividad.momentoAgendado.day;
    final colorArea = colorDesdeHex(area.colorHex);
    final colorBorde = colorArea.withValues(alpha: 0.45);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      tween: Tween(begin: 0.96, end: 1),
      builder: (context, escala, child) {
        return Transform.scale(scale: escala, child: child);
      },
      child: Container(
        decoration: DecoracionesAplicacion.tarjetaPlana().copyWith(
          border: Border.all(color: colorBorde, width: 1.2),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorArea,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$dia',
                style: const TextStyle(
                  color: ColoresAplicacion.blanco,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(actividad.titulo, style: EstilosTextoAplicacion.tituloTarjeta),
                  const SizedBox(height: 4),
                  Text(
                    '${area.nombre} · $hora hs',
                    style: EstilosTextoAplicacion.cuerpoSecundario,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Prioridad: ${etiquetaPrioridadCadena(actividad.prioridad)}',
                    style: EstilosTextoAplicacion.cuerpoSecundario.copyWith(
                      color: colorPrioridadCadena(actividad.prioridad),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
