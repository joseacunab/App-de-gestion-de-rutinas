import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../componentes/barra_aplicacion_personalizada.dart';
import '../componentes/item_actividad_lista.dart';
import '../componentes/modal_nueva_actividad.dart';
import '../componentes/selector_fecha_global.dart';
import '../controladores/controlador_actividades.dart';
import '../controladores/controlador_areas.dart';
import '../controladores/controlador_seleccion_temporal.dart';
import '../controladores/controlador_usuario.dart';
import '../modelos/modelo_actividad.dart';
import '../temas/colores_aplicacion.dart';
import '../utilidades/utilidad_consultas_actividad.dart' as consultas;
import '../utilidades/utilidad_fecha.dart';

/// Lista global de actividades con selector de fecha reutilizable.
class PantallaTareas extends StatelessWidget {
  const PantallaTareas({super.key});

  @override
  Widget build(BuildContext context) {
    final controladorActividades = context.watch<ControladorActividades>();
    final controladorAreas = context.watch<ControladorAreas>();
    final temporal = context.watch<ControladorSeleccionTemporal>();
    final uid = context.watch<ControladorUsuario>().usuarioAuth?.uid;

    final (ini, fin) = rangoParaReferencia(temporal.referencia, temporal.modo);
    final lista = temporal.suprimirDatosVisuales
        ? <ActividadModelo>[]
        : consultas.actividadesEnRango(
            controladorActividades.actividades, ini, fin);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: BarraAplicacionPersonalizada(
            estilo: EstiloEncabezadoBarra.saludoArriba,
            titulo: 'Tareas',
            subtitulo: 'Todas tus tareas',
            acciones: [
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
                      final r = await mostrarModalNuevaActividad(
                        context,
                        areas: controladorAreas.areas,
                        usuarioId: uid,
                      );
                      if (r == null || !context.mounted) return;
                      if (r.esEdicion) {
                        await controladorActividades
                            .actualizarActividad(r.actividad);
                      } else {
                        await controladorActividades
                            .crearActividad(r.actividad);
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
              ),
            ],
          ),
        ),
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
        //Aca agrego un mensaje de que no hay tareas si la lista esta vacia
        if (lista.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.task_alt_rounded, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'Sin tareas en este período',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Agregá una nueva tarea con el botón +',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList.separated(
            itemCount: lista.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final t = lista[i];
              final area = controladorAreas.areaPorId(t.areaId);
              if (area == null) return const SizedBox.shrink();
              return ItemActividadLista(
                actividad: t,
                area: area,
                alAlternar: () => controladorActividades.alternarCompletada(
                    t.id, !t.completada),
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
                alEliminar: () =>
                    controladorActividades.eliminarActividad(t.id),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}
