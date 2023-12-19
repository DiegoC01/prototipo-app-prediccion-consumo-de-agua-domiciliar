import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:dart_date/dart_date.dart';




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
  static List<double> toJSONList(List<Map<String, dynamic>> jsonList) {
    return jsonList
        .map((json) => (json['consumo_agua'] as num).toDouble())
        .toList();
  }
}


Stream<List<List<double>>> obtenerConsumoDeAgua() {
  // Obtener la fecha actual
  DateTime finalDia = DateTime(2023, 8, 24, 23);

  // Ajustar la fecha para que sea exactamente la medianoche de hoy
  DateTime medianocheDeHoy = DateTime(2023, 8, 24, 0);

return FirebaseFirestore.instance
    .collection('consumo_agua_innova2030')
    .where('hour', isGreaterThanOrEqualTo: Timestamp.fromDate(medianocheDeHoy))
    .where('hour', isLessThanOrEqualTo: Timestamp.fromDate(finalDia))
    .orderBy('hour', descending: false)
    .snapshots()
    .map((snapshot) =>
        [snapshot.docs.map((doc) => (doc.data()['waterMeasured'] as num).toDouble()).toList()]);

}

Stream<List<List<double>>> obtenerConsumoDeAguaSemanal() {
  // Obtener la fecha actual
  DateTime finalSemana = DateTime(2023, 8, 20, 23);

  // Ajustar la fecha para que sea exactamente la medianoche de hoy
  DateTime inicioSemana = DateTime(2023, 8, 14, 0);

return FirebaseFirestore.instance
    .collection('consumo_agua_innova2030')
    .where('hour', isGreaterThanOrEqualTo: Timestamp.fromDate(inicioSemana))
    .where('hour', isLessThanOrEqualTo: Timestamp.fromDate(finalSemana))
    .orderBy('hour', descending: false)
    .snapshots()
    .map((snapshot) =>
        [snapshot.docs.map((doc) => (doc.data()['waterMeasured'] as num).toDouble()).toList()]);

}

Stream<List<List<double>>> obtenerConsumoDeAguaMensual() {
  // Obtener la fecha actual
  DateTime mesActual = DateTime(2023, 3, 1);


return FirebaseFirestore.instance
    .collection('consumo_hogar_mensual')
    .where('mes', isGreaterThanOrEqualTo: Timestamp.fromDate(mesActual))
    .orderBy('mes', descending: false)
    .snapshots()
    .map((snapshot) {
      List<double> consumoAguaList = snapshot.docs.map((doc) => (doc.data()['consumo_agua'] as num).toDouble()).toList();

      // Agrega dos elementos adicionales
      double elementoExtra1 = 1.0 ; // Reemplaza esto con el valor que desees
      double elementoExtra2 = 2023.0; // Reemplaza esto con el valor que desees

      consumoAguaList.addAll([elementoExtra1, elementoExtra2]);

      return [consumoAguaList];
    });

}

Stream<List<List<double>>> obtenerConsumoDeAguaAnual() {
  // Obtener la fecha actual
  DateTime finalAnio = DateTime(2023, 1, 1);

  // Ajustar la fecha para que sea exactamente la medianoche de hoy
  DateTime inicioAnio = DateTime(2022, 1, 1);

return FirebaseFirestore.instance
    .collection('consumo_hogar_mensual')
    .where('mes', isGreaterThanOrEqualTo: Timestamp.fromDate(inicioAnio))
    .where('mes', isLessThanOrEqualTo: Timestamp.fromDate(finalAnio))
    .orderBy('mes', descending: false)
    .snapshots()
    .map((snapshot) {
      List<double> consumoAguaList = snapshot.docs.map((doc) => (doc.data()['consumo_agua'] as num).toDouble()).toList();

      // Agrega dos elementos adicionales
      double elementoExtra1 = 2022; // Reemplaza esto con el valor que desees
      double elementoExtra2 = 1; // Reemplaza esto con el valor que desees

      consumoAguaList.addAll([elementoExtra1, elementoExtra2]);

      return [consumoAguaList];
    });

}

class Predicciones extends StatefulWidget {
  const Predicciones({super.key});

  @override
  State<Predicciones> createState() => _PrediccionesState();
}


