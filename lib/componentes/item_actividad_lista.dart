import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../modelos/modelo_actividad.dart';
import '../modelos/modelo_area.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/decoraciones_aplicacion.dart';
import '../temas/estilos_texto_aplicacion.dart';
import '../utilidades/mapeador_iconos_area.dart';
import '../utilidades/utilidad_color.dart';
import '../utilidades/utilidad_prioridad.dart';

class ItemActividadLista extends StatelessWidget {
  const ItemActividadLista({
    super.key,
    required this.actividad,
    required this.area,
    required this.alAlternar,
    this.alEditar,
    this.alEliminar,
    this.mostrarAcciones = true,
  });

  final ActividadModelo actividad;
  final AreaModelo area;
  final VoidCallback alAlternar;
  final VoidCallback? alEditar;
  final VoidCallback? alEliminar;
  final bool mostrarAcciones;

  @override
  Widget build(BuildContext context) {
    final hora = DateFormat.Hm().format(actividad.momentoAgendado);
    final subtitulo =
        '${area.nombre} · $hora · ${actividad.duracionMinutos.round()}min';
    final colorArea = colorDesdeHex(area.colorHex);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(DecoracionesAplicacion.radioTarjeta),
        onTap: alAlternar,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: DecoracionesAplicacion.tarjetaElevada(),
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: alAlternar,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: actividad.completada
                        ? ColoresAplicacion.azulPrincipal
                        : Colors.transparent,
                    border: Border.all(
                      color: actividad.completada
                          ? ColoresAplicacion.azulPrincipal
                          : ColoresAplicacion.bordeSutil,
                      width: 2,
                    ),
                  ),
                  child: actividad.completada
                      ? const Icon(Icons.check_rounded,
                          size: 18, color: ColoresAplicacion.blanco)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorArea.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconoDesdeClave(area.icono),
                  color: colorArea,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: EstilosTextoAplicacion.tituloTarjeta.copyWith(
                        decoration: actividad.completada
                            ? TextDecoration.lineThrough
                            : null,
                        color: actividad.completada
                            ? ColoresAplicacion.grisMedio
                            : ColoresAplicacion.grisOscuro,
                      ),
                      child: Text(actividad.titulo),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitulo,
                        style: EstilosTextoAplicacion.cuerpoSecundario),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    etiquetaPrioridadCadena(actividad.prioridad),
                    style: TextStyle(
                      color: colorPrioridadCadena(actividad.prioridad),
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                  if (mostrarAcciones) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: alEditar,
                          icon: const Icon(Icons.edit_rounded,
                              size: 20, color: ColoresAplicacion.grisMedio),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: alEliminar,
                          icon: const Icon(Icons.delete_outline_rounded,
                              size: 20, color: ColoresAplicacion.grisMedio),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
