import 'package:flutter/material.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/decoraciones_aplicacion.dart';

class BotonSecundario extends StatelessWidget {
  const BotonSecundario({
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
    final boton = Material(
      color: ColoresAplicacion.grisClaro,
      borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioBoton),
      child: InkWell(
        borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioBoton),
        onTap: onPresionado,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          child: Center(
            child: Text(
              etiqueta,
              style: const TextStyle(
                color: ColoresAplicacion.grisOscuro,
                fontWeight: FontWeight.w700,
                fontSize: 15,
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
