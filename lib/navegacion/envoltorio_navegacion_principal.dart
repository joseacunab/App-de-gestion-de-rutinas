import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../componentes/barra_navegacion_inferior_personalizada.dart';
import '../controladores/controlador_seleccion_temporal.dart';
import '../pantallas/pantalla_areas.dart';
import '../pantallas/pantalla_configuracion.dart';
import '../pantallas/pantalla_estados.dart';
import '../pantallas/pantalla_inicio.dart';
import '../pantallas/pantalla_tareas.dart';

/// Shell principal con barra inferior animada y transición entre pestañas.
class EnvoltorioNavegacionPrincipal extends StatefulWidget {
  const EnvoltorioNavegacionPrincipal({super.key});

  @override
  State<EnvoltorioNavegacionPrincipal> createState() => _EnvoltorioNavegacionPrincipalState();
}

class _EnvoltorioNavegacionPrincipalState extends State<EnvoltorioNavegacionPrincipal>
    with WidgetsBindingObserver {
  int _indice = 0;
  Timer? _temporizadorCalendario;
  bool _temporizadorIniciado = false;

  static const List<Widget> _pantallas = [
    PantallaInicio(),
    PantallaAreas(),
    PantallaTareas(),
    PantallaEstados(),
    PantallaConfiguracion(),
  ];

  static const List<ElementoNavegacionInferior> _elementos = [
    ElementoNavegacionInferior(
      etiqueta: 'Inicio',
      iconoInactivo: Icons.home_outlined,
      iconoActivo: Icons.home_rounded,
    ),
    ElementoNavegacionInferior(
      etiqueta: 'Áreas',
      iconoInactivo: Icons.layers_outlined,
      iconoActivo: Icons.layers_rounded,
    ),
    ElementoNavegacionInferior(
      etiqueta: 'Tareas',
      iconoInactivo: Icons.fact_check_outlined,
      iconoActivo: Icons.fact_check_rounded,
    ),
    ElementoNavegacionInferior(
      etiqueta: 'Estados',
      iconoInactivo: Icons.bar_chart_outlined,
      iconoActivo: Icons.bar_chart_rounded,
    ),
    ElementoNavegacionInferior(
      etiqueta: 'Configuración',
      iconoInactivo: Icons.settings_outlined,
      iconoActivo: Icons.settings_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_temporizadorIniciado) {
      _temporizadorIniciado = true;
      final temporal = context.read<ControladorSeleccionTemporal>();
      _temporizadorCalendario = Timer.periodic(
        const Duration(seconds: 30),
        (_) => temporal.comprobarAvanceCalendario(),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _temporizadorCalendario?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<ControladorSeleccionTemporal>().comprobarAvanceCalendario();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeOutCubic,
        transitionBuilder: (child, animation) {
          final offset = Tween<Offset>(
            begin: const Offset(0, 0.02),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: offset, child: child),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_indice),
          child: _pantallas[_indice],
        ),
      ),
      bottomNavigationBar: BarraNavegacionInferiorPersonalizada(
        indiceActivo: _indice,
        alSeleccionar: (i) => setState(() => _indice = i),
        elementos: _elementos,
      ),
    );
  }
}
