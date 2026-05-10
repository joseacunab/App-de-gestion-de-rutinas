import 'package:flutter/material.dart';
import '../temas/colores_aplicacion.dart';

/// Convierte `#RRGGBB` o `#AARRGGBB` a [Color]; fallback azul marca.
Color colorDesdeHex(String? hex) {
  if (hex == null || hex.isEmpty) return ColoresAplicacion.azulPrincipal;
  var s = hex.trim();
  if (s.startsWith('#')) s = s.substring(1);
  if (s.length == 6) {
    final v = int.tryParse(s, radix: 16);
    if (v == null) return ColoresAplicacion.azulPrincipal;
    return Color(0xFF000000 | v);
  }
  if (s.length == 8) {
    final v = int.tryParse(s, radix: 16);
    if (v == null) return ColoresAplicacion.azulPrincipal;
    return Color(v);
  }
  return ColoresAplicacion.azulPrincipal;
}

String hexDesdeColor(Color color) {
  final r = (color.r * 255.0).round().clamp(0, 255);
  final g = (color.g * 255.0).round().clamp(0, 255);
  final b = (color.b * 255.0).round().clamp(0, 255);
  return '#${r.toRadixString(16).padLeft(2, '0')}'
      '${g.toRadixString(16).padLeft(2, '0')}'
      '${b.toRadixString(16).padLeft(2, '0')}';
}
