//import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/rutas.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/views/inicio.dart';
import 'package:flutter_application_1/views/borrador_login.dart';
import 'package:flutter_application_1/views/borrador_register.dart';
import 'package:flutter_application_1/views/verificarCorreo.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:developer' as devtools show log;

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      title: 'Prototipo App Agua',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('es', ''), // Spanish
      ],
      theme: ThemeData(
            appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF75d7e6),
            foregroundColor: Colors.white, //here you can give the text color
            shadowColor: Color(0xFF40a0c9),
            surfaceTintColor: Color(0xFF40a0c9),
            ),
      ),
      home: const HomePage(),
      routes: {
        rutaLogin: (context) => const Login(),
        rutaRegister: (context) => const Register(),
        rutaInicio: (context) => const Inicio(),
      },
    ),
  );
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

@override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
                    options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.done:
              // TODO: Handle this case.
              final user = FirebaseAuth.instance.currentUser;
              if(user != null){
                if(user.emailVerified){
                  devtools.log('El correo está verificado');
                  return const Inicio();
                }
                else{
                  return const VerificarCorreo();
                }
              }
              else{
                return const Login();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      );
  }
}

Future<bool> mostrarDialogoDeCierreSesion(BuildContext context){
  return showDialog<bool>(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop(false);
          }, 
          child: const Text('Cancelar')),
          TextButton(onPressed: () {
            Navigator.of(context).pop(true);
          }, 
          child: const Text('Cerrar sesión'))
        ],
      );
    },
  ).then((value) => value ?? false);
}

