import 'package:dia_a_dia/aplicacion.dart';
import 'package:dia_a_dia/controladores/controlador_actividades.dart';
import 'package:dia_a_dia/controladores/controlador_areas.dart';
import 'package:dia_a_dia/controladores/controlador_seleccion_temporal.dart';
import 'package:dia_a_dia/controladores/controlador_usuario.dart';
import 'package:dia_a_dia/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ControladorUsuario()),
        ChangeNotifierProvider(create: (_) => ControladorSeleccionTemporal()),
        ChangeNotifierProvider(create: (_) => ControladorAreas()),
        ChangeNotifierProvider(create: (_) => ControladorActividades()),
      ],
      child: const AplicacionDiaADia(),
    ),
  );
}
