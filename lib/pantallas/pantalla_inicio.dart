import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../componentes/barra_aplicacion_personalizada.dart';
import '../componentes/modal_nueva_actividad.dart';
import '../componentes/item_actividad_lista.dart';
import '../componentes/tarjeta_progreso_diario.dart';
import '../componentes/tarjeta_proxima_actividad.dart';
import '../controladores/controlador_actividades.dart';
import '../controladores/controlador_areas.dart';
import '../controladores/controlador_seleccion_temporal.dart';
import '../controladores/controlador_usuario.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/estilos_texto_aplicacion.dart';
import '../utilidades/utilidad_consultas_actividad.dart' as consultas;

/// Pantalla principal con progreso, próxima actividad y lista del día.
class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  String _saludo() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Buenos días';
    if (h < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  String _tituloUsuario(ControladorUsuario cu) {
    final u = cu.usuario;
    if (u == null || (u.nombre.isEmpty && u.apellido.isEmpty))
      return 'Día a Día';
    return '${u.nombre} ${u.apellido}'.trim();
  }

  @override
  Widget build(BuildContext context) {
    final controladorUsuario = context.watch<ControladorUsuario>();
    final controladorAreas = context.watch<ControladorAreas>();
    final controladorActividades = context.watch<ControladorActividades>();
    // Reconstruye al cambiar el día (reloj) aunque solo usemos actividades de “hoy” calendario.
    context.watch<ControladorSeleccionTemporal>();

    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final actividades = controladorActividades.actividades;
    final (total, hechas, pct) = consultas.resumenProgresoDia(actividades, hoy);
    final progreso = total == 0 ? 0.0 : hechas / total;
    final lista = consultas.actividadesDelDia(actividades, hoy);
    final proxima = consultas.proximaActividadPendiente(actividades, hoy);
    final uid = controladorUsuario.usuarioAuth?.uid;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: BarraAplicacionPersonalizada(
            estilo: EstiloEncabezadoBarra.saludoArriba,
            titulo: _tituloUsuario(controladorUsuario),
            subtitulo: _saludo(),
            acciones: [
              _BotonFlotanteCompacto(
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
                    await controladorActividades.crearActividad(r.actividad);
                  }
                },
              ),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          sliver: SliverList.list(
            children: [
              TarjetaProgresoDiario(
                porcentaje: pct,
                textoResumen: '$hechas de $total actividades completadas',
                progreso: progreso,
              ),
              const SizedBox(height: 20),
              Text('PRÓXIMA ACTIVIDAD',
                  style: EstilosTextoAplicacion.etiquetaSeccion),
              const SizedBox(height: 10),
              if (proxima != null &&
                  controladorAreas.areaPorId(proxima.areaId) != null)
                TarjetaProximaActividad(
                  actividad: proxima,
                  area: controladorAreas.areaPorId(proxima.areaId)!,
                )
              else
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: ColoresAplicacion.blanco,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: ColoresAplicacion.bordeSutil),
                  ),
                  child: Text(
                    'No hay actividades pendientes hoy.',
                    style: EstilosTextoAplicacion.cuerpoSecundario,
                  ),
                ),
              const SizedBox(height: 22),
              Text('HOY', style: EstilosTextoAplicacion.etiquetaSeccion),
              const SizedBox(height: 10),
              //Aca muestro si no hay datos un mensaje
              if (lista.isEmpty)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: ColoresAplicacion.blanco,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: ColoresAplicacion.bordeSutil),
                  ),
                  child: Text(
                    'No tenés tareas para hoy.',
                    style: EstilosTextoAplicacion.cuerpoSecundario,
                  ),
                ),
            ],
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
                mostrarAcciones: true,
              );
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _BotonFlotanteCompacto extends StatelessWidget {
  const _BotonFlotanteCompacto({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Material(
        color: ColoresAplicacion.azulPrincipal,
        shape: const CircleBorder(),
        elevation: 6,
        shadowColor: ColoresAplicacion.azulPrincipal.withValues(alpha: 0.45),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: const SizedBox(
            width: 48,
            height: 48,
            child: Icon(Icons.add_rounded, color: ColoresAplicacion.blanco),
          ),
        ),
      ),
    );
  }
}
