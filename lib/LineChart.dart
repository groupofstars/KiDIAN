
import 'package:flutter/material.dart';
// import 'package:flutter_charts/flutter_charts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show Color, rootBundle;
import 'dart:io';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:kidian/language/languages.dart';
// Future<Map<String, dynamic>?> loadData(String table,String where_name,String name) async {
//   final db = await openDB();
//   final List<Map<String, dynamic>> data = await db.query(table, where: where_name + ' = ?',whereArgs : [name] );
//   return data.isNotEmpty? data.first : null;
// }


class LineChartCustomized extends StatefulWidget {
  const LineChartCustomized({
    required this.isMale,
    required this.table,
    required this.labelColumn,
    required this.OMS_CDC,
    required this.currentX,
    required this.currentY,
    required this.yLabel,
    required this.title
  });

  final bool isMale;
  final String table;
  final String labelColumn;
  final bool OMS_CDC;
  final double currentX;
  final double currentY;
  final String yLabel;
  final String title;
  @override
  State<LineChartCustomized> createState() => _LineChartCustomizedState();
}
class ChildHeight {
  final double age;
  final double height;

  ChildHeight(this.age, this.height);
}
class _LineChartCustomizedState extends State<LineChartCustomized> {
  late bool isShowingMainData;
  double width=1000;
  double height=1000;
  int samplingCount=50;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }
  Future<Database> openDB() async {
    final dbPath = await getDatabasesPath();
    final path;
    if(widget.OMS_CDC)
      path = dbPath + '/1122.db';
    else path = dbPath + '/cdc.db';

    if(!File(path).existsSync()){
      final dbData ;
      if(widget.OMS_CDC)
        dbData = await rootBundle.load('assets/123.db');
      else dbData = await rootBundle.load('assets/cdc.db');

      await File(path).writeAsBytes(dbData.buffer.asUint8List());
    }


    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      // Create the table if it doesn't exist
      await db.execute('CREATE TABLE IF NOT EXISTS my_table (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)');
    });
  }
  Future<List<Map<String, dynamic>>?> fetchValues(String name) async {
    final db = await openDB();
    String sex;
    if(widget.isMale) sex="1";
    else sex="2";
    String query;
    if(widget.OMS_CDC)
      query="SELECT * FROM "+ widget.table + " ;";
    else
      query="SELECT * FROM "+ widget.table +" WHERE sex = "+ sex +" ;";

    final List<Map<String, dynamic>> data = await db.rawQuery(query);
    await db.close();
    return data.isNotEmpty? data : null;
  }
  Future<List<Map<String, dynamic>>?> fetchTableInfo() async {
    final db = await openDB();
    final List<Map<String, dynamic>> data = await db.rawQuery("PRAGMA table_info("+ widget.table +");",);
    await db.close();
    return data.isNotEmpty? data : null;
    // Execute the query

  }
  Future<int?> getTableRowsCount(bool isMale) async {
    final db = await openDB();
    String sex;
    if(isMale) sex="1";
    else sex="2";
    String query;
    if(widget.OMS_CDC)
      query="SELECT COUNT(*) AS M FROM "+ widget.table + " ;";
    else
      query="SELECT COUNT(*) AS M FROM "+ widget.table +" WHERE sex = "+ sex +" ;";
    final List<Map<String, dynamic>> data = await db.rawQuery(query);
    await db.close();

    return data.first['M'];
    // Execute the query

  }
  Future<Widget> chartToRun(int samplingCount) async {

    Locale lo=WidgetsBinding.instance.window.locale;
    List<List<ChildHeight>> dataRows = [];

    List<String> filteredNames = [];

    var data=await fetchTableInfo();
    String? xLabel;
    data?.forEach((record) {
      String name = record['name'];
      if(name=='Month'||name=='Agemos') xLabel='Edad (meses)';
      else if(name=='Day'||name=='Age') xLabel='Edad (dias)';
      else if(name=='Length') xLabel='Longitud (cm)';
      else if(name=='Height') xLabel='Estatura (cm)';
      if (name != 'StDev' &&name != 'Month' &&name != 'Agemos' && name != 'Sex' && name != 'Length' && name != 'Height' && name != 'Age' && name != 'Day' &&name != 'L' && name != 'M' && name != 'S') {
        filteredNames.add(name);
      }
    });
    // print(filteredNames);
    var result = await fetchValues(widget.table);
    data = result!;



    int desiredLength = samplingCount;

    int? dataLength = await getTableRowsCount(widget.isMale);

    if (desiredLength >   dataLength!) {
      // Handle the case when the desired length is greater than the original data length
      desiredLength = dataLength;
    }

    double interval = (dataLength - 1) / (desiredLength - 1);

    for (int i = 0; i < filteredNames.length; i++) {
      dataRows.add(
          List.generate(desiredLength, (index) {
            int originalIndex = (index * interval).round();
            return ChildHeight(data!.map((item) => item[widget.labelColumn]).toList()[originalIndex].toDouble() ,data!.map((item) => item[filteredNames[i]]).cast<double>().toList()[originalIndex]);
          })
      );
    }


    List<LineSeries<ChildHeight, double>> seriesList = dataRows.map((row) {

      return LineSeries<ChildHeight, double>(
        dataSource: row,
        xValueMapper: (ChildHeight height, _) => height.age,
        yValueMapper: (ChildHeight height, _) => height.height,
        // xAxisName: "Age",
        // yAxisName: "Height",
        markerSettings: MarkerSettings(
          isVisible: false,
          color: Colors.blue,
          borderColor: Colors.transparent,
          shape: DataMarkerType.diamond,
          width: 5 ,
          height: 5,


        ),
        name: '${filteredNames[dataRows.indexOf(row)]}',
          dataLabelSettings: DataLabelSettings(isVisible: false)
      );
    }).toList();
    seriesList.add(LineSeries<ChildHeight, double>(
        dataSource: [ChildHeight(widget.currentX, widget.currentY)],
        xValueMapper: (ChildHeight height, _) => height.age,
        yValueMapper: (ChildHeight height, _) => height.height,
        markerSettings: MarkerSettings(
          isVisible: true,
          color:  Colors.red,
          shape: DataMarkerType.diamond,
          width: 18 ,
          height: 18,
          borderWidth: 0
          // image: AssetImage('assets/marker.png'),

        ),

        name: 'actual',
        dataLabelSettings: DataLabelSettings(isVisible: true)
    ));
    var lineChart = SfCartesianChart(
      primaryXAxis: NumericAxis(title: AxisTitle(text: xLabel)),
      primaryYAxis: NumericAxis(title: AxisTitle(text: widget.yLabel)),

      // legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      trackballBehavior: TrackballBehavior(
          enable: true,
          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints
      ),
      series: seriesList,

    );

    return lineChart;
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = screenHeight * 0.09;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appBarHeight),
          child: AppBar(
            backgroundColor: Colors.deepPurpleAccent,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                widget.title,
                style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width*0.045,
                fontWeight: FontWeight.bold,
                ),
                ),

                Image.asset(
                'assets/1.png',
                width: 40,
                height: 40,
                color: Colors.white,
                ),
              ],
            ),
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(6),
              child: Container(
                color: Colors.grey[300],
                height: 6,
              ),
            ),
          ),
        ),
      body:
      Container(
      // aspectRatio: 1.13,
      child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 17,
              ),
              // const Text(
              //   'T/E boys percentile',
              //   style: TextStyle(
              //     color: Colors.black87,
              //     fontSize: 14,
              //     fontWeight: FontWeight.bold,
              //     letterSpacing: 2,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              // const SizedBox(
              //   height: 17,
              // ),
        Expanded(
          child:
              // SingleChildScrollView(
              //   scrollDirection: Axis.vertical,
              //   child:SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //   child:
                Container(
                    color: Colors.white,
                    width:width,// Set the background color to red
                    height: height,
                    child:
                    FutureBuilder<Widget>(
                        future: chartToRun(samplingCount),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            // Show a loading indicator while the chart is being fetched
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            // Handle any errors that occur during the chart fetching
                            return Text('Error: ${snapshot.error}');
                          } else {
                            // Display the chart when the data is available
                            return Container(
                              width: double.infinity, // Adjust the width to occupy the available space
                              child: snapshot.data ?? Container(), // Return an empty container if the data is null
                            );
                          }
                        },

                  //    ),
                  // ),
                ),
              ),
            ),

              // const SizedBox(
              //   height: 10,
              // ),
              Row(
                children:[
                  // SizedBox(width: 10,),
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.refresh,
                  //     color: Colors.deepOrangeAccent.withOpacity(isShowingMainData ? 1.0 : 0.5),
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       width=1000;
                  //       height=1000;
                  //       samplingCount=50;
                  //     });
                  //   },
                  // ),

                  // Expanded(
                  //   child: Slider(
                  //     value: samplingCount.toDouble(),
                  //     max: 500,
                  //     divisions: 100,
                  //     activeColor: Colors.green, // Set the desired color for the active portion of the slider
                  //     inactiveColor: Colors.deepPurpleAccent,
                  //     label: (samplingCount-10).round().toString(),
                  //     onChanged: (double value) {
                  //       setState(() {
                  //         if(value+10>=500) samplingCount=500;
                  //         else samplingCount = (value+10).toInt();
                  //       });
                  //     },
                  //   ),
                  // ),
                  // Expanded(
                  //   child: Slider(
                  //     value: width / 20,
                  //     max: 500,
                  //     divisions: 50,
                  //     label: (width / 20).round().toString(),
                  //     onChanged: (double value) {
                  //       setState(() {
                  //         if(value+10>500) width=500*20;
                  //         else width = (value+10) * 20;
                  //       });
                  //     },
                  //   ),
                  // ),
                  // Expanded(
                  //   // Set the desired width here
                  //   child: Slider(
                  //     value: height / 4,
                  //     max: 500,
                  //     divisions: 50,
                  //     activeColor: Colors.blue, // Set the desired color for the active portion of the slider
                  //     inactiveColor: Colors.grey,
                  //     label: (height / 4).round().toString(),
                  //     onChanged: (double value) {
                  //       setState(() {
                  //         if(value+10>500) height=500*4;
                  //         else height = (value+10) * 4;
                  //       });
                  //     },
                  //   ),
                  // ),
                ],
              )
            ],
          ),

      ),
    );
  }
}