import 'package:flutter/material.dart';

/// Convierte claves de icono (persistencia/demo) en [IconData].
IconData iconoDesdeClave(String clave) {
  switch (clave) {
    case 'traduccion':
      return Icons.translate_rounded;
    case 'pesa':
      return Icons.fitness_center_rounded;
    case 'movil':
      return Icons.smartphone_rounded;
    case 'escudo':
      return Icons.shield_rounded;
    case 'libro':
      return Icons.menu_book_rounded;
    case 'birrete':
      return Icons.school_rounded;
    case 'maletin':
      return Icons.work_rounded;
    case 'codigo':
      return Icons.code_rounded;
    case 'musica':
      return Icons.music_note_rounded;
    case 'paleta':
      return Icons.palette_rounded;
    case 'corazon':
      return Icons.favorite_rounded;
    case 'cerebro':
      return Icons.psychology_rounded;
    case 'diana':
      return Icons.track_changes_rounded;
    case 'cohete':
      return Icons.rocket_launch_rounded;
    case 'cafe':
      return Icons.coffee_rounded;
    case 'globo':
      return Icons.public_rounded;
    default:
      return Icons.layers_rounded;
  }
}

/// Claves disponibles en selectores de icono (orden de la cuadrícula).
const List<String> clavesIconosArea = [
  'traduccion',
  'pesa',
  'movil',
  'escudo',
  'libro',
  'birrete',
  'maletin',
  'codigo',
  'musica',
  'paleta',
  'corazon',
  'cerebro',
  'diana',
  'cohete',
  'cafe',
  'globo',
];
