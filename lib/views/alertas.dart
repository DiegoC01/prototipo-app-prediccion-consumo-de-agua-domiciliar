import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Alertas extends StatefulWidget {
  const Alertas({super.key});

  @override
  State<Alertas> createState() => _AlertasState();
}

class _AlertasState extends State<Alertas> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        //body: Text('estas'),
        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 40.0),
                    child: Text(
                      'Mis alertas',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 35.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 22.0),
                    child: Text(
                      'Para desactivar las notificaciones, pulse el botón a la derecha de la alerta.',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: 35.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return _buildTabContent(context);
                  },
                  childCount: 2, // Número de pestañas
                ),
              ),
            ),
          ],  
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
                dividerColor: Colors.transparent,
                indicatorColor: Color(0xFF40a0c9),
                tabs: <Widget>[
                  Tab(
                    text: 'Consumo histórico',
                  ),
                  Tab(
                    text: 'Consumo futuro',
                  ),
                ],
              ),
          ),
      ),
    );
  }
}

Widget _buildTabContent(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height, // Ajusta esto según tus necesidades
    child: TabBarView(
      children: [
        _buildTab(context),
        _buildTab(context),
        //_buildTab(context, title: tabTitle3),
        //_buildTab(context, title: tabTitle4),
      ],
    ),
  );
}


Widget _buildTab(BuildContext context) {
  return ListView.builder(
    itemCount: 4, // Número de tarjetas por pestaña
    itemBuilder: (BuildContext context, int index) {
      // Aquí utilizamos el índice para generar títulos diferentes para cada tarjeta
      var title;
      if(index == 0){
        title = 'Consumo diario';
      }
      else if(index == 1){
        title = 'Consumo semanal';
      }
      else if(index == 2){
        title = 'Consumo mensual';
      }
      else if(index == 3){
        title = 'Consumo anual';
      }
      String cardTitle = '$title';
      return _buildExampleCard(title: cardTitle);
    },
  );
}





// Widget para construir tarjetas
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
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Texto grande que dice "Litros" o el título proporcionado
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),

          SwitchAlert(),
        ],
      ),
    ),
  );
}


// Widget con el switch

class SwitchAlert extends StatefulWidget {
  const SwitchAlert({super.key});

  @override
  State<SwitchAlert> createState() => _SwitchAlertState();
}

class _SwitchAlertState extends State<SwitchAlert> {
  bool light = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Switch(
        // This bool value toggles the switch.
        value: light,
        activeColor: const Color(0xFF40a0c9),
        onChanged: (bool value) {
          // This is called when the user toggles the switch.
          setState(() {
            light = value;
          });
        },
      ),
    );
  }
}

