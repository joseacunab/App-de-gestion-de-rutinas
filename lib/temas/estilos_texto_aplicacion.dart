import 'package:flutter/material.dart';
import 'colores_aplicacion.dart';

/// Estilos tipográficos centralizados (claros).
abstract final class EstilosTextoAplicacion {
  static const TextStyle etiquetaSeccion = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: ColoresAplicacion.grisMedio,
  );

  static const TextStyle tituloPantalla = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    height: 1.1,
    color: ColoresAplicacion.grisOscuro,
  );

  static const TextStyle subtituloPantalla = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: ColoresAplicacion.grisMedio,
  );

  static const TextStyle tituloTarjeta = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: ColoresAplicacion.grisOscuro,
  );

  static const TextStyle cuerpo = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: ColoresAplicacion.grisOscuro,
  );

  static const TextStyle cuerpoSecundario = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: ColoresAplicacion.grisMedio,
  );
}
