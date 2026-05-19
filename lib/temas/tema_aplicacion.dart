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
      surfaceContainerHigh: ColoresAplicacion.grisClaro,
      surfaceContainerHighest: ColoresAplicacion.grisClaro,
      outline: ColoresAplicacion.bordeSutil,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: esquema,
      scaffoldBackgroundColor: ColoresAplicacion.grisClaro,
      cardColor: ColoresAplicacion.blanco,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: ColoresAplicacion.grisOscuro,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      dividerColor: ColoresAplicacion.bordeSutil,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: ColoresAplicacion.blanco,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: ColoresAplicacion.blanco,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioModal),
        ),
      ),
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
    const superficie = Color(0xFF111827);
    const contenedor = Color(0xFF1F2937);
    const contenedorAlto = Color(0xFF374151);
    const borde = Color(0xFF374151);

    final esquema = ColorScheme.fromSeed(
      seedColor: ColoresAplicacion.azulPrincipal,
      brightness: Brightness.dark,
      primary: ColoresAplicacion.azulPrincipal,
      surface: superficie,
      surfaceContainerHigh: contenedor,
      surfaceContainerHighest: contenedorAlto,
      outline: borde,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: esquema,
      scaffoldBackgroundColor: const Color(0xFF0B1220),
      cardColor: superficie,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: ColoresAplicacion.blanco,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      dividerColor: borde,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: superficie,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: superficie,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioModal),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: contenedor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioCampo),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioCampo),
          borderSide: const BorderSide(color: borde),
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
        style: TextButton.styleFrom(foregroundColor: esquema.onSurface),
      ),
    );
  }
}
