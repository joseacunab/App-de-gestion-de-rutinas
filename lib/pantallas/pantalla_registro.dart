import 'package:dia_a_dia/controladores/controlador_usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../componentes/boton_primario.dart';
import '../componentes/campo_texto_autenticacion.dart';
import '../temas/colores_aplicacion.dart';
import '../temas/decoraciones_aplicacion.dart';
import '../temas/estilos_texto_aplicacion.dart';
import '../utilidades/utilidad_validacion_formulario.dart';

/// Registro con Firebase Auth + documento en `usuarios`.
class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _apellido = TextEditingController();
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _contrasena = TextEditingController();

  String? _errorNombre;
  String? _errorApellido;
  String? _errorCorreo;
  String? _errorContrasena;

  @override
  void dispose() {
    _nombre.dispose();
    _apellido.dispose();
    _correo.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  Future<void> _intentarCrearCuenta() async {
    final n = _nombre.text.trim();
    final a = _apellido.text.trim();
    final c = _correo.text.trim();
    final p = _contrasena.text;

    setState(() {
      _errorNombre = n.isEmpty ? 'Introduce tu nombre.' : null;
      _errorApellido = a.isEmpty ? 'Introduce tu apellido.' : null;
      _errorCorreo = c.isEmpty ? 'Introduce tu correo electrónico.' : null;
      _errorContrasena = p.isEmpty ? 'Introduce una contraseña.' : null;
    });

    if (_errorNombre != null ||
        _errorApellido != null ||
        _errorCorreo != null ||
        _errorContrasena != null) {
      return;
    }

    if (!correoTieneFormatoValido(c)) {
      setState(() => _errorCorreo = 'El correo no tiene un formato válido.');
      return;
    }
    if (!contrasenaCumpleMinimo(p)) {
      setState(() => _errorContrasena = 'La contraseña debe tener al menos 6 caracteres.');
      return;
    }

    final controlador = context.read<ControladorUsuario>();
    final errorRemoto = await controlador.registrarUsuario(
      nombre: n,
      apellido: a,
      correo: c,
      contrasena: p,
    );

    if (!mounted) return;

    if (errorRemoto == null) {
      Navigator.of(context).pushReplacementNamed('/');
    } else {
      setState(() => _errorCorreo = errorRemoto);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Crear cuenta',
                    style: EstilosTextoAplicacion.tituloPantalla(context).copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Completa tus datos para empezar',
                    style: EstilosTextoAplicacion.cuerpoSecundario(context),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: DecoracionesAplicacion.tarjetaElevada(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CampoTextoAutenticacion(
                          etiqueta: 'Nombre',
                          controlador: _nombre,
                          placeholder: 'Ej. María',
                          textoError: _errorNombre,
                          autocompletar: TextInputAction.next,
                        ),
                        const SizedBox(height: 18),
                        CampoTextoAutenticacion(
                          etiqueta: 'Apellido',
                          controlador: _apellido,
                          placeholder: 'Ej. García',
                          textoError: _errorApellido,
                          autocompletar: TextInputAction.next,
                        ),
                        const SizedBox(height: 18),
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
                          placeholder: 'Mínimo 6 caracteres',
                          textoError: _errorContrasena,
                          ocultarTexto: true,
                          autocompletar: TextInputAction.done,
                        ),
                        const SizedBox(height: 26),
                        BotonPrimario(
                          etiqueta: 'Crear cuenta',
                          alExpandirse: true,
                          onPresionado: _intentarCrearCuenta,
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
                        '¿Ya tienes cuenta? ',
                        style: EstilosTextoAplicacion.cuerpoSecundario(context),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          'Iniciar sesión',
                          style: EstilosTextoAplicacion.cuerpo(context).copyWith(
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
