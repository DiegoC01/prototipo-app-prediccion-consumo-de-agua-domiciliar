import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:dart_date/dart_date.dart';

final weekdayFormatter = DateFormat.E('de_DE');

// Fecha de la app, modificada para mostrar los datos de los conjuntos de datos
// En base a estos se puede mostrar información hasta el 01 de septiembre.
DateTime fechaApp = (DateTime.now()).subMonths(5);

// Clase que guarda el consumo obtenido en Firebase
class AguaConsumida {
  AguaConsumida({required this.timestamp, required this.waterConsumed});

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

// Función para obtener el consumo de agua diario desde Firebase en base a la hora de la app
Stream<List<List<double>>> obtenerConsumoDeAguaDiario() {
  DateTime finalDia = DateTime(fechaApp.year, fechaApp.month, fechaApp.day, 23);
  DateTime medianocheDeHoy =
      DateTime(fechaApp.year, fechaApp.month, fechaApp.day, 0);

  return FirebaseFirestore.instance
      .collection('consumo_agua_innova2030')
      .where('hour',
          isGreaterThanOrEqualTo: Timestamp.fromDate(medianocheDeHoy))
      .where('hour', isLessThanOrEqualTo: Timestamp.fromDate(finalDia))
      .orderBy('hour', descending: false)
      .snapshots()
      .map((snapshot) => [
            snapshot.docs
                .map((doc) => (doc.data()['waterMeasured'] as num).toDouble())
                .toList()
          ]);
}

// Función para obtener el consumo de agua semanal desde Firebase en base a la hora de la app
Stream<List<List<double>>> obtenerConsumoDeAguaSemanal() {
  int weekDay = fechaApp.weekday;
  DateTime diasFecha = DateTime(fechaApp.year, fechaApp.month, fechaApp.day);
  DateTime finalSemana = diasFecha
      .add(Duration(days: DateTime.daysPerWeek - diasFecha.weekday, hours: 23));
  DateTime inicioSemana = diasFecha.subtract(Duration(days: weekDay - 1));

  return FirebaseFirestore.instance
      .collection('consumo_agua_innova2030')
      .where('hour', isGreaterThanOrEqualTo: Timestamp.fromDate(inicioSemana))
      .where('hour', isLessThanOrEqualTo: Timestamp.fromDate(finalSemana))
      .orderBy('hour', descending: false)
      .snapshots()
      .map((snapshot) => [
            snapshot.docs
                .map((doc) => (doc.data()['waterMeasured'] as num).toDouble())
                .toList()
          ]);
}

// Función para obtener el consumo de agua mensual desde Firebase en base a la hora de la app
Stream<List<List<List<double>>>> obtenerConsumoDeAguaMensual() {
  // Obtener la fecha actual
  DateTime mesActual = DateTime(fechaApp.year, fechaApp.month, 1);

  return FirebaseFirestore.instance
      .collection('consumo_hogar_mensual')
      .where('mes', isGreaterThanOrEqualTo: mesActual)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            DateTime timestamp = (doc.data()['mes'] as Timestamp).toDate();
            int mes = timestamp.month;
            int anio = timestamp.year;
            double consumo = (doc.data()['consumo_agua'] as num).toDouble();

            return [
              [consumo, mes.toDouble(), anio.toDouble()]
            ];
          }).toList());
}

// Función para obtener el consumo de agua anual desde Firebase en base a la hora de la app
Stream<List<List<List<double>>>> obtenerConsumoDeAguaAnual() {
  DateTime finalAnio = DateTime(fechaApp.year, 1, 1);
  DateTime inicioAnio = DateTime(fechaApp.year - 1, 1, 1);

  return FirebaseFirestore.instance
      .collection('consumo_hogar_mensual')
      .where('mes', isGreaterThanOrEqualTo: Timestamp.fromDate(inicioAnio))
      .where('mes', isLessThanOrEqualTo: Timestamp.fromDate(finalAnio))
      .orderBy('mes', descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            DateTime timestamp = (doc.data()['mes'] as Timestamp).toDate();
            int mes = timestamp.month;
            int anio = timestamp.year;
            double consumo = (doc.data()['consumo_agua'] as num).toDouble();

            return [
              [consumo, mes.toDouble(), anio.toDouble()]
            ];
          }).toList());
}

