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
class PantallaAreas extends StatelessWidget {
  const PantallaAreas({super.key});

  @override
  Widget build(BuildContext context) {
    final controladorAreas = context.watch<ControladorAreas>();
    final controladorActividades = context.watch<ControladorActividades>();
    final temporal = context.watch<ControladorSeleccionTemporal>();
    final uid = context.watch<ControladorUsuario>().usuarioAuth?.uid;
    final areas = controladorAreas.areas;

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
        //Aca muestro un mensaje si no hay datos
        if (areasVisibles.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.category_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'Sin áreas en este período',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Creá una nueva área con el botón +',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
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
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}
