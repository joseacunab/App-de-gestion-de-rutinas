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

  static const int _columnasColores = 10;
  static const int _columnasIconos = 8;
  static const double _alturaMaximaGridColores = 140;
  static const double _alturaMaximaGridIconos = 140;

  static const List<Color> _paleta = [
    // 🔵 AZULES (1 base + variaciones reales distintas)
    Color(0xFF3B82F6),
    Color(0xFF1E40AF),
    Color(0xFF60A5FA),
    Color(0xFF0EA5E9),

    // 🟣 VIOLETAS
    Color(0xFF4F46E5),
    Color(0xFF8B5CF6),
    Color(0xFFA78BFA),
    Color(0xFF7C3AED),
    Color(0xFF581C87),

    // 🟢 VERDES
    Color(0xFF22C55E),
    Color(0xFF16A34A),
    Color(0xFF0F766E),
    Color(0xFF166534),
    Color(0xFF84CC16),
    Color(0xFF65A30D),

    // 🔴 ROJOS / ROSAS
    ColoresAplicacion.peligro,
    Color(0xFFBE123C),
    Color(0xFFFB7185),
    Color(0xFF9F1239),
    Color(0xFFEC4899),

    // 🟡 AMARILLOS / NARANJAS
    Color(0xFFEAB308),
    Color(0xFFFBBF24),
    Color(0xFFF97316),
    Color(0xFFEA580C),
    Color(0xFFFB923C),

    // 🔵 CYAN / TEAL
    Color(0xFF06B6D4),
    Color(0xFF14B8A6),
    Color(0xFF2DD4BF),
    Color(0xFF0369A1),

    // ⚫ NEUTROS
    Color(0xFF1F2937),
    Color(0xFF334155),
    Color(0xFF475569),
    Color(0xFF64748B),
    Color(0xFF94A3B8),
    Color(0xFFCBD5E1),
    Color(0xFF0F172A),
  ];
  @override
  void initState() {
    super.initState();
    final a = widget.areaExistente;
    _nombre = TextEditingController(text: a?.nombre ?? '');
    _descripcion = TextEditingController(text: a?.descripcion ?? '');
    _colorSeleccionado =
        a != null ? colorDesdeHex(a.colorHex) : const Color(0xFF3B82F6);
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
            descripcion: _descripcion.text.isEmpty
                ? 'Descripción opcional'
                : _descripcion.text,
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
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1F2937)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: _alturaMaximaGridColores,
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _columnasColores,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childAspectRatio: 1,
                  ),
                  itemCount: _paleta.length,
                  itemBuilder: (context, i) {
                    final c = _paleta[i];
                    final sel = c == _colorSeleccionado;
                    return GestureDetector(
                      onTap: () => setState(() => _colorSeleccionado = c),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        alignment: Alignment.center,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: c,
                            border: Border.all(
                              color: sel
                                  ? ColoresAplicacion.blanco
                                  : Colors.transparent,
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
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('ICONO', style: EstilosTextoAplicacion.etiquetaSeccion(context)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1F2937)
                  : Colors.grey.shade200, // 👈 fondo gris claro
              borderRadius:
                  BorderRadius.circular(12), // opcional pero recomendado
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0), // opcional: aire interno
              child: SizedBox(
                height: _alturaMaximaGridIconos,
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _columnasIconos,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: clavesIconosArea.length,
                  itemBuilder: (context, i) {
                    final clave = clavesIconosArea[i];
                    final sel = clave == _iconoSeleccionado;
                    return GestureDetector(
                      onTap: () => setState(() => _iconoSeleccionado = clave),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: sel
                              ? ColoresAplicacion.azulPrincipal
                                  .withValues(alpha: 0.18)
                              : context.superficieSutil,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          iconoDesdeClave(clave),
                          size: 20,
                          color: sel
                              ? ColoresAplicacion.azulPrincipal
                              : context.esquema.onSurfaceVariant,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: BotonSecundario(
                      etiqueta: 'Cancelar',
                      alExpandirse: true,
                      onPresionado: () => Navigator.pop(context))),
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
                    Navigator.pop(context,
                        ResultadoModalArea(area: area, esEdicion: esEdicion));
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
        borderRadius:
            BorderRadius.circular(DecoracionesAplicacion.radioTarjeta),
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
                Text(nombre,
                    style: EstilosTextoAplicacion.tituloTarjeta(context)),
                Text(descripcion,
                    style: EstilosTextoAplicacion.cuerpoSecundario(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
