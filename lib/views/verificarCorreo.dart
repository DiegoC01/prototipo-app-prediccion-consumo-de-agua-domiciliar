import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/rutas.dart';

class VerificarCorreo extends StatefulWidget {
  const VerificarCorreo({super.key});

  @override
  State<VerificarCorreo> createState() => _VerificarCorreoState();
}

class _VerificarCorreoState extends State<VerificarCorreo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
          children: [
            const Text('Verifique su correo electrónico por favor. Se le ha enviado un correo de verificación a su correo.'),
            TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                print(user);
                Navigator.of(context).pushNamedAndRemoveUntil(
                                rutaLogin,
                                (route) => false,
                            );
              },
              child: const Text('Verificar correo'),
            )
          ],
      ),
    );
  }
}
