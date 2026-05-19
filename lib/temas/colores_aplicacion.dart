import 'package:flutter/material.dart';

/// Tokens de color de la marca y superficies.
abstract final class ColoresAplicacion {
  static const Color azulPrincipal = Color(0xFF3B82F6);
  static const Color azulOscuro = Color(0xFF1E3A8A);
  static const Color azulClaro = Color(0xFFDBEAFE);
  static const Color blanco = Color(0xFFFFFFFF);
  static const Color grisOscuro = Color(0xFF1F2937);
  static const Color grisClaro = Color(0xFFF3F4F6);
  static const Color grisMedio = Color(0xFF9CA3AF);
  static const Color bordeSutil = Color(0xFFE5E7EB);
  static const Color exito = Color(0xFF22C55E);
  static const Color advertencia = Color(0xFFF59E0B);
  static const Color peligro = Color(0xFFEF4444);
}

/// Superficies y bordes derivados del [Theme] activo (claro/oscuro).
extension SuperficiesTema on BuildContext {
  ThemeData get tema => Theme.of(this);
  ColorScheme get esquema => tema.colorScheme;

  Color get superficie => esquema.surface;
  Color get superficieContenedor => esquema.surfaceContainerHighest;
  Color get superficieSutil => esquema.surfaceContainerHigh;
  Color get borde => tema.dividerColor;
}
