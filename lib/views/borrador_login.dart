import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/rutas.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'dart:developer' as devtools show log;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              
              Container(
                width: 272,
                child: Column(
                  children: [
                    // LOGO
                    SizedBox(height: 100),
                    Container(
                      width: 191,
                      height: 191,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/app_logo.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Título de inicio de sesión
                    const Text(
                      'Inicio de sesión',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                        height: 0.03,
                        letterSpacing: 0.15,
                      ),
                    ),
                    SizedBox(height: 25),

                    TextFormField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Correo electrónico",
                      ),
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    SizedBox(height: 15),

                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: "Contraseña",
                      ),
                    ),
                    SizedBox(height: 25),

                    // Botón de ingreso al prototipo
                    ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xff40a0c9),
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Lato',
                            ),
                          ),
                          onPressed: () async {
                            // Lo que se hará después de apretar el botón.
                            final email = _email.text;
                            final password = _password.text;
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email, password: password);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                rutaInicio,
                                (route) => false,
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                devtools.log("No se ha encontrado al usuario");
                              } else if (e.code == 'wrong-password') {
                                devtools.log("Contraseña incorrecta");
                              } else {
                                devtools
                                    .log('Error al momento de iniciar sesión');
                                print(e.code);
                                await mostrarDialogoDeError(
                                  context,
                                  'Error al ingresar las credenciales',
                                );
                              }
                            }
                          },
                          child: const Text('INGRESAR'),
                        ),
                    SizedBox(height: 50),

                    /*
                    // Sugerencia de iniciar sesión con otros servicios
                    const Text(
                      'O inicia sesión con',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                        height: 0.09,
                        letterSpacing: 0.15,
                      ),
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.facebook,
                            size: 40,
                            color: Color(0xFF40a0c9),
                          ),
                          tooltip: 'Inicia sesión con facebook',
                          onPressed: () {
                            print('No hay na');
                          },
                        ),
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.google,
                            size: 40,
                            color: Color(0xFF40a0c9),
                          ),
                          tooltip: 'Inicia sesión con Gmail',
                          onPressed: () {
                            print('No hay na');
                          },
                        ),
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.microsoft,
                            size: 40,
                            color: Color(0xFF40a0c9),
                          ),
                          tooltip: 'Inicia sesión con Microsoft',
                          onPressed: () {
                            print('No hay na');
                          },
                        ),
                      ],
                    ),*/

                    SizedBox(height: 50),

                    // Pregunta: tienes una cuenta?
                    const Text(
                      '¿No tienes una cuenta?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Andika',
                        fontWeight: FontWeight.w400,
                        height: 0.09,
                        letterSpacing: 0.15,
                      ),
                    ),
                    SizedBox(height: 10),

                    // Botón de registro
                    SizedBox(
                      width: 162,
                      height: 30,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xff40a0c9),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Lato',
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            rutaRegister,
                            (route) => false,
                          );
                        },
                        child: const Text('REGISTRATE'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> mostrarDialogoDeError(
    BuildContext context, 
    String text, 
) {

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Un error ocurrió'),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          )
        ],
      );
  });

}
