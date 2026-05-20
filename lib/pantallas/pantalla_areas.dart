import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../componentes/barra_aplicacion_personalizada.dart';
import '../componentes/modal_hoja_inferior.dart';
import '../componentes/modal_nueva_area.dart';
import '../componentes/selector_fecha_global.dart';
import '../componentes/tarjeta_area_lista.dart';
import '../controladores/controlador_actividades.dart';
import '../controladores/controlador_areas.dart';
import '../controladores/controlador_seleccion_temporal.dart';
import '../controladores/controlador_usuario.dart';
import '../modelos/modelo_actividad.dart';
import '../modelos/modelo_area.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/estilos_texto_aplicacion.dart';
import '../utilidades/mapeador_iconos_area.dart';
import '../utilidades/utilidad_color.dart';
import '../utilidades/utilidad_consultas_actividad.dart' as consultas;
import '../utilidades/utilidad_fecha.dart';
import 'pantalla_detalle_area.dart';

bool _areaRelevanteEnPeriodo(
  AreaModelo area,
  Set<String> idsConActividad,
  DateTime ini,
  DateTime fin,
) {
  if (idsConActividad.contains(area.id)) return true;
  final creado = area.creadoEn?.toDate();
  if (creado == null) return false;
  final d = DateTime(creado.year, creado.month, creado.day);
  return diaCalendarioEnRango(d, ini, fin);
}

/// Listado de áreas con FAB y modales de alta/edición.
class PantallaAreas extends StatefulWidget {
  const PantallaAreas({super.key});

  @override
  State<PantallaAreas> createState() => _PantallaAreasState();
}

class _PantallaAreasState extends State<PantallaAreas> {
  bool _mostrarMisAreas = false;

  Future<void> _editarArea(
    BuildContext context,
    ControladorAreas controladorAreas,
    AreaModelo area,
  ) async {
    final r = await mostrarModalHojaInferior<ResultadoModalArea>(
      context: context,
      contenido: (_) => ModalNuevaArea(areaExistente: area),
    );
    if (r == null || !context.mounted) return;
    await controladorAreas.actualizarArea(r.area);
  }

  Future<void> _eliminarArea(
    BuildContext context,
    ControladorAreas controladorAreas,
    AreaModelo area,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar área'),
        content: Text('Se eliminará "${area.nombre}" y sus actividades.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(
                foregroundColor: ColoresAplicacion.peligro),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    await controladorAreas.eliminarArea(area.id);
  }

