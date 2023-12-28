import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
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
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: SingleChildScrollView(
        child: Column(
            // En esta columa se deja el formulario de registro
            children: [
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
              TextFormField(
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
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
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
                      devtools.log('Error al momento de iniciar sesión');
                      devtools.log(e.code);
                    }
                  }
                },
                child: const Text(
                  'Ingresar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 18,
                  ),
                ),
              ),
              CupertinoButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    rutaRegister,
                    (route) => false,
                  );
                },
                child: const Text('Si no está registrado, regístrate aquí!'),
              ),
            ]),
      ),
    );
  }
}
