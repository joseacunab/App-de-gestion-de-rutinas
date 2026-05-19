import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../dominio/enumeracion_prioridad.dart';
import '../modelos/modelo_actividad.dart';
import '../modelos/modelo_area.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/decoraciones_aplicacion.dart';
import '../temas/estilos_texto_aplicacion.dart';
import '../utilidades/mapeador_iconos_area.dart';
import '../utilidades/utilidad_color.dart';
import '../utilidades/utilidad_prioridad.dart';
import 'boton_primario.dart';
import 'boton_secundario.dart';
import 'campo_texto_personalizado.dart';

class ResultadoModalActividad {
  ResultadoModalActividad({required this.actividad, required this.esEdicion});

  final ActividadModelo actividad;
  final bool esEdicion;
}

Future<ResultadoModalActividad?> mostrarModalNuevaActividad(
  BuildContext context, {
  required List<AreaModelo> areas,
  ActividadModelo? existente,
  String? idAreaPreseleccionada,
  required String usuarioId,
}) {
  return showGeneralDialog<ResultadoModalActividad>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (ctx, a1, a2) {
      return _DialogoActividad(
        areas: areas,
        existente: existente,
        idAreaPreseleccionada: idAreaPreseleccionada,
        usuarioId: usuarioId,
      );
    },
    transitionBuilder: (ctx, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _DialogoActividad extends StatefulWidget {
  const _DialogoActividad({
    required this.areas,
    this.existente,
    this.idAreaPreseleccionada,
    required this.usuarioId,
  });

  final List<AreaModelo> areas;
  final ActividadModelo? existente;
  final String? idAreaPreseleccionada;
  final String usuarioId;

  @override
  State<_DialogoActividad> createState() => _DialogoActividadState();
}

class _DialogoActividadState extends State<_DialogoActividad> {
  late final TextEditingController _titulo;
  late final TextEditingController _descripcion;
  late final TextEditingController _duracion;
  late String _idArea;
  late DateTime _fecha;
  late TimeOfDay _hora;
  late EnumeracionPrioridad _prioridad;

  @override
  void initState() {
    super.initState();
    final e = widget.existente;
    _titulo = TextEditingController(text: e?.titulo ?? '');
    _descripcion = TextEditingController(text: e?.descripcion ?? '');
    _duracion = TextEditingController(text: '${e?.duracionMinutos.round() ?? 60}');
    _idArea = e?.areaId ??
        widget.idAreaPreseleccionada ??
        (widget.areas.isNotEmpty ? widget.areas.first.id : '');
    final base = e?.momentoAgendado ?? DateTime.now();
    _fecha = DateTime(base.year, base.month, base.day);
    _hora = TimeOfDay(hour: base.hour, minute: base.minute);
    _prioridad = enumeracionDesdeCadena(e?.prioridad);
  }

  @override
  void dispose() {
    _titulo.dispose();
    _descripcion.dispose();
    _duracion.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final r = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (r != null) setState(() => _fecha = r);
  }

  Future<void> _elegirHora() async {
    final r = await showTimePicker(context: context, initialTime: _hora);
    if (r != null) setState(() => _hora = r);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.areas.isEmpty) {
      return Center(
        child: Material(
          color: context.superficie,
          borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioModal),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Crea al menos un área antes de agregar actividades.', style: EstilosTextoAplicacion.cuerpo(context)),
                const SizedBox(height: 16),
                BotonSecundario(etiqueta: 'Cerrar', alExpandirse: true, onPresionado: () => Navigator.pop(context)),
              ],
            ),
          ),
        ),
      );
    }
    final esEdicion = widget.existente != null;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.sizeOf(context).width - 32,
          constraints: const BoxConstraints(maxWidth: 420),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.fromLTRB(20, 18, 12, 20),
          decoration: BoxDecoration(
            color: context.superficie,
            borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioModal),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            esEdicion ? 'Editar actividad' : 'Nueva actividad',
                            style: EstilosTextoAplicacion.tituloPantalla(context).copyWith(fontSize: 22),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Completa los datos para crear una nueva tarea.',
                            style: EstilosTextoAplicacion.cuerpoSecundario(context),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, color: ColoresAplicacion.grisMedio),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CampoTextoPersonalizado(
                  etiqueta: 'Título',
                  controlador: _titulo,
                  placeholder: 'Ej. Speaking',
                ),
                const SizedBox(height: 12),
                CampoTextoPersonalizado(
                  etiqueta: 'Descripción (opcional)',
                  controlador: _descripcion,
                  placeholder: 'Notas o detalles...',
                  maxLineas: 3,
                ),
                const SizedBox(height: 12),
                Text('ÁREA', style: EstilosTextoAplicacion.etiquetaSeccion(context)),
                const SizedBox(height: 8),
                _SelectorArea(
                  areas: widget.areas,
                  idSeleccionada: _idArea,
                  alCambiar: (id) => setState(() => _idArea = id),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('FECHA', style: EstilosTextoAplicacion.etiquetaSeccion(context)),
                          const SizedBox(height: 8),
                          _CajaSelector(
                            texto: DateFormat('dd/MM/yyyy').format(_fecha),
                            icono: Icons.calendar_today_rounded,
                            onTap: _elegirFecha,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('HORA', style: EstilosTextoAplicacion.etiquetaSeccion(context)),
                          const SizedBox(height: 8),
                          _CajaSelector(
                            texto: _hora.format(context),
                            icono: Icons.schedule_rounded,
                            onTap: _elegirHora,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DURACIÓN (MIN)', style: EstilosTextoAplicacion.etiquetaSeccion(context)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _duracion,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PRIORIDAD', style: EstilosTextoAplicacion.etiquetaSeccion(context)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<EnumeracionPrioridad>(
                            value: _prioridad,
                            decoration: const InputDecoration(),
                            items: EnumeracionPrioridad.values
                                .map(
                                  (p) => DropdownMenuItem(
                                    value: p,
                                    child: Text(etiquetaPrioridad(p)),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _prioridad = v);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: BotonSecundario(etiqueta: 'Cancelar', alExpandirse: true, onPresionado: () => Navigator.pop(context))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BotonPrimario(
                        etiqueta: esEdicion ? 'Guardar' : 'Crear',
                        alExpandirse: true,
                        onPresionado: () {
                          final titulo = _titulo.text.trim();
                          if (titulo.isEmpty) return;
                          final minutos = double.tryParse(_duracion.text.trim()) ?? 60;
                          final fechaHora = DateTime(
                            _fecha.year,
                            _fecha.month,
                            _fecha.day,
                            _hora.hour,
                            _hora.minute,
                          );
                          final tsFecha = Timestamp.fromDate(DateTime(_fecha.year, _fecha.month, _fecha.day));
                          final tsHora = Timestamp.fromDate(fechaHora);
                          final e = widget.existente;
                          final act = ActividadModelo(
                            id: e?.id ?? '',
                            titulo: titulo,
                            descripcion: _descripcion.text.trim(),
                            areaId: _idArea,
                            usuarioId: e?.usuarioId ?? widget.usuarioId,
                            prioridad: cadenaPrioridadFirestore(_prioridad),
                            duracionMinutos: minutos,
                            completada: e?.completada ?? false,
                            fecha: tsFecha,
                            hora: tsHora,
                            fechaCompletada: e?.fechaCompletada,
                            creadoEn: e?.creadoEn,
                            actualizadoEn: e?.actualizadoEn,
                          );
                          Navigator.pop(
                            context,
                            ResultadoModalActividad(actividad: act, esEdicion: esEdicion),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectorArea extends StatelessWidget {
  const _SelectorArea({
    required this.areas,
    required this.idSeleccionada,
    required this.alCambiar,
  });

  final List<AreaModelo> areas;
  final String idSeleccionada;
  final ValueChanged<String> alCambiar;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: idSeleccionada,
      decoration: const InputDecoration(),
      items: areas
          .map(
            (a) => DropdownMenuItem(
              value: a.id,
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: colorDesdeHex(a.colorHex),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(iconoDesdeClave(a.icono), size: 18, color: colorDesdeHex(a.colorHex)),
                  const SizedBox(width: 8),
                  Text(a.nombre),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: (v) {
        if (v != null) alCambiar(v);
      },
    );
  }
}

class _CajaSelector extends StatelessWidget {
  const _CajaSelector({required this.texto, required this.icono, required this.onTap});

  final String texto;
  final IconData icono;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.superficieContenedor,
      borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioCampo),
      child: InkWell(
        borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioCampo),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Expanded(child: Text(texto, style: EstilosTextoAplicacion.cuerpo(context))),
              Icon(icono, size: 20, color: ColoresAplicacion.grisMedio),
            ],
          ),
        ),
      ),
    );
  }
}
