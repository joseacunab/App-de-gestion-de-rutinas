import 'package:flutter/material.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/decoraciones_aplicacion.dart';

class TarjetaProgresoDiario extends StatelessWidget {
  const TarjetaProgresoDiario({
    super.key,
    required this.porcentaje,
    required this.textoResumen,
    required this.progreso,
  });

  final int porcentaje;
  final String textoResumen;
  final double progreso;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progreso),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, valor, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioTarjeta + 4),
            gradient: const LinearGradient(
              colors: [ColoresAplicacion.azulPrincipal, ColoresAplicacion.azulOscuro],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: ColoresAplicacion.azulPrincipal.withValues(alpha: 0.35),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                bottom: -10,
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 120,
                  color: ColoresAplicacion.blanco.withValues(alpha: 0.08),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PROGRESO DEL DÍA',
                      style: TextStyle(
                        color: ColoresAplicacion.blanco.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: porcentaje),
                      duration: const Duration(milliseconds: 650),
                      curve: Curves.easeOutCubic,
                      builder: (context, valorPct, _) {
                        return Text(
                          '$valorPct%',
                          style: const TextStyle(
                            color: ColoresAplicacion.blanco,
                            fontSize: 44,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      textoResumen,
                      style: TextStyle(
                        color: ColoresAplicacion.blanco.withValues(alpha: 0.92),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Container(
                            height: 10,
                            width: double.infinity,
                            color: ColoresAplicacion.blanco.withValues(alpha: 0.2),
                          ),
                          FractionallySizedBox(
                            widthFactor: valor,
                            child: Container(
                              height: 10,
                              color: ColoresAplicacion.blanco,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
