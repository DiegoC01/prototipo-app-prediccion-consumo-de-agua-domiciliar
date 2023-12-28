import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/rutas.dart';
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
  late final TextEditingController _checkPassword;
  late final TextEditingController _nombre;

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    _checkPassword = TextEditingController();
    _nombre = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    _checkPassword.dispose();
    _nombre.dispose();
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
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/app_logo.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
        
                    // Título módulo
                    SizedBox(height: 30),
                    Text(
                      'Registro de usuario',
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
        
                    // Input nombre
                    TextField(
                      controller: _nombre,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Nombre",
                      ),
                    ),
        
                    SizedBox(height: 15),
                    //Input Correo
                    TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Correo electrónico",
                      ),
                    ),
        
                    SizedBox(height: 15),
                    //Input Contraseña
                    TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: "Contraseña",
                      ),
                    ),
        
                    SizedBox(height: 15),
                    //Input contraseña de nuevo
                    TextField(
                      controller: _checkPassword,
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Repita contraseña",
                      ),
                    ),
                    
                    SizedBox(height: 25),
                    // Botón Registro
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
                        final checkPassword = _checkPassword.text;
                        final password = _password.text;
                        
        
                        try {
                          if (checkPassword == password) {
                            final userCredential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: email, password: password);
                            print(userCredential.toString());
                            await mostrarDialogoInicioExitoso(
                              context,
                              '¡Se ha registrado exitosamente!',
                            );
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                rutaLogin,
                                (route) => false,
                            );
                          }
                          else{
                            await mostrarDialogoDeError(
                              context,
                              'Las contraseñas ingresadas no coinciden',
                            );
                          }

                        } on FirebaseAuthException catch (e) {
                          devtools.log(e.code);
                          if (e.code == 'weak-password') {
                            devtools.log("Contraseña muy débil");
                          } else if (e.code == 'email-already-in-use') {
                            devtools.log("El correo ingresado ya está en uso");
                          } else if (e.code == 'invalid-email') {
                            devtools.log("El correo ingresado es inválido");
                          }
                        }
                      },
                      child: const Text('REGISTRATE'),
                    ),
                    
                    SizedBox(height: 5),
                    //Botón vuelta al módulo anterior
                    TextButton(
                      style: TextButton.styleFrom(
                        //foregroundColor: Colors.white,
                        //backgroundColor: const Color(0xff40a0c9),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Lato',
                        ),
                      ),
                      onPressed: () async {
                        // Lo que se hará después de apretar el botón.
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          rutaLogin,
                          (route) => false,
                        );
                      },
                      child:
                          const Text('Si ya tienes una cuenta, ¡Inicia sesión aquí!'),
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

Future<void> mostrarDialogoInicioExitoso(
    BuildContext context, 
    String text, 
) {

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Registro completado'),
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


