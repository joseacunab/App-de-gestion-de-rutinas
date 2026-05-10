import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../componentes/barra_aplicacion_personalizada.dart';
import '../controladores/controlador_actividades.dart';
import '../controladores/controlador_areas.dart';
import '../controladores/controlador_usuario.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/decoraciones_aplicacion.dart';
import '../temas/estilos_texto_aplicacion.dart';

/// Ajustes de perfil y preferencias.
class PantallaConfiguracion extends StatelessWidget {
  const PantallaConfiguracion({super.key});

  @override
  Widget build(BuildContext context) {
    final controladorUsuario = context.watch<ControladorUsuario>();
    final usuario = controladorUsuario.usuario;

    final nombreCompleto = usuario == null
        ? ''
        : '${usuario.nombre} ${usuario.apellido}'.trim();
    final nombreMostrar =
        usuario == null ? 'Tu perfil' : (nombreCompleto.isEmpty ? usuario.correo : nombreCompleto);

    final subtituloPerfil = usuario?.correo ?? 'Día a Día';

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(
          child: BarraAplicacionPersonalizada(
            titulo: 'Configuración',
            subtitulo: 'Personaliza tu experiencia',
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          sliver: SliverList.list(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: DecoracionesAplicacion.tarjetaElevada(),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: ColoresAplicacion.azulClaro,
                      child: const Icon(Icons.person_rounded, color: ColoresAplicacion.azulPrincipal, size: 30),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nombreMostrar, style: EstilosTextoAplicacion.tituloTarjeta),
                          Text(
                            subtituloPerfil,
                            style: EstilosTextoAplicacion.cuerpoSecundario,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _FilaInterruptor(
                titulo: 'Modo oscuro',
                subtitulo: 'Tema de la aplicación',
                valor: controladorUsuario.modoOscuro,
                alCambiar: (v) => controladorUsuario.establecerModoOscuro(v),
              ),
              const SizedBox(height: 10),
              _FilaInterruptor(
                titulo: 'Notificaciones',
                subtitulo: 'Recordatorios de actividades',
                valor: usuario?.notificaciones ?? true,
                alCambiar:
                    controladorUsuario.usuarioAuth != null ? (v) => controladorUsuario.establecerNotificaciones(v) : null,
              ),
              const SizedBox(height: 18),
              Material(
                color: ColoresAplicacion.blanco,
                borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioTarjeta),
                child: InkWell(
                  borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioTarjeta),
                  onTap: () async {
                    context.read<ControladorActividades>().desvincularUsuario();
                    context.read<ControladorAreas>().desvincularUsuario();
                    await context.read<ControladorUsuario>().cerrarSesion();
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (ruta) => false);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(DecoracionesAplicacion.radioTarjeta),
                      border: Border.all(color: ColoresAplicacion.bordeSutil),
                    ),
                    child: const Text(
                      'Cerrar sesión',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColoresAplicacion.peligro,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilaInterruptor extends StatelessWidget {
  const _FilaInterruptor({
    required this.titulo,
    required this.subtitulo,
    required this.valor,
    this.alCambiar,
  });

  final String titulo;
  final String subtitulo;
  final bool valor;
  final ValueChanged<bool>? alCambiar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: DecoracionesAplicacion.tarjetaElevada(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: EstilosTextoAplicacion.tituloTarjeta),
                Text(subtitulo, style: EstilosTextoAplicacion.cuerpoSecundario),
              ],
            ),
          ),
          Switch.adaptive(
            value: valor,
            onChanged: alCambiar,
          ),
        ],
      ),
    );
  }
}
