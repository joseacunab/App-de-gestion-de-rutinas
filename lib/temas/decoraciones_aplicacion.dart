import 'package:flutter/material.dart';
import 'colores_aplicacion.dart';

/// Bordes redondeados, sombras y contornos reutilizables.
abstract final class DecoracionesAplicacion {
  static const double radioTarjeta = 20;
  static const double radioCampo = 14;
  static const double radioBoton = 16;
  static const double radioModal = 28;

  static BoxDecoration tarjetaElevada(BuildContext context, {Color? color}) {
    final tema = Theme.of(context);
    final oscuro = tema.brightness == Brightness.dark;
    return BoxDecoration(
      color: color ?? context.superficie,
      borderRadius: BorderRadius.circular(radioTarjeta),
      border: Border.all(color: context.borde.withValues(alpha: 0.6)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: oscuro ? 0.35 : 0.06),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  static BoxDecoration tarjetaPlana(BuildContext context) {
    return BoxDecoration(
      color: context.superficie,
      borderRadius: BorderRadius.circular(radioTarjeta),
      border: Border.all(color: context.borde),
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
