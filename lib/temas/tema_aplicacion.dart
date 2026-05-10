import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colores_aplicacion.dart';
import 'decoraciones_aplicacion.dart';

/// Construye [ThemeData] claro y oscuro (Material 3).
class TemaAplicacion {
  static ThemeData claro() {
    final esquema = ColorScheme.fromSeed(
      seedColor: ColoresAplicacion.azulPrincipal,
      brightness: Brightness.light,
      primary: ColoresAplicacion.azulPrincipal,
      surface: ColoresAplicacion.blanco,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: esquema,
      scaffoldBackgroundColor: ColoresAplicacion.grisClaro,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: ColoresAplicacion.grisOscuro,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      dividerColor: ColoresAplicacion.bordeSutil,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColoresAplicacion.grisClaro,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioCampo),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioCampo),
          borderSide: const BorderSide(color: ColoresAplicacion.bordeSutil),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioCampo),
          borderSide: const BorderSide(color: ColoresAplicacion.azulPrincipal, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: ColoresAplicacion.azulPrincipal,
          foregroundColor: ColoresAplicacion.blanco,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioBoton),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: ColoresAplicacion.grisOscuro),
      ),
    );
  }

  /// Tema oscuro preparado para activarse desde configuración.
  static ThemeData oscuro() {
    final esquema = ColorScheme.fromSeed(
      seedColor: ColoresAplicacion.azulPrincipal,
      brightness: Brightness.dark,
      primary: ColoresAplicacion.azulPrincipal,
      surface: const Color(0xFF111827),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: esquema,
      scaffoldBackgroundColor: const Color(0xFF0B1220),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: ColoresAplicacion.blanco,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1F2937),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioCampo),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
