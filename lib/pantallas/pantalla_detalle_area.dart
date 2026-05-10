import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../componentes/barra_aplicacion_personalizada.dart';
import '../componentes/item_actividad_lista.dart';
import '../componentes/modal_hoja_inferior.dart';
import '../componentes/modal_nueva_actividad.dart';
import '../componentes/modal_nueva_area.dart';
import '../componentes/tarjeta_resumen_area.dart';
import '../controladores/controlador_actividades.dart';
import '../controladores/controlador_areas.dart';
import '../controladores/controlador_usuario.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/estilos_texto_aplicacion.dart';
import '../utilidades/utilidad_consultas_actividad.dart' as consultas;

/// Detalle de un área: resumen, lista y CRUD de actividades.
class PantallaDetalleArea extends StatelessWidget {
  const PantallaDetalleArea({super.key, required this.idArea});

  final String idArea;

  @override
  Widget build(BuildContext context) {
    final controladorAreas = context.watch<ControladorAreas>();
    final controladorActividades = context.watch<ControladorActividades>();
    final uid = context.watch<ControladorUsuario>().usuarioAuth?.uid;

    final area = controladorAreas.areaPorId(idArea);
    if (area == null) {
      return const Scaffold(body: Center(child: Text('Área no encontrada')));
    }

    final actividades = consultas.actividadesPorArea(controladorActividades.actividades, idArea);
    final total = actividades.length;
    final hechas = actividades.where((t) => t.completada).length;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: BarraAplicacionPersonalizada(
              titulo: area.nombre,
              subtitulo: area.descripcion.isEmpty ? null : area.descripcion,
              alRetroceder: () => Navigator.of(context).pop(),
              acciones: [
                IconButton(
                  onPressed: () async {
                    final r = await mostrarModalHojaInferior<ResultadoModalArea>(
                      context: context,
                      contenido: (_) => ModalNuevaArea(areaExistente: area),
                    );
                    if (r == null || !context.mounted) return;
                    await controladorAreas.actualizarArea(r.area);
                  },
                  icon: const Icon(Icons.edit_rounded, color: ColoresAplicacion.grisOscuro),
                ),
                IconButton(
                  onPressed: () async {
                    await controladorAreas.eliminarArea(idArea);
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.delete_outline_rounded, color: ColoresAplicacion.peligro),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            sliver: SliverList.list(
              children: [
                TarjetaResumenArea(
                  area: area,
                  totalActividades: total,
                  completadas: hechas,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text('ACTIVIDADES', style: EstilosTextoAplicacion.etiquetaSeccion),
                    const Spacer(),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: ColoresAplicacion.azulPrincipal,
                        foregroundColor: ColoresAplicacion.blanco,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () async {
                        if (uid == null) return;
                        final r = await mostrarModalNuevaActividad(
                          context,
                          areas: controladorAreas.areas,
                          idAreaPreseleccionada: idArea,
                          usuarioId: uid,
                        );
                        if (r == null || !context.mounted) return;
                        await controladorActividades.crearActividad(r.actividad);
                      },
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: const Text('Agregar', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList.separated(
              itemCount: actividades.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final t = actividades[i];
                return ItemActividadLista(
                  actividad: t,
                  area: area,
                  alAlternar: () => controladorActividades.alternarCompletada(t.id, !t.completada),
                  alEditar: () async {
                    if (uid == null) return;
                    final r = await mostrarModalNuevaActividad(
                      context,
                      areas: controladorAreas.areas,
                      existente: t,
                      usuarioId: uid,
                    );
                    if (r == null || !context.mounted) return;
                    await controladorActividades.actualizarActividad(r.actividad);
                  },
                  alEliminar: () => controladorActividades.eliminarActividad(t.id),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
