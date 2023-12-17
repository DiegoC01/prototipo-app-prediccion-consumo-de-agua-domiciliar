import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/rutas.dart';
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
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];

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
        // Ejemplo Gráfico
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                'Bienvenido Usuario',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 20,
                  color: Colors.black,
                ) 
              ),
              Card(
                  child: Column(
                    children: [
                        SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            // Chart title
                            title: ChartTitle(
                              text: 'Consumo de agua del presente día',
                              textStyle: TextStyle(
                                fontFamily: 'Lato',
                                color: Colors.black,
                              ),
                            ),
                            // Enable legend
                            //legend: Legend(isVisible: true),
                            // Enable tooltip
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <ChartSeries<_SalesData, String>>[
                              LineSeries<_SalesData, String>(
                                  dataSource: data,
                                  xValueMapper: (_SalesData sales, _) => sales.year,
                                  yValueMapper: (_SalesData sales, _) => sales.sales,
                                  name: 'Sales',
                                  // Enable data label
                                  dataLabelSettings: DataLabelSettings(isVisible: true)
                              )
                            ]
                        ),
                        Center(
                            child: ElevatedButton.icon(
                          icon: const FaIcon(
                            FontAwesomeIcons.solidEye,
                            color: Color(0xFF40a0c9),
                          ),
                          label: const Text(
                            'VER DETALLES',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: Color(0xFF40a0c9),
                            ) 
                          ),
                          onPressed: () {
                            print('Aquí hay más detalles');
                          },
                          style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
                        )),            
                    ],
                  )
              ),
              Card(
                  child: Column(
                    children: [
                        SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            // Chart title
                            title: ChartTitle(
                              text: 'Consumo de agua del presente día',
                              textStyle: TextStyle(
                                fontFamily: 'Lato',
                                color: Colors.black,
                              ),
                            ),
                            // Enable legend
                            //legend: Legend(isVisible: true),
                            // Enable tooltip
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <ChartSeries<_SalesData, String>>[
                              LineSeries<_SalesData, String>(
                                  dataSource: data,
                                  xValueMapper: (_SalesData sales, _) => sales.year,
                                  yValueMapper: (_SalesData sales, _) => sales.sales,
                                  name: 'Sales',
                                  // Enable data label
                                  dataLabelSettings: DataLabelSettings(isVisible: true)
                              )
                            ]
                        ),
                        Center(
                            child: ElevatedButton.icon(
                          icon: const FaIcon(
                            FontAwesomeIcons.solidEye,
                            color: Color(0xFF40a0c9),
                          ),
                          label: const Text(
                            'VER DETALLES',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: Color(0xFF40a0c9),
                            ) 
                          ),
                          onPressed: () {
                            print('Aquí hay más detalles');
                          },
                          style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
                        )),            
                    ],
                  )
              ),            
            ],
          ),
        ),
      ][currentPageIndex],
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
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
