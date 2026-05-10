import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'controladores/controlador_usuario.dart';
import 'navegacion/envoltorio_navegacion_principal.dart';
import 'pantallas/pantalla_inicio_sesion.dart';
import 'pantallas/pantalla_registro.dart';
import 'temas/tema_aplicacion.dart';

/// Raíz de la app: temas reactivos y localización en español.
class AplicacionDiaADia extends StatelessWidget {
  const AplicacionDiaADia({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ControladorUsuario>(
      builder: (context, controladorUsuario, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Día a Día',
          theme: TemaAplicacion.claro(),
          darkTheme: TemaAplicacion.oscuro(),
          themeMode: controladorUsuario.modoOscuro ? ThemeMode.dark : ThemeMode.light,
          locale: const Locale('es'),
          supportedLocales: const [Locale('es')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: '/',
          routes: {
            '/': (_) => const PantallaInicioSesion(),
            '/registro': (_) => const PantallaRegistro(),
            '/principal': (_) => const EnvoltorioNavegacionPrincipal(),
          },
        );
      },
    );
  }
}
