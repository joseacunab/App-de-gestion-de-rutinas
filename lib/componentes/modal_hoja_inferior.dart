import 'package:flutter/material.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/decoraciones_aplicacion.dart';
import '../temas/estilos_texto_aplicacion.dart';

/// Contenedor común para modales tipo hoja con animación de entrada.
Future<T?> mostrarModalHojaInferior<T>({
  required BuildContext context,
  required Widget Function(BuildContext context) contenido,
  bool alExpulsar = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: alExpulsar,
    enableDrag: alExpulsar,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
        child: TweenAnimationBuilder<Offset>(
          tween: Tween(begin: const Offset(0, 0.08), end: Offset.zero),
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          builder: (context, offset, child) {
            return FractionalTranslation(translation: offset, child: child);
          },
          child: contenido(ctx),
        ),
      );
    },
  );
}

class ModalHojaContenedor extends StatelessWidget {
  const ModalHojaContenedor({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.cuerpo,
    this.alCerrar,
  });

  final String titulo;
  final String subtitulo;
  final Widget cuerpo;
  final VoidCallback? alCerrar;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 20),
      decoration: BoxDecoration(
        color: context.superficie,
        borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioModal),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 40,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(titulo, style: EstilosTextoAplicacion.tituloPantalla(context).copyWith(fontSize: 22)),
                        const SizedBox(height: 6),
                        Text(subtitulo, style: EstilosTextoAplicacion.cuerpoSecundario(context)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: alCerrar ?? () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close_rounded, color: ColoresAplicacion.grisMedio),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              cuerpo,
            ],
          ),
        ),
      ),
    );
  }
}
