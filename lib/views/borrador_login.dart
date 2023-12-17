import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/rutas.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'dart:developer' as devtools show log;

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
      body: Column(
        children: [
          Container(
            //width: 360,
            height: 800,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(color: Colors.white),
            child: Stack(
              children: [
                Positioned(
                  left: 43,
                  top: 321,
                  child: Container(
                    width: 272,
                    height: 50,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: const ShapeDecoration(
                            color: Color(0x14212121),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 15,
                                  child: TextFormField(
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 43,
                  top: 380,
                  child: SizedBox(
                    width: 272,
                    //height: 50,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: const ShapeDecoration(
                            color: Color(0x14212121),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 15,
                                  child: TextFormField(
                                    controller: _password,
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    decoration: const InputDecoration(
                                      hintText: "Contraseña",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  left: 63,
                  top: 271,
                  child: SizedBox(
                    width: 235,
                    //height: 89,
                    child: Text(
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
                  ),
                ),
                const Positioned(
                  left: 75,
                  top: 578,
                  child: SizedBox(
                    width: 235,
                    height: 89,
                    child: Text(
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
                  ),
                ),
                const Positioned(
                    left: 125,
                    top: 687,
                    child: Center(
                      child: Text(
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
                    )),
                const Positioned(
                  left: 59,
                  top: 447,
                  child: SizedBox(
                    width: 162,
                    height: 23,
                    child: Text(
                      'Olvidé mi contraseña',
                      style: TextStyle(
                        color: Color(0xFF196B8E),
                        fontSize: 14,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                        height: 0.12,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 115,
                  top: 700,
                  child: SizedBox(
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
                ),
                Positioned(
                  left: 62,
                  top: 478,
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 3,
                          top: 3,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://via.placeholder.com/18x18"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 3,
                          top: 3,
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "https://via.placeholder.com/18x18"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: -3,
                                  top: -3,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.black
                                          .withOpacity(0.6000000238418579),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  left: 86,
                  top: 482,
                  child: SizedBox(
                    width: 130,
                    height: 16,
                    child: Text(
                      'Recordar',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                        height: 0.12,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 133,
                  top: 510,
                  child: Container(
                    child: SizedBox(
                      height: 30,
                      child: ElevatedButton(
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
                              devtools.log(e.code);
                            }
                          }
                        },
                        child: const Text('INGRESAR'),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 87,
                  top: 60,
                  child: Container(
                    width: 191,
                    height: 191,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/app_logo.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
