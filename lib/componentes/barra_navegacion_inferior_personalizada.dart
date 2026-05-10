import 'package:flutter/material.dart';
import '../temas/colores_aplicacion.dart';

class ElementoNavegacionInferior {
  const ElementoNavegacionInferior({
    required this.etiqueta,
    required this.iconoInactivo,
    required this.iconoActivo,
  });

  final String etiqueta;
  final IconData iconoInactivo;
  final IconData iconoActivo;
}

class BarraNavegacionInferiorPersonalizada extends StatelessWidget {
  const BarraNavegacionInferiorPersonalizada({
    super.key,
    required this.indiceActivo,
    required this.alSeleccionar,
    required this.elementos,
  });

  final int indiceActivo;
  final ValueChanged<int> alSeleccionar;
  final List<ElementoNavegacionInferior> elementos;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      color: ColoresAplicacion.blanco,
      child: SafeArea(
        top: false,
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: ColoresAplicacion.bordeSutil)),
          ),
          child: Row(
            children: List.generate(elementos.length, (i) {
              final e = elementos[i];
              final activo = i == indiceActivo;
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => alSeleccionar(i),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: activo ? 1 : 0),
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    builder: (context, t, child) {
                      final color = Color.lerp(ColoresAplicacion.grisMedio, ColoresAplicacion.azulPrincipal, t)!;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(activo ? e.iconoActivo : e.iconoInactivo, color: color, size: 24),
                          const SizedBox(height: 4),
                          Text(
                            e.etiqueta,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
