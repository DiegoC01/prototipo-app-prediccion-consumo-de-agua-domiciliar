import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'dart:developer' as devtools show log;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
                appBar: AppBar(
                  title: const Text('Registro'),
                ),
                body: SingleChildScrollView(
                  child: Column(
                  // En esta columa se deja el formulario de registro
                    children: [
                      TextField(
                        controller: _email,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Correo electrónico",
                        ),
                      ),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          hintText: "Contraseña",
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Lo que se hará después de apretar el botón.
                          final email = _email.text;
                          final password = _password.text;
                  
                          try {
                            final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: email, 
                              password: password
                            );
                            //devtools.log(userCredential.toString());
                          }
                          on FirebaseAuthException catch(e) {
                            devtools.log(e.code);
                            if(e.code == 'weak-password'){
                              devtools.log("Contraseña muy débil");
                            }
                            else if(e.code == 'email-already-in-use'){
                              devtools.log("El correo ingresado ya está en uso");
                            }
                            else if(e.code == 'invalid-email'){
                              devtools.log("El correo ingresado es inválido");
                            }
                          }
                        },
                        child: const Text('Registrate'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login/',
                            (route) => false,
                          );
                        },
                        child: const Text('Si ya tienes una cuenta, ingresa aquí'),
                      )
                    ]
                  ),
                ),
              );
  }
}



