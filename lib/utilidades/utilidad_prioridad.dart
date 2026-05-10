import 'package:flutter/material.dart';
import '../dominio/enumeracion_prioridad.dart';
import '../temas/colores_aplicacion.dart';

String etiquetaPrioridad(EnumeracionPrioridad p) {
  switch (p) {
    case EnumeracionPrioridad.baja:
      return 'Baja';
    case EnumeracionPrioridad.media:
      return 'Media';
    case EnumeracionPrioridad.alta:
      return 'Alta';
  }
}

Color colorPrioridad(EnumeracionPrioridad p) {
  switch (p) {
    case EnumeracionPrioridad.baja:
      return ColoresAplicacion.exito;
    case EnumeracionPrioridad.media:
      return ColoresAplicacion.advertencia;
    case EnumeracionPrioridad.alta:
      return ColoresAplicacion.peligro;
  }
}

/// Prioridad almacenada en Firestore como string (`alta` | `media` | `baja`).
EnumeracionPrioridad enumeracionDesdeCadena(String? valor) {
  switch ((valor ?? 'media').toLowerCase()) {
    case 'alta':
      return EnumeracionPrioridad.alta;
    case 'baja':
      return EnumeracionPrioridad.baja;
    default:
      return EnumeracionPrioridad.media;
  }
}

String cadenaPrioridadFirestore(EnumeracionPrioridad p) {
  switch (p) {
    case EnumeracionPrioridad.alta:
      return 'alta';
    case EnumeracionPrioridad.media:
      return 'media';
    case EnumeracionPrioridad.baja:
      return 'baja';
  }
}

Color colorPrioridadCadena(String prioridad) {
  return colorPrioridad(enumeracionDesdeCadena(prioridad));
}

String etiquetaPrioridadCadena(String prioridad) {
  return etiquetaPrioridad(enumeracionDesdeCadena(prioridad));
}
