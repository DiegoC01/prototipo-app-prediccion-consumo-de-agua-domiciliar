import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Fecha de la app, modificada para mostrar los datos de los conjuntos de datos
// En base a estos se puede mostrar información hasta el 01 de septiembre.
DateTime fechaApp = (DateTime.now()).subMonths(5);
String fechaAppFormateada = DateFormat.yMMMMEEEEd('es-MX').format(fechaApp);

// Clase que guarda el consumo obtenido en Firebase
class AguaConsumida {
  AguaConsumida({required this.timestamp, required this.waterConsumed});

  final DateTime timestamp;
  final double waterConsumed;

  static AguaConsumida toJSON(Map<String, dynamic> json) => AguaConsumida(
        waterConsumed: (json['waterMeasured'] as num).toDouble(),
        timestamp: (json['hour'] as Timestamp).toDate(),
      );
  static AguaConsumida toJSONMonthly(Map<String, dynamic> json) =>
      AguaConsumida(
        waterConsumed: (json['consumo_agua'] as num).toDouble(),
        timestamp: (json['mes'] as Timestamp).toDate(),
      );
}

// Función para obtener el consumo del día en Firebase en base a la hora de la app
Stream<List<AguaConsumida>> obtenerConsumoDeAguaDiario() {
  DateTime now = DateTime.now();
  DateTime ahora =
      DateTime(fechaApp.year, fechaApp.month, fechaApp.day, now.hour);

  DateTime medianocheDeHoy =
      DateTime(fechaApp.year, fechaApp.month, fechaApp.day, 0);

  return FirebaseFirestore.instance
      .collection('consumo_agua_innova2030')
      .where('hour',
          isGreaterThanOrEqualTo: Timestamp.fromDate(medianocheDeHoy))
      .where('hour', isLessThanOrEqualTo: Timestamp.fromDate(ahora))
      .orderBy('hour', descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => AguaConsumida.toJSON(doc.data()))
          .toList());
}

// Función para obtener el consumo de la semana en Firebase en base a la hora y fecha de la app
Stream<List<AguaConsumida>> obtenerConsumoDeAguaSemanal() {
  // Obtener la fecha actual
  DateTime now = DateTime.now();

  int weekDay = fechaApp.weekday;
  DateTime diasFecha = DateTime(fechaApp.year, fechaApp.month, fechaApp.day);
  DateTime ahora = diasFecha.add(Duration(hours: now.hour));
  DateTime inicioSemana = diasFecha.subtract(Duration(days: weekDay - 1));

  return FirebaseFirestore.instance
      .collection('consumo_agua_innova2030')
      .where('hour', isGreaterThanOrEqualTo: Timestamp.fromDate(inicioSemana))
      .where('hour', isLessThanOrEqualTo: Timestamp.fromDate(ahora))
      .orderBy('hour', descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => AguaConsumida.toJSON(doc.data()))
          .toList());
}

// Función para obtener el consumo del mes en Firebase en base a la hora y fecha de la app
Stream<List<AguaConsumida>> obtenerConsumoDeAguaMensual() {
  DateTime inicioAnio = DateTime(fechaApp.year, fechaApp.month, 1);

  return FirebaseFirestore.instance
      .collection('consumo_hogar_mensual')
      .where('mes', isGreaterThanOrEqualTo: Timestamp.fromDate(inicioAnio))
      .where('mes', isLessThanOrEqualTo: Timestamp.fromDate(fechaApp))
      .orderBy('mes', descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => AguaConsumida.toJSONMonthly(doc.data()))
          .toList());
}

// Función para obtener el consumo del año en Firebase en base a la hora y fecha de la app
Stream<List<AguaConsumida>> obtenerConsumoDeAguaAnual() {
  DateTime inicioAnio = DateTime(fechaApp.year, 1, 1);

  return FirebaseFirestore.instance
      .collection('consumo_hogar_mensual')
      .where('mes', isGreaterThanOrEqualTo: Timestamp.fromDate(inicioAnio))
      .where('mes', isLessThanOrEqualTo: Timestamp.fromDate(fechaApp))
      .orderBy('mes', descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => AguaConsumida.toJSONMonthly(doc.data()))
          .toList());
}

