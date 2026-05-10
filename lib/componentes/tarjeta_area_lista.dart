import 'package:flutter/material.dart';
import '../modelos/modelo_area.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/decoraciones_aplicacion.dart';
import '../temas/estilos_texto_aplicacion.dart';
import '../utilidades/mapeador_iconos_area.dart';
import '../utilidades/utilidad_color.dart';
import 'barra_progreso_personalizada.dart';

class TarjetaAreaLista extends StatelessWidget {
  const TarjetaAreaLista({
    super.key,
    required this.area,
    required this.pendientes,
    required this.porcentajeProgreso,
    required this.onTap,
  });

  final AreaModelo area;
  final int pendientes;
  final int porcentajeProgreso;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorArea = colorDesdeHex(area.colorHex);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, valor, child) {
        return Opacity(
          opacity: valor,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - valor)),
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioTarjeta),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: DecoracionesAplicacion.tarjetaElevada(),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: colorArea.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(iconoDesdeClave(area.icono), color: colorArea, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(area.nombre, style: EstilosTextoAplicacion.tituloTarjeta),
                      const SizedBox(height: 4),
                      Text(
                        '$pendientes pendientes · $porcentajeProgreso%',
                        style: EstilosTextoAplicacion.cuerpoSecundario,
                      ),
                      const SizedBox(height: 10),
                      BarraProgresoPersonalizada(
                        progreso: porcentajeProgreso / 100.0,
                        color: porcentajeProgreso > 0
                            ? ColoresAplicacion.azulPrincipal
                            : ColoresAplicacion.grisClaro,
                        altura: 6,
                        radio: 6,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: ColoresAplicacion.grisMedio),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
