import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';




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


// ML model



class Predicciones extends StatefulWidget {
  const Predicciones({super.key});

  @override
  State<Predicciones> createState() => _PrediccionesState();
}


class _PrediccionesState extends State<Predicciones> {
  @override
  void initState() {
    super.initState();
    performPrediction();
  }

  

  Future<List<dynamic>?> performPrediction() async {
    try {

      // Cargar el modelo
      //final interpreter = await Interpreter.fromFile(model!.file);

      final interpreter = await Interpreter.fromAsset('assets/ml_models/gru_day_mobile.tflite');

      var input = [[1.23, 6.54, 7.81, 3.21, 2.22, 4.5, 6.7, 8.9, 10.0, 11.2, 13.4, 15.6, 17.8, 19.0, 21.2, 23.4, 25.6, 27.8, 30.0, 32.2, 34.4, 36.6, 38.8, 40.0]];
      List<dynamic> output = List<double>.filled(1*24, 0).reshape([1,24]);

      print("Si llegamos hasta aquí estamos bien");
      interpreter.run(input, output);
      // Devolver la lista de salida dentro de un Future
      

      interpreter.close();

      DateTime ahora = DateTime.now();
      DateTime inicioDelDia = DateTime(ahora.year, ahora.month, 11);

      final List<AguaConsumida> predicciones = [];

      for (int i = 0; i < output[0].length; i++) {
        final DateTime timestamp = inicioDelDia.add(Duration(hours: i));
        final double valores = output[0][i];

        predicciones.add(AguaConsumida(waterConsumed: valores, timestamp: timestamp));
      }

      print(predicciones);

      return predicciones;
    } catch (e) {
      print("Error al realizar la predicción: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<AguaConsumida>>(
        stream: obtenerConsumoDeAgua(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data_bd = snapshot.data!;
            

            return FutureBuilder(
              future: performPrediction(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  print(data);
                  return Card(
                        child: Column(
                          children: [
                              SfCartesianChart(
                                  primaryXAxis: CategoryAxis(),
                                  // Chart title
                                  title: ChartTitle(
                                    text: 'Consumo de agua del presente día',
                                    textStyle: const TextStyle(
                                      fontFamily: 'Lato',
                                      color: Colors.black,
                                    ),
                                  ),
                                  // Enable legend
                                  //legend: Legend(isVisible: true),
                                  // Enable tooltip
                                  tooltipBehavior: TooltipBehavior(enable: true),
                                  series: <ChartSeries<dynamic, DateTime>>[
                                    LineSeries<dynamic, DateTime>(
                                        dataSource: data,
                                        xValueMapper: (dynamic consumo, _) => consumo.timestamp,
                                        yValueMapper: (dynamic consumo, _) => consumo.waterConsumed,
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
                } else {
                  return CircularProgressIndicator();
                }
                
              },
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