class ConsumoAgua extends StatefulWidget {
  const ConsumoAgua({super.key});

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
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 40.0),
                child: Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 35.0,
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                child: Text(
                  'Hoy es $fechaAppFormateada',
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 18.0,
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
                  return ConsumoActualDeAguaDiario(
                      data: data, tituloGrafico: 'Consumo del día de hoy');
                } else if (snapshot.hasError) {
                  // Manejar el error si ocurre
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator(
                      color: Color(0xFF40a0c9));
                }
              },
            ),

            // Gráfico para el consumo semanal
            StreamBuilder<List<AguaConsumida>>(
              stream: obtenerConsumoDeAguaSemanal(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return ConsumoActualDeAguaSemanal(
                      data: data, tituloGrafico: 'Consumo de esta semana');
                } else if (snapshot.hasError) {
                  // Manejar el error si ocurre
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Mientras esperas que lleguen datos, puedes mostrar un indicador de carga, por ejemplo
                  return const CircularProgressIndicator(
                      color: Color(0xFF40a0c9));
                }
              },
            ),

            // Gráfico para el consumo mensual
            StreamBuilder<List<AguaConsumida>>(
              stream: obtenerConsumoDeAguaMensual(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return ConsumoActualDeAguaMensual(
                      data: data, tituloGrafico: 'Consumo de este mes');
                } else if (snapshot.hasError) {
                  // Manejar el error si ocurre
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Mientras esperas que lleguen datos, puedes mostrar un indicador de carga, por ejemplo
                  return const CircularProgressIndicator(
                      color: Color(0xFF40a0c9));
                }
              },
            ),

            // Gráfico para el consumo anual
            StreamBuilder<List<AguaConsumida>>(
              stream: obtenerConsumoDeAguaAnual(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return ConsumoActualDeAguaAnual(
                      data: data, tituloGrafico: 'Consumo de este año');
                } else if (snapshot.hasError) {
                  // Manejar el error si ocurre
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Mientras esperas que lleguen datos, puedes mostrar un indicador de carga, por ejemplo
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

// Construcción de gráfico con información de consumo diario
class ConsumoActualDeAguaDiario extends StatelessWidget {
  final List<AguaConsumida> data;
  final String tituloGrafico;

  const ConsumoActualDeAguaDiario(
      {super.key, required this.data, required this.tituloGrafico});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 35.0, right: 10, left: 10, bottom: 10),
      child: Card(
        child: Column(
          children: [
            SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(
                text: tituloGrafico,
                textStyle: const TextStyle(
                  fontFamily: 'Lato',
                  color: Colors.black,
                ),
              ),
              // Enable legend
              //legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<AguaConsumida, String>>[
                LineSeries<AguaConsumida, String>(
                  dataSource: data,
                  xValueMapper: (AguaConsumida consumo, _) =>
                      DateFormat('HH:mm', 'es_MX').format(consumo.timestamp),
                  yValueMapper: (AguaConsumida consumo, _) =>
                      consumo.waterConsumed,
                  name: 'Agua consumida (litros)',
                  // Enable data label
                  dataLabelSettings: const DataLabelSettings(isVisible: false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Construcción de gráfico con información de consumo semanal
class ConsumoActualDeAguaSemanal extends StatelessWidget {
  final List<AguaConsumida> data;
  final String tituloGrafico;

  const ConsumoActualDeAguaSemanal(
      {super.key, required this.data, required this.tituloGrafico});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 35.0, right: 10, left: 10, bottom: 10),
      child: Card(
        child: Column(
          children: [
            SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(
                text: tituloGrafico,
                textStyle: const TextStyle(
                  fontFamily: 'Lato',
                  color: Colors.black,
                ),
              ),
              // Enable legend
              //legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<AguaConsumida, String>>[
                LineSeries<AguaConsumida, String>(
                  dataSource: data,
                  xValueMapper: (AguaConsumida consumo, _) =>
                      DateFormat('E, HH:mm', 'es_MX').format(consumo.timestamp),
                  yValueMapper: (AguaConsumida consumo, _) =>
                      consumo.waterConsumed,
                  name: 'Agua consumida (litros)',
                  // Enable data label
                  dataLabelSettings: const DataLabelSettings(isVisible: false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Construcción de gráfico con información de consumo mensual
class ConsumoActualDeAguaMensual extends StatelessWidget {
  final List<AguaConsumida> data;
  final String tituloGrafico;

  const ConsumoActualDeAguaMensual(
      {super.key, required this.data, required this.tituloGrafico});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 35.0, right: 10, left: 10, bottom: 10),
      child: Card(
        child: Column(
          children: [
            SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(
                text: tituloGrafico,
                textStyle: const TextStyle(
                  fontFamily: 'Lato',
                  color: Colors.black,
                ),
              ),
              // Enable legend
              //legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<AguaConsumida, String>>[
                BarSeries<AguaConsumida, String>(
                  dataSource: data,
                  xValueMapper: (AguaConsumida consumo, _) =>
                      DateFormat.yMMMM('es_MX').format(consumo.timestamp),
                  yValueMapper: (AguaConsumida consumo, _) =>
                      consumo.waterConsumed,
                  name: 'Agua consumida (metros cúbicos)',
                  // Enable data label
                  dataLabelSettings: const DataLabelSettings(isVisible: false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Construcción de gráfico con información de consumo anual
class ConsumoActualDeAguaAnual extends StatelessWidget {
  final List<AguaConsumida> data;
  final String tituloGrafico;

  const ConsumoActualDeAguaAnual(
      {super.key, required this.data, required this.tituloGrafico});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 35.0, right: 10, left: 10, bottom: 10),
      child: Card(
        child: Column(
          children: [
            SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(
                text: tituloGrafico,
                textStyle: const TextStyle(
                  fontFamily: 'Lato',
                  color: Colors.black,
                ),
              ),
              // Enable legend
              //legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<AguaConsumida, String>>[
                LineSeries<AguaConsumida, String>(
                  dataSource: data,
                  xValueMapper: (AguaConsumida consumo, _) =>
                      DateFormat.yMMMM('es_MX').format(consumo.timestamp),
                  yValueMapper: (AguaConsumida consumo, _) =>
                      consumo.waterConsumed,
                  name: 'Agua consumida (metros cúbicos)',
                  // Enable data label
                  dataLabelSettings: const DataLabelSettings(isVisible: false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
