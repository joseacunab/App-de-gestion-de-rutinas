import 'package:flutter/material.dart';
import 'colores_aplicacion.dart';

/// Bordes redondeados, sombras y contornos reutilizables.
abstract final class DecoracionesAplicacion {
  static const double radioTarjeta = 20;
  static const double radioCampo = 14;
  static const double radioBoton = 16;
  static const double radioModal = 28;

  static BoxDecoration tarjetaElevada({Color? color}) {
    return BoxDecoration(
      color: color ?? ColoresAplicacion.blanco,
      borderRadius: BorderRadius.circular(radioTarjeta),
      border: Border.all(color: ColoresAplicacion.bordeSutil.withValues(alpha: 0.6)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  static BoxDecoration tarjetaPlana() {
    return BoxDecoration(
      color: ColoresAplicacion.blanco,
      borderRadius: BorderRadius.circular(radioTarjeta),
      border: Border.all(color: ColoresAplicacion.bordeSutil),
    );
  }

  static List<BoxShadow> sombraBotonPrimario() {
    return [
      BoxShadow(
        color: ColoresAplicacion.azulPrincipal.withValues(alpha: 0.35),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ];
  }
}
