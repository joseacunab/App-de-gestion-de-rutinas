import 'package:flutter/material.dart';
import '../temas/colores_aplicacion.dart';

class BarraProgresoPersonalizada extends StatelessWidget {
  const BarraProgresoPersonalizada({
    super.key,
    required this.progreso,
    this.color = ColoresAplicacion.azulPrincipal,
    this.altura = 8,
    this.radio = 8,
  });

  /// Entre 0 y 1.
  final double progreso;
  final Color color;
  final double altura;
  final double radio;

  @override
  Widget build(BuildContext context) {
    final p = progreso.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radio),
      child: Stack(
        children: [
          Container(
            height: altura,
            width: double.infinity,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          AnimatedFractionallySizedBox(
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeOutCubic,
            widthFactor: p,
            alignment: Alignment.centerLeft,
            child: Container(height: altura, color: color),
          ),
        ],
      ),
    );
  }
}
