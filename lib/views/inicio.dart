import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/rutas.dart';
import 'package:flutter_application_1/views/alertas.dart';
import 'package:flutter_application_1/views/consumo_actual.dart';
import 'package:flutter_application_1/views/metas.dart';
import 'package:flutter_application_1/views/predicciones.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';


class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

enum MenuAction { logout }

class _InicioState extends State<Inicio> {
  int currentPageIndex = 0;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio', style: TextStyle(fontFamily: 'Lato')),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  // TODO: Handle this case.
                  final deberiaCerrarSesion =
                      await mostrarDialogoDeCierreSesion(context);
                  if (deberiaCerrarSesion) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      rutaLogin,
                      (route) => false,
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Cerrar sesión'))
              ];
            },
          )
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (Set<MaterialState> states) =>
                states.contains(MaterialState.selected)
                    ? const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lato',
                      )
                    : const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lato',
                      ),
          ),
        ),
        child: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          backgroundColor: const Color(0xFF75d7e6),
          indicatorColor: const Color(0xFF40a0c9),
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            // Inicio Nav
            NavigationDestination(
              selectedIcon: FaIcon(
                FontAwesomeIcons.houseChimney,
                color: Colors.white,
              ),
              icon: FaIcon(
                FontAwesomeIcons.houseChimney,
                color: Colors.white,
              ),
              label: 'Inicio',
            ),
            
            // Predicciones Nav
            NavigationDestination(
              selectedIcon: FaIcon(
                FontAwesomeIcons.chartLine,
                color: Colors.white,
              ),
              icon: FaIcon(
                FontAwesomeIcons.chartLine,
                color: Colors.white,
              ),
              label: 'Predicciones',
            ),

            // Metas Nav
            NavigationDestination(
              selectedIcon: FaIcon(
                FontAwesomeIcons.flag,
                color: Colors.white,
              ),
              icon: FaIcon(
                FontAwesomeIcons.flag,
                color: Colors.white,
              ),
              label: 'Metas',
            ),

            // Alertas Nav
            NavigationDestination(
              selectedIcon: FaIcon(
                FontAwesomeIcons.triangleExclamation,
                color: Colors.white,
              ),
              icon: FaIcon(
                FontAwesomeIcons.triangleExclamation,
                color: Colors.white,
              ),
              label: 'Alertas',
            ),
          ],
        ),
      ),
      body: <Widget>[
        const ConsumoAgua(),
        const Predicciones(),
        const Metas(),
        const Alertas(),
      ][currentPageIndex],
    );
  }
}

Future<bool> mostrarDialogoDeCierreSesion(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Cerrar sesión'))
        ],
      );
    },
  ).then((value) => value ?? false);
}
