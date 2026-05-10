import 'package:flutter/material.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/decoraciones_aplicacion.dart';

class BotonPrimario extends StatelessWidget {
  const BotonPrimario({
    super.key,
    required this.etiqueta,
    this.alExpandirse = false,
    this.onPresionado,
  });

  final String etiqueta;
  final bool alExpandirse;
  final VoidCallback? onPresionado;

  @override
  Widget build(BuildContext context) {
    final boton = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioBoton),
        color: ColoresAplicacion.azulPrincipal,
        boxShadow: DecoracionesAplicacion.sombraBotonPrimario(),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioBoton),
          onTap: onPresionado,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            child: Center(
              child: Text(
                etiqueta,
                style: const TextStyle(
                  color: ColoresAplicacion.blanco,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    if (alExpandirse) {
      return SizedBox(width: double.infinity, child: boton);
    }
    return boton;
  }
}