class _PrediccionesState extends State<Predicciones> {

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
                  'Predicciones',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 35.0, // Puedes ajustar el tamaño de la fuente según tus preferencias
                  ),
                ),
              ),
            ),

            // Gráfico con predicciones diarias
            StreamBuilder<List<List<double>>>(
              stream: obtenerConsumoDeAgua(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data_bd = snapshot.data!;
                  print("Aquí están los datos del día: ");
                  print(data_bd);
                  print("feliz?");
                  return PrediccionConsumo(data: data_bd, horizonte: 'Diario');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator(color: Color(0xFF40a0c9));
                }
              },
            ),
            
            // Gráfico con predicciones semanales
            StreamBuilder<List<List<double>>>(
              stream: obtenerConsumoDeAguaSemanal(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data_bd = snapshot.data!;
                  print("Aquí están los datos de la semana: ");
                  print(data_bd);
                  print("feliz?");
                  return PrediccionConsumo(data: data_bd, horizonte: 'Semanal');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator(color: Color(0xFF40a0c9));
                }
              },
            ),

            // Gráfico con predicciones mensuales
            StreamBuilder<List<List<double>>>(
              stream: obtenerConsumoDeAguaMensual(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data_bd = snapshot.data!;
                  print("Aquí están los datos del mes: ");
                  print(data_bd);
                  print("feliz?");
                  return PrediccionConsumo(data: data_bd, horizonte: 'Mensual');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator(color: Color(0xFF40a0c9));
                }
              },
            ),
            // Gráfico con predicciones anuales
            /*StreamBuilder<List<List<double>>>(
              stream: obtenerConsumoDeAguaAnual(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data_bd = snapshot.data!;
                  print("Aquí están los datos del año: ");
                  print(data_bd);
                  print("feliz?");
                  return PrediccionConsumo(data: data_bd, horizonte: 'Anual');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator(color: Color(0xFF40a0c9));
                }
              },
            ),*/
          ],
        ),
      ),
    );
  }
}

class PrediccionConsumo extends StatelessWidget {
  final List<List<double>> data;
  final String horizonte;
  PrediccionConsumo({super.key, required this.horizonte, required this.data});

    
  @override
  void initState() {
    performPrediction();
  }

  Future<List<dynamic>?> performPrediction() async {
    try {

      // Cargar el modelo
      final interpreter;
      final int outputNumber;
      DateTime inicioDelDia;
      

      if(horizonte == 'Diario'){
        interpreter = await Interpreter.fromAsset('assets/ml_models/gru_day_mobile.tflite');
        outputNumber = 24;
        inicioDelDia = DateTime(2023, 8, 25);
      }
      else if(horizonte == 'Semanal'){
        interpreter = await Interpreter.fromAsset('assets/ml_models/gru_week_mobile.tflite');
        outputNumber = 168;
        inicioDelDia = DateTime(2023, 3, 1);
      }
      else if(horizonte == 'Mensual'){
        interpreter = await Interpreter.fromAsset('assets/ml_models/gru_month_mobile.tflite');
        outputNumber = 1;
        inicioDelDia = DateTime(2022, 1, 1);
      }
      else{
        interpreter = await Interpreter.fromAsset('assets/ml_models/gru_year_mobile.tflite');
        outputNumber = 12;
        inicioDelDia = DateTime(2022, 1, 1);
      }

      //var input = [[1.23, 6.54, 7.81, 3.21, 2.22, 4.5, 6.7, 8.9, 10.0, 11.2, 13.4, 15.6, 17.8, 19.0, 21.2, 23.4, 25.6, 27.8, 30.0, 32.2, 34.4, 36.6, 38.8, 40.0]];
      List<dynamic> output = List<double>.filled(1*outputNumber, 0).reshape([1,outputNumber]);

      print('DATA:'+horizonte);
      print(data.shape);
      print('output:'+horizonte);
      print(output.shape);

      //print("Si llegamos hasta aquí estamos bien");
      interpreter.run(data, output);
      // Devolver la lista de salida dentro de un Future


      interpreter.close();

      //DateTime ahora = DateTime.now();

      final List<AguaConsumida> predicciones = [];

      if(horizonte == 'Anual' || horizonte == 'Mensual'){
        for (int i = 0; i < output[0].length; i++) {
          final DateTime timestamp = inicioDelDia.add(Duration(hours: 30*i));
          final double valores = output[0][i];
          print('Ciclo valores +'+horizonte);
          print(valores);
          print('Ciclo time +'+horizonte);
          print(timestamp);

          predicciones.add(AguaConsumida(waterConsumed: valores, timestamp: timestamp));
        }        
      }
      else{
        for (int i = 0; i < output[0].length; i++) {
          final DateTime timestamp = inicioDelDia.add(Duration(hours: i));
          final double valores = output[0][i];

          predicciones.add(AguaConsumida(waterConsumed: valores, timestamp: timestamp));
        }
      }

      print("AQUÍ ESTÁ LAS PREDICCIONES "+horizonte);
      print(predicciones);
      print("y el output:");
      print(output);

      return predicciones;
    } catch (e) {
      print("Error al realizar la predicción: $e");
      return List<double>.filled(1, 0).reshape([1,1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: performPrediction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error snapshot: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final predicciones = snapshot.data as List<AguaConsumida>;
          return Padding(
            padding: const EdgeInsets.only(top: 35.0, right: 10, left: 10, bottom: 10),
            child: Card(
              child: Column(
                children: [
                  SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    title: ChartTitle(
                      text: 'Consumo de agua del presente día',
                      textStyle: const TextStyle(
                        fontFamily: 'Lato',
                        color: Colors.black,
                      ),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries<dynamic, DateTime>>[
                      LineSeries<dynamic, DateTime>(
                        dataSource: predicciones,
                        xValueMapper: (dynamic consumo, _) => consumo.timestamp,
                        yValueMapper: (dynamic consumo, _) => consumo.waterConsumed,
                        name: 'Predicción de consumo',
                        //dataLabelSettings: DataLabelSettings(isVisible: true),
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
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

