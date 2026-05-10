import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../componentes/barra_aplicacion_personalizada.dart';
import '../componentes/item_actividad_lista.dart';
import '../componentes/modal_nueva_actividad.dart';
import '../componentes/selector_fecha_global.dart';
import '../controladores/controlador_actividades.dart';
import '../controladores/controlador_areas.dart';
import '../controladores/controlador_usuario.dart';
import '../dominio/enumeracion_rango_temporal.dart';
import '../temas/colores_aplicacion.dart';
import '../utilidades/utilidad_consultas_actividad.dart' as consultas;
import '../utilidades/utilidad_fecha.dart';

/// Lista global de actividades con selector de fecha reutilizable.
class PantallaTareas extends StatefulWidget {
  const PantallaTareas({super.key});

  @override
  State<PantallaTareas> createState() => _PantallaTareasState();
}

class _PantallaTareasState extends State<PantallaTareas> {
  EnumeracionRangoTemporal _modo = EnumeracionRangoTemporal.dia;
  DateTime _referencia = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final controladorActividades = context.watch<ControladorActividades>();
    final controladorAreas = context.watch<ControladorAreas>();
    final uid = context.watch<ControladorUsuario>().usuarioAuth?.uid;

    final (ini, fin) = rangoParaReferencia(_referencia, _modo);
    final lista = consultas.actividadesEnRango(controladorActividades.actividades, ini, fin);

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
                  shadowColor: ColoresAplicacion.azulPrincipal.withValues(alpha: 0.4),
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
                        await controladorActividades.actualizarActividad(r.actividad);
                      } else {
                        await controladorActividades.crearActividad(r.actividad);
                      }
                    },
                    child: const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(Icons.add_rounded, color: ColoresAplicacion.blanco),
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
              modo: _modo,
              referencia: _referencia,
              alCambiarModo: (m) => setState(() => _modo = m),
              alAnterior: () => setState(() {
                _referencia = desplazarReferencia(_referencia, _modo, -1);
              }),
              alSiguiente: () => setState(() {
                _referencia = desplazarReferencia(_referencia, _modo, 1);
              }),
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
    );
  }
}
