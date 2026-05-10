import 'package:dia_a_dia/controladores/controlador_actividades.dart';
import 'package:dia_a_dia/controladores/controlador_areas.dart';
import 'package:dia_a_dia/controladores/controlador_usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../componentes/boton_primario.dart';
import '../componentes/campo_texto_autenticacion.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/decoraciones_aplicacion.dart';
import '../temas/estilos_texto_aplicacion.dart';
import '../utilidades/utilidad_validacion_formulario.dart';

/// Acceso con correo y contraseña (demo sin backend).
class PantallaInicioSesion extends StatefulWidget {
  const PantallaInicioSesion({super.key});

  @override
  State<PantallaInicioSesion> createState() => _PantallaInicioSesionState();
}

class _PantallaInicioSesionState extends State<PantallaInicioSesion> {
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _contrasena = TextEditingController();

  String? _errorCorreo;
  String? _errorContrasena;

  @override
  void dispose() {
    _correo.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  void _intentarIngresar() async {
    final textoCorreo = _correo.text.trim();
    final textoContrasena = _contrasena.text;

    setState(() {
      _errorCorreo =
          textoCorreo.isEmpty ? 'Introduce tu correo electrónico.' : null;
      _errorContrasena =
          textoContrasena.isEmpty ? 'Introduce tu contraseña.' : null;
    });

    if (_errorCorreo != null || _errorContrasena != null) return;

    if (!correoTieneFormatoValido(textoCorreo)) {
      setState(() => _errorCorreo = 'El correo no tiene un formato válido.');
      return;
    }

    if (!contrasenaCumpleMinimo(textoContrasena)) {
      setState(() =>
          _errorContrasena = 'La contraseña debe tener al menos 6 caracteres.');
      return;
    }

    final controladorUsuario =
        Provider.of<ControladorUsuario>(context, listen: false);

    final exito = await controladorUsuario.iniciarSesion(
      correo: textoCorreo,
      contrasena: textoContrasena,
    );

    if (!mounted) return;

    if (exito) {
      final auth = controladorUsuario.usuarioAuth;
      if (auth != null) {
        context.read<ControladorAreas>().vincularUsuario(auth.uid);
        context.read<ControladorActividades>().vincularUsuario(auth.uid);
      }
      Navigator.of(context).pushReplacementNamed('/principal');
    } else {
      setState(() {
        _errorContrasena =
            controladorUsuario.error ?? 'Error al iniciar sesión';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresAplicacion.grisClaro,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Día a Día',
                    textAlign: TextAlign.center,
                    style: EstilosTextoAplicacion.tituloPantalla
                        .copyWith(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Organiza tu día con claridad',
                    textAlign: TextAlign.center,
                    style: EstilosTextoAplicacion.cuerpoSecundario,
                  ),
                  const SizedBox(height: 36),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: DecoracionesAplicacion.tarjetaElevada(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Iniciar sesión',
                          style: EstilosTextoAplicacion.tituloTarjeta
                              .copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 22),
                        CampoTextoAutenticacion(
                          etiqueta: 'Correo electrónico',
                          controlador: _correo,
                          placeholder: 'tu@correo.com',
                          textoError: _errorCorreo,
                          teclado: TextInputType.emailAddress,
                          autocompletar: TextInputAction.next,
                        ),
                        const SizedBox(height: 18),
                        CampoTextoAutenticacion(
                          etiqueta: 'Contraseña',
                          controlador: _contrasena,
                          placeholder: '••••••••',
                          textoError: _errorContrasena,
                          ocultarTexto: true,
                          autocompletar: TextInputAction.done,
                        ),
                        const SizedBox(height: 26),
                        BotonPrimario(
                          etiqueta: 'Ingresar',
                          alExpandirse: true,
                          onPresionado: _intentarIngresar,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        '¿No tienes cuenta? ',
                        style: EstilosTextoAplicacion.cuerpoSecundario,
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).pushNamed('/registro'),
                        child: Text(
                          'Crear usuario',
                          style: EstilosTextoAplicacion.cuerpo.copyWith(
                            color: ColoresAplicacion.azulPrincipal,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