// Widget que muestra el contenido del módulo
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
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 40.0),
                child: Text(
                  'Predicciones',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 35.0,
                  ),
                ),
              ),
            ),

            // Gráfico con predicciones diarias
            StreamBuilder<List<List<double>>>(
              stream: obtenerConsumoDeAguaDiario(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final dataBd = snapshot.data!;
                  return PrediccionConsumoDiario(
                      data: dataBd,
                      horizonte: 'Diario',
                      tituloGrafico: 'Predicciones para el día de hoy');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator(
                      color: Color(0xFF40a0c9));
                }
              },
            ),

            // Gráfico con predicciones semanales
            StreamBuilder<List<List<double>>>(
              stream: obtenerConsumoDeAguaSemanal(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final dataBd = snapshot.data!;
                  return PrediccionConsumoSemanal(
                      data: dataBd,
                      horizonte: 'Semanal',
                      tituloGrafico: 'Predicciones para esta semana');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator(
                      color: Color(0xFF40a0c9));
                }
              },
            ),

            // Gráfico con predicciones mensuales
            StreamBuilder<List<List<List<double>>>>(
              stream: obtenerConsumoDeAguaMensual(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final dataBd = snapshot.data!;
                  return PrediccionConsumoMensual(
                      data: dataBd,
                      horizonte: 'Mensual',
                      tituloGrafico: 'Predicciones para este mes');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator(
                      color: Color(0xFF40a0c9));
                }
              },
            ),
            // Gráfico con predicciones anuales
            StreamBuilder<List<List<List<double>>>>(
              stream: obtenerConsumoDeAguaAnual(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final dataBd = snapshot.data!;
                  return PrediccionConsumoAnual(
                      data: dataBd,
                      horizonte: 'Anual',
                      tituloGrafico: 'Predicciones para este año');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator(
                      color: Color(0xFF40a0c9));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PrediccionConsumoDiario extends StatelessWidget {
  final List<List<double>> data;
  final String horizonte;
  final String tituloGrafico;
  const PrediccionConsumoDiario(
      {super.key,
      required this.horizonte,
      required this.data,
      required this.tituloGrafico});

  void initState() {
    performPrediction();
  }

  Future<List<dynamic>?> performPrediction() async {
    try {
      // Cargar el modelo
      final Interpreter interpreter;
      final int outputNumber;
      DateTime inicioPeriodo;

      interpreter =
          await Interpreter.fromAsset('assets/ml_models/gru_day_mobile.tflite');
      outputNumber = 24;
      inicioPeriodo = DateTime(fechaApp.year, fechaApp.month, fechaApp.day, 0);

      List<dynamic> output =
          List<double>.filled(1 * outputNumber, 0).reshape([1, outputNumber]);

      interpreter.run(data, output);

      interpreter.close();

      final List<AguaConsumida> predicciones = [];

      for (int i = 0; i < output[0].length; i++) {
        final double valores = output[0][i];

        predicciones.add(
            AguaConsumida(waterConsumed: valores, timestamp: inicioPeriodo));
        inicioPeriodo = inicioPeriodo.addHours(1);
      }
      return predicciones;
    } catch (e) {
      return List<double>.filled(1, 0).reshape([1, 1]);
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
            padding: const EdgeInsets.only(
                top: 35.0, right: 10, left: 10, bottom: 10),
            child: Card(
              child: Column(
                children: [
                  SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(
                        text: tituloGrafico,
                        textStyle: const TextStyle(
                          fontFamily: 'Lato',
                          color: Colors.black,
                        ),
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries<dynamic, String>>[
                        LineSeries<dynamic, String>(
                          dataSource: predicciones,
                          xValueMapper: (dynamic consumo, _) =>
                              DateFormat('HH:mm', 'es_MX')
                                  .format(consumo.timestamp),
                          yValueMapper: (dynamic consumo, _) =>
                              consumo.waterConsumed,
                          name: 'Predicción de consumo (litros)',
                          //dataLabelSettings: DataLabelSettings(isVisible: true),
                        )
                      ]),
                ],
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class PrediccionConsumoSemanal extends StatelessWidget {
  final List<List<double>> data;
  final String horizonte;
  final String tituloGrafico;
  const PrediccionConsumoSemanal(
      {super.key,
      required this.horizonte,
      required this.data,
      required this.tituloGrafico});

  void initState() {
    performPrediction();
  }

  Future<List<dynamic>?> performPrediction() async {
    try {
      // Cargar el modelo
      final Interpreter interpreter;
      final int outputNumber;
      DateTime inicioPeriodo;

      interpreter = await Interpreter.fromAsset(
          'assets/ml_models/gru_week_mobile.tflite');
      outputNumber = 168;
      int weekDay = fechaApp.weekday;
      inicioPeriodo = fechaApp.subtract(Duration(days: weekDay - 1));

      List<dynamic> output =
          List<double>.filled(1 * outputNumber, 0).reshape([1, outputNumber]);

      interpreter.run(data, output);

      interpreter.close();

      final List<AguaConsumida> predicciones = [];

      for (int i = 0; i < output[0].length; i++) {
        final double valores = output[0][i];

        predicciones.add(
            AguaConsumida(waterConsumed: valores, timestamp: inicioPeriodo));
        inicioPeriodo = inicioPeriodo.addHours(1);
      }

      return predicciones;
    } catch (e) {
      return List<double>.filled(1, 0).reshape([1, 1]);
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
            padding: const EdgeInsets.only(
                top: 35.0, right: 10, left: 10, bottom: 10),
            child: Card(
              child: Column(
                children: [
                  SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(
                        text: tituloGrafico,
                        textStyle: const TextStyle(
                          fontFamily: 'Lato',
                          color: Colors.black,
                        ),
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries<dynamic, String>>[
                        LineSeries<dynamic, String>(
                          dataSource: predicciones,
                          xValueMapper: (dynamic consumo, _) =>
                              DateFormat('E, HH:mm', 'es_MX')
                                  .format(consumo.timestamp),
                          yValueMapper: (dynamic consumo, _) =>
                              consumo.waterConsumed,
                          name: 'Predicción de consumo (litros)',
                          //dataLabelSettings: DataLabelSettings(isVisible: true),
                        )
                      ]),
                ],
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class PrediccionConsumoMensual extends StatelessWidget {
  final List<List<List<double>>> data;
  final String horizonte;
  final String tituloGrafico;
  const PrediccionConsumoMensual(
      {super.key,
      required this.horizonte,
      required this.data,
      required this.tituloGrafico});

  void initState() {
    performPrediction();
  }

  Future<List<dynamic>?> performPrediction() async {
    try {
      // Cargar el modelo
      final Interpreter interpreter;
      final int outputNumber;
      DateTime inicioPeriodo;

      interpreter = await Interpreter.fromAsset(
          'assets/ml_models/gru_month_mobile.tflite');
      outputNumber = 1;
      int weekDay = fechaApp.weekday;
      inicioPeriodo = fechaApp.subtract(Duration(days: weekDay));

      List<dynamic> output =
          List<double>.filled(1 * outputNumber, 0).reshape([1, outputNumber]);

      interpreter.run(data, output);

      interpreter.close();

      final List<AguaConsumida> predicciones = [];

      for (int i = 0; i < output[0].length; i++) {
        final double valores = output[0][i];
        predicciones.add(
            AguaConsumida(waterConsumed: valores, timestamp: inicioPeriodo));
        inicioPeriodo = inicioPeriodo.addMonths(1);
      }

      return predicciones;
    } catch (e) {
      return List<double>.filled(1, 0).reshape([1, 1]);
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
            padding: const EdgeInsets.only(
                top: 35.0, right: 10, left: 10, bottom: 10),
            child: Card(
              child: Column(
                children: [
                  SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(
                        text: tituloGrafico,
                        textStyle: const TextStyle(
                          fontFamily: 'Lato',
                          color: Colors.black,
                        ),
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries<dynamic, String>>[
                        BarSeries<dynamic, String>(
                          dataSource: predicciones,
                          xValueMapper: (dynamic consumo, _) =>
                              DateFormat.yMMMM('es_MX')
                                  .format(consumo.timestamp),
                          yValueMapper: (dynamic consumo, _) =>
                              consumo.waterConsumed,
                          name: 'Predicción de consumo (metros cúbicos)',
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true),
                        )
                      ]),
                ],
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class PrediccionConsumoAnual extends StatelessWidget {
  final List<List<List<double>>> data;
  final String horizonte;
  final String tituloGrafico;
  const PrediccionConsumoAnual(
      {super.key,
      required this.horizonte,
      required this.data,
      required this.tituloGrafico});

  void initState() {
    performPrediction();
  }

  Future<List<dynamic>?> performPrediction() async {
    try {
      // Cargar el modelo
      final Interpreter interpreter;
      final int outputNumber;
      DateTime inicioPeriodo;

      interpreter = await Interpreter.fromAsset(
          'assets/ml_models/gru_year_mobile.tflite');
      outputNumber = 12;
      inicioPeriodo = DateTime(fechaApp.year, 1, 1);

      List<dynamic> output =
          List<double>.filled(1 * outputNumber, 0).reshape([1, outputNumber]);

      interpreter.run(data, output);

      interpreter.close();

      final List<AguaConsumida> predicciones = [];

      if (horizonte == 'Anual' || horizonte == 'Mensual') {
        for (int i = 0; i < output[0].length; i++) {
          final double valores = output[0][i];
          predicciones.add(
              AguaConsumida(waterConsumed: valores, timestamp: inicioPeriodo));
          inicioPeriodo = inicioPeriodo.addMonths(1);
        }
      } else {
        for (int i = 0; i < output[0].length; i++) {
          final double valores = output[0][i];

          predicciones.add(
              AguaConsumida(waterConsumed: valores, timestamp: inicioPeriodo));
          inicioPeriodo = inicioPeriodo.add(Duration(hours: i));
        }
      }

      return predicciones;
    } catch (e) {
      return List<double>.filled(1, 0).reshape([1, 1]);
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
            padding: const EdgeInsets.only(
                top: 35.0, right: 10, left: 10, bottom: 10),
            child: Card(
              child: Column(
                children: [
                  SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(
                        text: tituloGrafico,
                        textStyle: const TextStyle(
                          fontFamily: 'Lato',
                          color: Colors.black,
                        ),
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries<dynamic, String>>[
                        LineSeries<dynamic, String>(
                          dataSource: predicciones,
                          xValueMapper: (dynamic consumo, _) =>
                              DateFormat.yMMMM('es_MX')
                                  .format(consumo.timestamp),
                          yValueMapper: (dynamic consumo, _) =>
                              consumo.waterConsumed,
                          name: 'Predicción de consumo (metros cúbicos)',
                          //dataLabelSettings: DataLabelSettings(isVisible: true),
                        )
                      ]),
                ],
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
