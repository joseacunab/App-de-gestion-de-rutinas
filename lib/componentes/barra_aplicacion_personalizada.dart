import 'package:flutter/material.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/estilos_texto_aplicacion.dart';

/// Variante de jerarquía del encabezado (inicio vs. pantallas con retroceso).
enum EstiloEncabezadoBarra {
  saludoArriba,
  tituloArriba,
}

/// Encabezado tipo “startup” con subtítulo opcional y acciones a la derecha.
class BarraAplicacionPersonalizada extends StatelessWidget implements PreferredSizeWidget {
  const BarraAplicacionPersonalizada({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.acciones,
    this.alRetroceder,
    this.estilo = EstiloEncabezadoBarra.tituloArriba,
  });

  final String titulo;
  final String? subtitulo;
  final List<Widget>? acciones;
  final VoidCallback? alRetroceder;
  final EstiloEncabezadoBarra estilo;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final lineas = estilo == EstiloEncabezadoBarra.saludoArriba
        ? <Widget>[
            if (subtitulo != null) Text(subtitulo!, style: EstilosTextoAplicacion.subtituloPantalla),
            if (subtitulo != null) const SizedBox(height: 2),
            Text(titulo, style: EstilosTextoAplicacion.tituloPantalla),
          ]
        : <Widget>[
            Text(titulo, style: EstilosTextoAplicacion.tituloPantalla),
            if (subtitulo != null) ...[
              const SizedBox(height: 2),
              Text(subtitulo!, style: EstilosTextoAplicacion.subtituloPantalla),
            ],
          ];

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
        child: Row(
          children: [
            if (alRetroceder != null)
              IconButton(
                onPressed: alRetroceder,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                color: ColoresAplicacion.grisOscuro,
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: lineas,
              ),
            ),
            if (acciones != null) ...acciones!,
          ],
        ),
      ),
    );
  }
}
