import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../componentes/barra_aplicacion_personalizada.dart';
import '../componentes/modal_hoja_inferior.dart';
import '../componentes/modal_nueva_area.dart';
import '../componentes/tarjeta_area_lista.dart';
import '../controladores/controlador_actividades.dart';
import '../controladores/controlador_areas.dart';
import '../controladores/controlador_usuario.dart';
import '../temas/colores_aplicacion.dart';
import 'pantalla_detalle_area.dart';

/// Listado de áreas con FAB y modales de alta/edición.
class PantallaAreas extends StatelessWidget {
  const PantallaAreas({super.key});

  @override
  Widget build(BuildContext context) {
    final controladorAreas = context.watch<ControladorAreas>();
    final controladorActividades = context.watch<ControladorActividades>();
    final uid = context.watch<ControladorUsuario>().usuarioAuth?.uid;
    final areas = controladorAreas.areas;

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
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          sliver: SliverList.separated(
            itemCount: areas.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final a = areas[i];
              final (pend, pct) = controladorAreas.resumenArea(
                  a.id, controladorActividades.actividades);
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
