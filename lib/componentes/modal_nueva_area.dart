import 'package:flutter/material.dart';
import '../modelos/modelo_area.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/decoraciones_aplicacion.dart';
import '../temas/estilos_texto_aplicacion.dart';
import '../utilidades/mapeador_iconos_area.dart';
import '../utilidades/utilidad_color.dart';
import 'boton_primario.dart';
import 'boton_secundario.dart';
import 'campo_texto_personalizado.dart';
import 'modal_hoja_inferior.dart';

class ResultadoModalArea {
  ResultadoModalArea({required this.area, required this.esEdicion});

  final AreaModelo area;
  final bool esEdicion;
}

class ModalNuevaArea extends StatefulWidget {
  const ModalNuevaArea({super.key, this.areaExistente});

  final AreaModelo? areaExistente;

  @override
  State<ModalNuevaArea> createState() => _ModalNuevaAreaState();
}

class _ModalNuevaAreaState extends State<ModalNuevaArea> {
  late final TextEditingController _nombre;
  late final TextEditingController _descripcion;
  late Color _colorSeleccionado;
  late String _iconoSeleccionado;

  static const List<Color> _paleta = [
    Color(0xFF3B82F6),
    Color(0xFF4F46E5),
    Color(0xFF22C55E),
    Color(0xFF06B6D4),
    Color(0xFFF97316),
    ColoresAplicacion.peligro,
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
  ];

  @override
  void initState() {
    super.initState();
    final a = widget.areaExistente;
    _nombre = TextEditingController(text: a?.nombre ?? '');
    _descripcion = TextEditingController(text: a?.descripcion ?? '');
    _colorSeleccionado = a != null ? colorDesdeHex(a.colorHex) : const Color(0xFF3B82F6);
    _iconoSeleccionado = a?.icono ?? 'traduccion';
  }

  @override
  void dispose() {
    _nombre.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.areaExistente != null;
    return ModalHojaContenedor(
      titulo: esEdicion ? 'Editar área' : 'Nueva área',
      subtitulo: 'Personaliza el color y el icono de tu área.',
      cuerpo: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _VistaPreviaArea(
            nombre: _nombre.text.isEmpty ? 'Nombre del área' : _nombre.text,
            descripcion: _descripcion.text.isEmpty ? 'Descripción opcional' : _descripcion.text,
            color: _colorSeleccionado,
            claveIcono: _iconoSeleccionado,
          ),
          const SizedBox(height: 18),
          CampoTextoPersonalizado(
            etiqueta: 'Nombre',
            controlador: _nombre,
            placeholder: 'Ej. Inglés',
            alCambiar: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          CampoTextoPersonalizado(
            etiqueta: 'Descripción',
            controlador: _descripcion,
            placeholder: 'Opcional',
            alCambiar: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Text('COLOR', style: EstilosTextoAplicacion.etiquetaSeccion(context)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _paleta.map((c) {
                final sel = c == _colorSeleccionado;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => _colorSeleccionado = c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: c,
                        border: Border.all(
                          color: sel ? ColoresAplicacion.blanco : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: sel
                            ? [
                                BoxShadow(
                                  color: c.withValues(alpha: 0.55),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Text('ICONO', style: EstilosTextoAplicacion.etiquetaSeccion(context)),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: clavesIconosArea.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, i) {
              final clave = clavesIconosArea[i];
              final sel = clave == _iconoSeleccionado;
              return GestureDetector(
                onTap: () => setState(() => _iconoSeleccionado = clave),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: sel
                        ? ColoresAplicacion.azulPrincipal.withValues(alpha: 0.18)
                        : context.superficieSutil,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    iconoDesdeClave(clave),
                    size: 20,
                    color: sel ? ColoresAplicacion.azulPrincipal : context.esquema.onSurfaceVariant,
                  ),
                ),
              );
            },
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
                    final nombre = _nombre.text.trim();
                    if (nombre.isEmpty) return;
                    final prev = widget.areaExistente;
                    final area = AreaModelo(
                      id: prev?.id ?? '',
                      nombre: nombre,
                      descripcion: _descripcion.text.trim(),
                      icono: _iconoSeleccionado,
                      colorHex: hexDesdeColor(_colorSeleccionado),
                      orden: prev?.orden ?? 0,
                      usuarioId: prev?.usuarioId ?? '',
                      creadoEn: prev?.creadoEn,
                      actualizadoEn: prev?.actualizadoEn,
                    );
                    Navigator.pop(context, ResultadoModalArea(area: area, esEdicion: esEdicion));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VistaPreviaArea extends StatelessWidget {
  const _VistaPreviaArea({
    required this.nombre,
    required this.descripcion,
    required this.color,
    required this.claveIcono,
  });

  final String nombre;
  final String descripcion;
  final Color color;
  final String claveIcono;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColoresAplicacion.azulPrincipal.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioTarjeta),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withValues(alpha: 0.2),
            child: Icon(iconoDesdeClave(claveIcono), color: color, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nombre, style: EstilosTextoAplicacion.tituloTarjeta(context)),
                Text(descripcion, style: EstilosTextoAplicacion.cuerpoSecundario(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
