import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Metas extends StatefulWidget {
  const Metas({super.key});

  @override
  State<Metas> createState() => _MetasState();
}

class _MetasState extends State<Metas> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        //body: Text('estas'),
        body: Column(
          children: [
            // Título de la sección
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 40.0),
                child: Text(
                  'Mis metas de ahorro',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 35.0, // Puedes ajustar el tamaño de la fuente según tus preferencias
                  ),
                ),
              ),
            ),

            // Botón de estadísticas
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: ElevatedButton(
                  onPressed: (){

                  }, 
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: const Color(0xFF40a0c9), // Color del texto del botón
                    elevation: 3, // Sombra del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Padding interno
                  ),
                  child: Container(
                    width: 150.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.eye,
                          color: Colors.white,
                          size: 15,
                        ), // Agrega aquí el icono que desees
                        const SizedBox(width: 8.0), // Espaciado entre el icono y el texto
                        const Text(
                          'VER ESTADÍSTICAS',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 15,                        ),
                        ),
                      ],
                    ),
                  ),
                )
              ),
            ),

            // Contenido de las pestañas
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top:35.0),
                child: TabBarView(
                  children: [
                    // Contenido de la pestaña 'Diarias'
                    _buildTabContent('Diarias'),
                    // Contenido de la pestaña 'Semanales'
                    _buildTabContent('Semanales'),
                    // Contenido de la pestaña 'Mensuales'
                    _buildTabContent('Mensuales'),
                    // Contenido de la pestaña 'Anuales'
                    _buildTabContent('Anuales'),
                  ],
                ),
              ),
            ),

          ]
        ),

        // Tabs con tipo de consumo
        bottomNavigationBar:
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: const TabBar(
                labelStyle: TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xFF40a0c9),
                  // Otros estilos de texto según tus preferencias
                ),
                indicatorColor: Color(0xFF40a0c9),
                dividerColor: Colors.transparent,
                tabs: <Widget>[
                  Tab(
                    text: 'Diarias',
                  ),
                  Tab(
                    text: 'Semanales',
                  ),
                  Tab(
                    text: 'Mensuales',
                  ),
                  Tab(
                    text: 'Anuales',
                  ),
                ],
              ),
          ),
      ),
    );
  }
}

Widget _buildTabContent(String tabTitle) {
  // Puedes personalizar el contenido de cada pestaña aquí
  return Column(
    children: [
      _buildExampleCard(title: '$tabTitle - Meta 1'),
      _buildExampleCard(title: '$tabTitle - Meta 2'),
      // Agrega más tarjetas según sea necesario
    ],
  );
}

// Widget para construir tarjetas
//_buildExampleCard(title: 'Gallones', formattedDate: '12-05-2023', firstIcon: Icons.favorite, secondIcon: Icons.check),
Widget _buildExampleCard({
  String title = 'Litros',
  String formattedDate = '11-11-2023',
  IconData firstIcon = FontAwesomeIcons.penToSquare,
  IconData secondIcon = FontAwesomeIcons.trash,
}) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
    child: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          // Fecha del día de hoy en formato "dd-mm-yyyy" o la fecha proporcionada
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                formattedDate ?? '17-11-2023',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          // Texto grande que dice "Litros" o el título proporcionado
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Iconos en la esquina inferior derecha
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  firstIcon,
                  color: const Color(0xFF40a0c9),
                  size: 18,
                ),
                const SizedBox(width: 8.0),
                Icon(
                  secondIcon,
                  color: const Color(0xFF40a0c9),
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
