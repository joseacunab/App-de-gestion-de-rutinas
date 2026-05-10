import 'package:flutter/material.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/decoraciones_aplicacion.dart';
import '../temas/estilos_texto_aplicacion.dart';

/// Campo con etiqueta superior y mensaje de error en rojo bajo el input.
class CampoTextoAutenticacion extends StatelessWidget {
  const CampoTextoAutenticacion({
    super.key,
    required this.etiqueta,
    required this.controlador,
    this.placeholder,
    this.textoError,
    this.teclado = TextInputType.text,
    this.ocultarTexto = false,
    this.autocompletar,
  });

  final String etiqueta;
  final TextEditingController controlador;
  final String? placeholder;
  final String? textoError;
  final TextInputType teclado;
  final bool ocultarTexto;
  final TextInputAction? autocompletar;

  @override
  Widget build(BuildContext context) {
    final tieneError = textoError != null && textoError!.isNotEmpty;
    final colorBorde = tieneError ? ColoresAplicacion.peligro : ColoresAplicacion.bordeSutil;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: EstilosTextoAplicacion.cuerpo.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controlador,
          keyboardType: teclado,
          obscureText: ocultarTexto,
          textInputAction: autocompletar,
          style: EstilosTextoAplicacion.cuerpo,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: EstilosTextoAplicacion.cuerpoSecundario,
            filled: true,
            fillColor: ColoresAplicacion.grisClaro,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioCampo),
              borderSide: BorderSide(color: colorBorde),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioCampo),
              borderSide: BorderSide(
                color: tieneError ? ColoresAplicacion.peligro : ColoresAplicacion.azulPrincipal,
                width: 1.4,
              ),
            ),
          ),
        ),
        if (tieneError) ...[
          const SizedBox(height: 6),
          Text(
            textoError!,
            style: const TextStyle(
              color: ColoresAplicacion.peligro,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