  @override
  Widget build(BuildContext context) {
    final controladorAreas = context.watch<ControladorAreas>();
    final controladorActividades = context.watch<ControladorActividades>();
    final temporal = context.watch<ControladorSeleccionTemporal>();
    final uid = context.watch<ControladorUsuario>().usuarioAuth?.uid;
    final areas = controladorAreas.areas;
    final misAreas = uid == null
        ? <AreaModelo>[]
        : areas.where((a) => a.usuarioId == uid).toList()
      ..sort((a, b) => a.orden.compareTo(b.orden));

    final (ini, fin) = rangoParaReferencia(temporal.referencia, temporal.modo);
    final actividadesPeriodo = temporal.suprimirDatosVisuales
        ? <ActividadModelo>[]
        : consultas.actividadesEnRango(
            controladorActividades.actividades, ini, fin);

    final idsAreaConActividad = actividadesPeriodo.map((t) => t.areaId).toSet();
    final areasVisibles = areas
        .where((a) => _areaRelevanteEnPeriodo(a, idsAreaConActividad, ini, fin))
        .toList();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: BarraAplicacionPersonalizada(
            estilo: EstiloEncabezadoBarra.saludoArriba,
            titulo: 'Áreas',
            subtitulo: 'Tus categorías',
            acciones: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton.icon(
                  onPressed: () =>
                      setState(() => _mostrarMisAreas = !_mostrarMisAreas),
                  style: TextButton.styleFrom(
                    backgroundColor: _mostrarMisAreas
                        ? ColoresAplicacion.azulPrincipal
                            .withValues(alpha: 0.12)
                        : context.superficie,
                    foregroundColor: _mostrarMisAreas
                        ? ColoresAplicacion.azulPrincipal
                        : Theme.of(context).colorScheme.onSurface,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                      side: BorderSide(color: context.borde),
                    ),
                  ),
                  icon: Icon(
                    _mostrarMisAreas
                        ? Icons.layers_rounded
                        : Icons.layers_outlined,
                    size: 18,
                  ),
                  label: const Text(
                    'Mis áreas',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ), /*
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Material(
                  color: ColoresAplicacion.azulPrincipal,
                  shape: const CircleBorder(),
                  elevation: 6,
                  shadowColor:
                      ColoresAplicacion.azulPrincipal.withValues(alpha: 0.4),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () async {
                      if (uid == null) return;
                      final r =
                          await mostrarModalHojaInferior<ResultadoModalArea>(
                        context: context,
                        contenido: (_) => const ModalNuevaArea(),
                      );
                      if (r == null || !context.mounted) return;
                      if (r.esEdicion) {
                        await controladorAreas.actualizarArea(r.area);
                      } else {
                        await controladorAreas.crearArea(r.area, uid);
                      }
                    },
                    child: const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(Icons.add_rounded,
                          color: ColoresAplicacion.blanco),
                    ),
                  ),
                ),
              ),*/
            ],
          ),
        ),
        if (!_mostrarMisAreas) ...[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            sliver: SliverToBoxAdapter(
              child: SelectorFechaGlobal(
                modo: temporal.modo,
                referencia: temporal.referencia,
                alCambiarModo: (m) => context
                    .read<ControladorSeleccionTemporal>()
                    .establecerModo(m),
                alAnterior: () =>
                    context.read<ControladorSeleccionTemporal>().desplazar(-1),
                alSiguiente: () =>
                    context.read<ControladorSeleccionTemporal>().desplazar(1),
              ),
            ),
          ),
          //Aca muestro un mensaje si no hay datos
          if (areasVisibles.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.category_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                    const SizedBox(height: 12),
                    Text(
                      'Sin áreas en este período',
                      style: EstilosTextoAplicacion.tituloTarjeta(context),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Creá una nueva área con el botón +',
                      style: EstilosTextoAplicacion.cuerpoSecundario(context),
                    ),
                  ],
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            sliver: SliverList.separated(
              itemCount: areasVisibles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final a = areasVisibles[i];
                final (pend, pct) =
                    controladorAreas.resumenArea(a.id, actividadesPeriodo);
                return TarjetaAreaLista(
                  area: a,
                  pendientes: pend,
                  porcentajeProgreso: pct,
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder<void>(
                        pageBuilder: (_, __, ___) =>
                            PantallaDetalleArea(idArea: a.id),
                        transitionsBuilder: (_, anim, __, child) {
                          return FadeTransition(opacity: anim, child: child);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ] else ...[
          if (misAreas.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.layers_clear_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No tenés áreas creadas',
                      style: EstilosTextoAplicacion.tituloTarjeta(context),
                    ),
                  ],
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            sliver: SliverMainAxisGroup(
              slivers: [
                // BOTON ARRIBA
                SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4, bottom: 12),
                      child: Material(
                        color: ColoresAplicacion.azulPrincipal,
                        shape: const CircleBorder(),
                        elevation: 6,
                        shadowColor: ColoresAplicacion.azulPrincipal
                            .withValues(alpha: 0.4),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () async {
                            if (uid == null) return;

                            final r = await mostrarModalHojaInferior<
                                ResultadoModalArea>(
                              context: context,
                              contenido: (_) => const ModalNuevaArea(),
                            );

                            if (r == null || !context.mounted) return;

                            if (r.esEdicion) {
                              await controladorAreas.actualizarArea(r.area);
                            } else {
                              await controladorAreas.crearArea(r.area, uid);
                            }
                          },
                          child: const SizedBox(
                            width: 48,
                            height: 48,
                            child: Icon(
                              Icons.add_rounded,
                              color: ColoresAplicacion.blanco,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // LISTA
                SliverList.separated(
                  itemCount: misAreas.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final area = misAreas[i];
                    final colorArea = colorDesdeHex(area.colorHex);

                    return Material(
                      color: context.superficie,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder<void>(
                              pageBuilder: (_, __, ___) =>
                                  PantallaDetalleArea(idArea: area.id),
                              transitionsBuilder: (_, anim, __, child) {
                                return FadeTransition(
                                  opacity: anim,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor:
                                    colorArea.withValues(alpha: 0.2),
                                child: Icon(
                                  iconoDesdeClave(area.icono),
                                  color: colorArea,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      area.nombre,
                                      style:
                                          EstilosTextoAplicacion.tituloTarjeta(
                                              context),
                                    ),
                                    if (area.descripcion.isNotEmpty)
                                      Text(
                                        area.descripcion,
                                        style: EstilosTextoAplicacion
                                            .cuerpoSecundario(
                                          context,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Editar',
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () => _editarArea(
                                      context,
                                      controladorAreas,
                                      area,
                                    ),
                                    icon: Icon(
                                      Icons.edit_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      size: 20,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Eliminar',
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () => _eliminarArea(
                                      context,
                                      controladorAreas,
                                      area,
                                    ),
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: ColoresAplicacion.peligro,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}
