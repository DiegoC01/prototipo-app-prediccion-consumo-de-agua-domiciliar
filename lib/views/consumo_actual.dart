import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

// Testing Firestore
class AguaConsumida {
  AguaConsumida({
    required this.timestamp, 
    required this.waterConsumed
  });

  final DateTime timestamp;
  final double waterConsumed;

  static AguaConsumida toJSON(Map<String, dynamic> json) => AguaConsumida(
    waterConsumed: (json['waterMeasured'] as num).toDouble(),
    timestamp: (json['hour'] as Timestamp).toDate(),
  );
  static AguaConsumida toJSONMonthly(Map<String, dynamic> json) => AguaConsumida(
    waterConsumed: (json['consumo_agua'] as num).toDouble(),
    timestamp: (json['mes'] as Timestamp).toDate(),
  );
}



Stream<List<AguaConsumida>> obtenerConsumoDeAguaDiario() {
  // Obtener la fecha actual
  DateTime now = DateTime.now();
  DateTime ahora = DateTime(2023, 8, 25, now.hour);

  // Ajustar la fecha para que sea exactamente la medianoche de hoy
  DateTime medianocheDeHoy = DateTime(2023, 8, 25, 0);

  return FirebaseFirestore.instance
    .collection('consumo_agua_innova2030')
    .where('hour', isGreaterThanOrEqualTo: Timestamp.fromDate(medianocheDeHoy))
    .where('hour', isLessThanOrEqualTo: Timestamp.fromDate(ahora))
    .orderBy('hour', descending: false)  // Ordenar por fecha descendente// Limitar los resultados a 2 documentos
    .snapshots()
    .map((snapshot) => 
      snapshot.docs.map((doc) => AguaConsumida.toJSON(doc.data())).toList()
    );
}

Stream<List<AguaConsumida>> obtenerConsumoDeAguaSemanal() {
  // Obtener la fecha actual
  DateTime now = DateTime.now();
  DateTime ahora = DateTime(2023, 8, 25, now.hour);

  // Ajustar la fecha para que sea exactamente la medianoche de hoy
  DateTime inicioSemana = DateTime(2023, 8, 21, 0);

  return FirebaseFirestore.instance
    .collection('consumo_agua_innova2030')
    .where('hour', isGreaterThanOrEqualTo: Timestamp.fromDate(inicioSemana))
    .where('hour', isLessThanOrEqualTo: Timestamp.fromDate(ahora))
    .orderBy('hour', descending: false)  // Ordenar por fecha descendente// Limitar los resultados a 2 documentos
    .snapshots()
    .map((snapshot) => 
      snapshot.docs.map((doc) => AguaConsumida.toJSON(doc.data())).toList()
    );
}

Stream<List<AguaConsumida>> obtenerConsumoDeAguaMensual() {
  // Obtener la fecha actual
  DateTime now = DateTime.now();
  DateTime ahora = DateTime(2023, 8, 25, now.hour);

  // Ajustar la fecha para que sea exactamente la medianoche de hoy
  DateTime inicioSemana = DateTime(2023, 8, 21, 0);

  return FirebaseFirestore.instance
    .collection('consumo_hogar_mensual')
    .where('hour', isGreaterThanOrEqualTo: Timestamp.fromDate(inicioSemana))
    .where('hour', isLessThanOrEqualTo: Timestamp.fromDate(ahora))
    .orderBy('hour', descending: false)  // Ordenar por fecha descendente// Limitar los resultados a 2 documentos
    .snapshots()
    .map((snapshot) => 
      snapshot.docs.map((doc) => AguaConsumida.toJSON(doc.data())).toList()
    );
}

