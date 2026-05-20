import 'package:flutter/material.dart';

/// Convierte claves de icono (persistencia/demo) en [IconData].
/// Convierte claves de icono (persistencia/demo) en [IconData].
import 'package:flutter/material.dart';

/// Convierte claves de icono (persistencia/demo) en [IconData].
IconData iconoDesdeClave(String clave) {
  switch (clave) {
    // 🌍 LENGUAJE / ESTUDIO
    case 'traduccion':
      return Icons.translate_rounded;
    case 'libro':
      return Icons.menu_book_rounded;
    case 'birrete':
      return Icons.school_rounded;
    case 'escritura':
      return Icons.edit_note_rounded;
    case 'idioma':
      return Icons.language_rounded;

    // 🧠 MENTE / PRODUCTIVIDAD
    case 'cerebro':
      return Icons.psychology_rounded;
    case 'idea':
      return Icons.lightbulb_rounded;
    case 'objetivo':
      return Icons.track_changes_rounded;
    case 'check':
      return Icons.check_circle_rounded;
    case 'lista':
      return Icons.list_alt_rounded;
    case 'apunte':
      return Icons.note_alt_rounded;
    case 'examen':
      return Icons.assignment_rounded;
    case 'pregunta':
      return Icons.quiz_rounded;
    case 'diccionario':
      return Icons.menu_book_outlined;
    case 'progreso':
      return Icons.trending_up_rounded;

    // 💻 TECNOLOGÍA
    case 'codigo':
      return Icons.code_rounded;
    case 'movil':
      return Icons.smartphone_rounded;
    case 'monitor':
      return Icons.computer_rounded;
    case 'wifi':
      return Icons.wifi_rounded;
    case 'bug':
      return Icons.bug_report_rounded;
    case 'terminal':
      return Icons.terminal_rounded;
    case 'base_datos':
      return Icons.storage_rounded;
    case 'servidor':
      return Icons.dns_rounded;
    case 'bug_fix':
      return Icons.build_circle_rounded;
    case 'seguridad':
      return Icons.lock_rounded;

    // 🏋️ FITNESS / SALUD
    case 'pesa':
      return Icons.fitness_center_rounded;
    case 'corazon':
      return Icons.favorite_rounded;
    case 'salud':
      return Icons.health_and_safety_rounded;
    case 'running':
      return Icons.directions_run_rounded;
    case 'meditacion':
      return Icons.self_improvement_rounded;
    case 'pesas_altas':
      return Icons.sports_gymnastics_rounded;
    case 'dieta':
      return Icons.fastfood_rounded;
    case 'energia':
      return Icons.bolt_rounded;
    case 'ritmo':
      return Icons.speed_rounded;
    case 'postura':
      return Icons.accessibility_new_rounded;

    // 🎨 CREATIVIDAD
    case 'paleta':
      return Icons.palette_rounded;
    case 'musica':
      return Icons.music_note_rounded;
    case 'video':
      return Icons.videocam_rounded;
    case 'camara':
      return Icons.photo_camera_rounded;
    case 'arte':
      return Icons.brush_rounded;

    // 🚀 MOTIVACIÓN / VIDA
    case 'cohete':
      return Icons.rocket_launch_rounded;
    case 'diana':
      return Icons.gps_fixed_rounded;
    case 'fuego':
      return Icons.local_fire_department_rounded;
    case 'estrella':
      return Icons.star_rounded;
    case 'meta':
      return Icons.flag_rounded;
    case 'enfoque':
      return Icons.center_focus_strong_rounded;
    case 'analisis':
      return Icons.analytics_rounded;
    case 'logica':
      return Icons.device_hub_rounded;
    case 'memoria':
      return Icons.memory_rounded;

    // 💼 TRABAJO / NEGOCIO
    case 'maletin':
      return Icons.work_rounded;
    case 'dinero':
      return Icons.attach_money_rounded;
    case 'grafico':
      return Icons.show_chart_rounded;
    case 'calendario':
      return Icons.calendar_month_rounded;
    case 'tiempo':
      return Icons.schedule_rounded;

    // 🌐 GENERAL
    case 'globo':
      return Icons.public_rounded;
    case 'escudo':
      return Icons.shield_rounded;
    case 'config':
      return Icons.settings_rounded;
    case 'carpeta':
      return Icons.folder_rounded;
    case 'nube':
      return Icons.cloud_rounded;
    case 'ubicacion':
      return Icons.location_on_rounded;
    case 'mensaje':
      return Icons.message_rounded;
    case 'notificacion':
      return Icons.notifications_rounded;
    case 'enlace':
      return Icons.link_rounded;
    case 'favorito':
      return Icons.bookmark_rounded;

    // ☕ VIDA DIARIA
    case 'cafe':
      return Icons.coffee_rounded;
    case 'casa':
      return Icons.home_rounded;
    case 'viaje':
      return Icons.flight_rounded;
    case 'comida':
      return Icons.restaurant_rounded;

    default:
      return Icons.layers_rounded;
  }
}

/// Claves disponibles en selectores de icono (orden de la cuadrícula).
const List<String> clavesIconosArea = [
  'traduccion',
  'libro',
  'birrete',
  'escritura',
  'idioma',
  'cerebro',
  'idea',
  'objetivo',
  'check',
  'lista',
  'apunte',
  'examen',
  'pregunta',
  'diccionario',
  'progreso',
  'codigo',
  'movil',
  'monitor',
  'wifi',
  'bug',
  'terminal',
  'base_datos',
  'servidor',
  'bug_fix',
  'seguridad',
  'pesa',
  'corazon',
  'salud',
  'running',
  'meditacion',
  'pesas_altas',
  'dieta',
  'energia',
  'ritmo',
  'postura',
  'paleta',
  'musica',
  'video',
  'camara',
  'arte',
  'cohete',
  'diana',
  'fuego',
  'estrella',
  'meta',
  'enfoque',
  'analisis',
  'logica',
  'memoria',
  'maletin',
  'dinero',
  'grafico',
  'calendario',
  'tiempo',
  'globo',
  'escudo',
  'config',
  'carpeta',
  'nube',
  'ubicacion',
  'mensaje',
  'notificacion',
  'enlace',
  'favorito',
  'cafe',
  'casa',
  'viaje',
  'comida',
];
