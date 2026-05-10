import 'package:flutter/material.dart';
import '../temas/estilos_texto_aplicacion.dart';

/// Campo con etiqueta en mayúsculas tipo “premium”.
class CampoTextoPersonalizado extends StatelessWidget {
  const CampoTextoPersonalizado({
    super.key,
    required this.etiqueta,
    this.controlador,
    this.placeholder,
    this.maxLineas = 1,
    this.teclado = TextInputType.text,
    this.autofocus = false,
    this.alCambiar,
  });

  final String etiqueta;
  final TextEditingController? controlador;
  final String? placeholder;
  final int maxLineas;
  final TextInputType teclado;
  final bool autofocus;
  final ValueChanged<String>? alCambiar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta.toUpperCase(), style: EstilosTextoAplicacion.etiquetaSeccion),
        const SizedBox(height: 8),
        TextField(
          controller: controlador,
          maxLines: maxLineas,
          keyboardType: teclado,
          autofocus: autofocus,
          onChanged: alCambiar,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: EstilosTextoAplicacion.cuerpoSecundario,
          ),
        ),
      ],
    );
  }
}