Stream<List<AguaConsumida>> obtenerConsumoDeAguaAnual() {
  // Obtener la fecha actual
  DateTime now = DateTime.now();
  DateTime ahora = DateTime(2023, 3, now.day);

  // Ajustar la fecha para que sea exactamente la medianoche de hoy
  DateTime inicioSemana = DateTime(2023, 1, 1);

  return FirebaseFirestore.instance
    .collection('consumo_hogar_mensual')
    .where('mes', isGreaterThanOrEqualTo: Timestamp.fromDate(inicioSemana))
    .where('mes', isLessThanOrEqualTo: Timestamp.fromDate(ahora))
    .orderBy('mes', descending: false)  // Ordenar por fecha descendente// Limitar los resultados a 2 documentos
    .snapshots()
    .map((snapshot) => 
      snapshot.docs.map((doc) => AguaConsumida.toJSONMonthly(doc.data())).toList()
    );
}


class ConsumoAgua extends StatefulWidget {
  const ConsumoAgua({Key? key}) : super(key: key);

  @override
  State<ConsumoAgua> createState() => _ConsumoAguaState();
}

class _ConsumoAguaState extends State<ConsumoAgua> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Título de la sección
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 40.0),
                child: Text(
                  'Inicio',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 35.0, // Puedes ajustar el tamaño de la fuente según tus preferencias
                  ),
                ),
              ),
            ),

            // Gráfico para el consumo diario
            StreamBuilder<List<AguaConsumida>>(
              stream: obtenerConsumoDeAguaDiario(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return ConsumoActualDeAgua(data: data);
                } else if (snapshot.hasError) {
                  // Manejar el error si ocurre
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Mientras esperas que lleguen datos, puedes mostrar un indicador de carga, por ejemplo
                  return CircularProgressIndicator(color: Color(0xFF40a0c9));
                }
              },
            ),

            // Gráfico para el consumo semanal
            StreamBuilder<List<AguaConsumida>>(
              stream: obtenerConsumoDeAguaSemanal(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return ConsumoActualDeAgua(data: data);
                } else if (snapshot.hasError) {
                  // Manejar el error si ocurre
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Mientras esperas que lleguen datos, puedes mostrar un indicador de carga, por ejemplo
                  return CircularProgressIndicator(color: Color(0xFF40a0c9));
                }
              },
            ),
        
            // Gráfico para el consumo mensual
            StreamBuilder<List<AguaConsumida>>(
              stream: obtenerConsumoDeAguaDiario(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return ConsumoActualDeAgua(data: data);
                } else if (snapshot.hasError) {
                  // Manejar el error si ocurre
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Mientras esperas que lleguen datos, puedes mostrar un indicador de carga, por ejemplo
                  return CircularProgressIndicator(color: Color(0xFF40a0c9));
                }
              },
            ),
        
            // Gráfico para el consumo anual
            StreamBuilder<List<AguaConsumida>>(
              stream: obtenerConsumoDeAguaAnual(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return ConsumoActualDeAgua(data: data);
                } else if (snapshot.hasError) {
                  // Manejar el error si ocurre
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Mientras esperas que lleguen datos, puedes mostrar un indicador de carga, por ejemplo
                  return CircularProgressIndicator(color: Color(0xFF40a0c9));
                }
              },
            ),
            
          ],
        ),
      ),
    );
  }
}



class ConsumoActualDeAgua extends StatelessWidget {
  final List<AguaConsumida> data;

  ConsumoActualDeAgua({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35.0, right: 10, left: 10, bottom: 10),
      child: Card(
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
              series: <ChartSeries<AguaConsumida, DateTime>>[
                LineSeries<AguaConsumida, DateTime>(
                  dataSource: data,
                  xValueMapper: (AguaConsumida consumo, _) => consumo.timestamp,
                  yValueMapper: (AguaConsumida consumo, _) => consumo.waterConsumed,
                  name: 'Agua consumida',
                  // Enable data label
                  dataLabelSettings: DataLabelSettings(isVisible: false),
                ),
              ],
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
                  ),
                ),
                onPressed: () {
                  print('Aquí hay más detalles');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}