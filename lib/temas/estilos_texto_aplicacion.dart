import 'package:flutter/material.dart';

/// Estilos tipográficos centralizados, adaptados al tema activo.
abstract final class EstilosTextoAplicacion {
  static TextStyle etiquetaSeccion(BuildContext context) => TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  static TextStyle tituloPantalla(BuildContext context) => TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.1,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle subtituloPantalla(BuildContext context) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  static TextStyle tituloTarjeta(BuildContext context) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle cuerpo(BuildContext context) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle cuerpoSecundario(BuildContext context) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );
}
