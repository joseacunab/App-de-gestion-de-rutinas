import 'package:flutter/material.dart';
import '../modelos/modelo_area.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/decoraciones_aplicacion.dart';
import '../utilidades/mapeador_iconos_area.dart';
import '../utilidades/utilidad_color.dart';

/// Card de totales en detalle de área (estilo mockup Gym).
class TarjetaResumenArea extends StatelessWidget {
  const TarjetaResumenArea({
    super.key,
    required this.area,
    required this.totalActividades,
    required this.completadas,
  });

  final AreaModelo area;
  final int totalActividades;
  final int completadas;

  @override
  Widget build(BuildContext context) {
    final colorArea = colorDesdeHex(area.colorHex);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioTarjeta + 2),
        color: colorArea,
        boxShadow: [
          BoxShadow(
            color: colorArea.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioTarjeta + 2),
        child: Stack(
          children: [
            Positioned(
              right: -16,
              bottom: -16,
              child: Icon(
                iconoDesdeClave(area.icono),
                size: 120,
                color: ColoresAplicacion.blanco.withValues(alpha: 0.12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL',
                    style: TextStyle(
                      color: ColoresAplicacion.blanco.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$totalActividades actividades',
                    style: const TextStyle(
                      color: ColoresAplicacion.blanco,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$completadas completadas',
                    style: TextStyle(
                      color: ColoresAplicacion.blanco.withValues(alpha: 0.92),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
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
