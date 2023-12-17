import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            const Text('Verifique su correo electrónico por favor'),
            TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                print(user);
              },
              child: const Text('Verificar correo'),
            )
          ],
      ),
    );
  }
}
