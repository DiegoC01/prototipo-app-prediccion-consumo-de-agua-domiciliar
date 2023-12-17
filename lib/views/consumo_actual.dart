import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
  
}

// Testing Firestore
class AguaConsumida {
  AguaConsumida({
    required this.timestamp, 
    required this.waterConsumed
  });

  final DateTime timestamp;
  final double waterConsumed;

  static AguaConsumida toJSON(Map<String, dynamic> json) => AguaConsumida(
    waterConsumed: (json['consumo_agua'] as num).toDouble(),
    timestamp: (json['hora'] as Timestamp).toDate(),
  );
}


Stream<List<AguaConsumida>> obtenerConsumoDeAgua() {
  // Obtener la fecha actual
  DateTime ahora = DateTime.now();

  // Ajustar la fecha para que sea exactamente la medianoche de hoy
  DateTime medianocheDeHoy = DateTime(ahora.year, ahora.month, 11);

  return FirebaseFirestore.instance
    .collection('consumo_de_agua_prueba')
    .where('hora', isGreaterThanOrEqualTo: Timestamp.fromDate(medianocheDeHoy))  // Condición en la marca de tiempo
    .orderBy('hora', descending: false)  // Ordenar por fecha descendente// Limitar los resultados a 2 documentos
    .snapshots()
    .map((snapshot) => 
      snapshot.docs.map((doc) => AguaConsumida.toJSON(doc.data())).toList()
    );
}


class ConsumoAgua extends StatefulWidget {
  const ConsumoAgua({super.key});

  @override
  State<ConsumoAgua> createState() => _ConsumoAguaState();
}

class _ConsumoAguaState extends State<ConsumoAgua> {
  //Stream<List<AguaConsumida>> data = obtenerConsumoDeAgua();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<AguaConsumida>>(
        stream: obtenerConsumoDeAgua(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;

            return Card(
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
              );
            
          }
          else if (snapshot.hasError) {
            // Manejar el error si ocurre
            return Text('Error: ${snapshot.error}');
          } else {
            // Mientras esperas que lleguen datos, puedes mostrar un indicador de carga, por ejemplo
            return CircularProgressIndicator();
          }

        }),
    );
  }

}