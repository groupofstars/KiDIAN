import 'dart:io';

import 'package:flutter/services.dart';

import 'package:sqflite/sqflite.dart';

import 'package:flutter/material.dart';
// import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'graph.dart';

class CDC extends StatefulWidget {
  const CDC({
    super.key,
    required this.title,
    required this.isMale,
    required this.isSelected_A,
    required this.isSelected_B,
    required this.year,
    required this.month,
    required this.day,
    required this.weight,
    required this.tall,
    required this.imc,
    required this.headlength
  });

  final String title;

  final bool isMale;
  final bool isSelected_A;
  final bool isSelected_B;
  final int  year ;
  final int  month ;
  final int  day ;
  final double  weight ;
  final double  tall ;
  final double  imc ;
  final String  headlength ;

  @override
  State<CDC> createState() => _CDCState();
}

class _CDCState extends State<CDC> {

  // bool _isFemale = false;
  bool isSwitched=false;

  TextEditingController  weight_tall=TextEditingController();
  TextEditingController  weight_age=TextEditingController();
  TextEditingController  tall_age=TextEditingController();
  TextEditingController  headlength_age=TextEditingController();
  TextEditingController  fat_age=TextEditingController();

  List<List<String>> item_table=[
    ["NA","NA","NA"],
    ["NA","NA","NA"],
    ["NA","NA","NA"],
    ["NA","NA","NA"],
    ["NA","NA","NA"]
  ];

  double currentIMC=1;
  bool pt_formula=false;

  List<String> items = [
    //'MÉTODO',
    'Puntuación Z',
    'Percentiles',
    '% de la Mediana'
  ];
  List<double> pt_=List<double>.filled(3,1000);
  List<double> imc_=List<double>.filled(3,1000);
  List<double> te_=List<double>.filled(3,1000);

  String? ptTable='NA';
  String? imcTable='NA';
  String? teTable='NA';
  String? ptTablez='NA';
  String? imcTablez='NA';
  String? teTablez='NA';

  String? ptTableLabel='NA';
  String? imcTableLabel='NA';
  String? teTableLabel='NA';
  String? ptTablezLabel='NA';
  String? imcTablezLabel='NA';
  String? teTablezLabel='NA';


  String selectedItem = 'Puntuación Z';
  String diagnoseResult='No se puede diagnosticar.';
///////////////////////////////////////////////////////////////////////////////

  Future<Database> openDB() async {


    final dbPath = await getDatabasesPath();
    // final path = join(dbPath, '123.db');
    final path = dbPath + '/cdc.db';
    if(!File(path).existsSync()){
      final dbData = await rootBundle.load('assets/cdc.db');

      await File(path).writeAsBytes(dbData.buffer.asUint8List());
    }


    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      // Create the table if it doesn't exist
      await db.execute('CREATE TABLE IF NOT EXISTS my_table (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)');
    });
  }

  Future<Map<String, dynamic>?> loadData(String table,String where_one,String one,String where_two,String two) async {
    final db = await openDB();
    //final List<Map<String, dynamic>> data = await db.query(table, where: where_name + ' ='+name);
    final List<Map<String, dynamic>> data = await db.query(table, where: where_one + ' = ? AND ' + where_two + ' > ?', whereArgs: [one, two]);
    return data.isNotEmpty? data.first : null;
  }

void diagnose(){
  String tempResult='No se puede diagnosticar.';

  if(selectedItem=='Puntuación Z'){
    double pt=pt_[0];
    double imc=imc_[0];
    double te=te_[0];
    if(te!=1000&&(imc!=1000||pt!=1000)) {
      print("pt="+ pt.toString());
      print("imc="+ imc.toString());
      print("te="+ te.toString());
      if ((1 > pt && pt > -1 || 0.9 >= imc && imc >= -0.9) &&
          (te > -2 && te < 3)) {
        tempResult = 'EUTRÓFICO (peso y estatura adecuados)';
      }
      else if ((-1 >= pt && pt > -2 || -1 >= imc && imc > -2) &&
          (te > -2 && te < 3)) {
        tempResult = 'DESNUTRICIÓN AGUDA DE INTENSIDAD LEVE (emaciación)';
      }
      else if ((-2 >= pt && pt > -3 || -2 >= imc && imc > -3) &&
          (te > -2 && te < 3)) {
        tempResult = 'DESNUTRICIÓN AGUDA DE INTENSIDAD MODERADA (emaciación)';
      }
      else if ((-3 >= pt || -3 >= imc) && (te > -2 && te < 3)) {
        tempResult =
        'DESNUTRICIÓN AGUDA DE INTENSIDAD GRAVE (severamente emaciaciado)';
      }
      //////////1111
      else if ((2 > pt && pt >= 1 || 2 > imc && imc >= 1) &&
          (te >= -2 && te < 3)) {
        tempResult = 'SOBREPESO';
      }
      else
      if ((3 > pt && pt >= 2 || 3 > imc && imc >= 2) && (te >= -2 && te < 3)) {
        tempResult = 'OBESIDAD';
      }
      else if ((3.5 > pt && pt >= 3 || 3.5 > imc && imc >= 3) &&
          (te >= -2 && te < 3)) {
        tempResult = 'OBESIDAD EXTREMA ';
      }

      else if ((3.5 <= pt && pt!=1000 || 3.5 <= imc && imc!=1000) && (te >= -2 && te < 3)) {

        tempResult = 'OBESIDAD MÓRBIDA';
      }
      //////////2222
      else if ((1 > pt && pt > -1 || 1 > imc && imc > -1) && (te >= 3)) {
        tempResult = 'NORMOPESO CON ESTATURA ELEVADA PARA LA EDAD';
      }
      else if ((-1 >= pt && pt > -2 || -1 >= imc && imc > -2) && (te >= 3)) {
        tempResult =
        'DESNUTRICIÓN AGUDA DE INTENSIDAD LEVE (emaciación) CON ESTATURA ELEVADA PARA LA EDAD';
      }
      else if ((-2 >= pt && pt > -3 || -2 >= imc && imc > -3) && (te >= 3)) {
        tempResult =
        'DESNUTRICIÓN AGUDA DE INTENSIDAD MODERADA (emaciación) CON ESTATURA ELEVADA PARA LA EDAD';
      }
      else if ((-3 >= pt || -3 >= imc) && (te >= 3)) {
        tempResult =
        'DESNUTRICIÓN AGUDA DE INTENSIDAD GRAVE (severamente emaciaciado) CON ESTATURA ELEVADA PARA LA EDAD';
      }
      ///////333fsdf
      else if ((2 > pt && pt >= 1 || 2 > imc && imc >= 1) && (te >= 3)) {
        tempResult = 'SOBREPESO CON ESTATURA ELEVADA PARA LA EDAD';
      }
      else if ((3 > pt && pt >= 2 || 3 > imc && imc >= 2) && (te >= 3)) {
        tempResult = 'OBESIDAD CON ESTATURA ELEVADA PARA LA EDAD';
      }
      else if ((3.5 > pt && pt >= 3 || 3.5 > imc && imc >= 3) && (te >= 3)) {
        tempResult = 'OBESIDAD EXTREMA CON ESTATURA ELEVADA PARA LA EDAD';
      }
      else if ((3.5 <= pt && pt!=1000 || 3.5 <= imc && imc!=1000) && (te >= 3)) {
        tempResult = 'OBESIDAD MÓRBIDA CON ESTATURA ELEVADA PARA LA EDAD';
      }
      ///////4444
      else if ((1 > pt && pt > -1 || 1 > imc && imc > -1) &&
          (te > -3 && te <= -2)) {
        tempResult = 'NORMOPESO CON DETENCIÓN DEL CRECIMIENTO';
      }
      else if ((-1 >= pt && pt > -2 || -1 >= imc && imc > -2) &&
          (te > -3 && te <= -2)) {
        tempResult =
        'DESNUTRICIÓN AGUDA DE INTENSIDAD LEVE (emaciación) CON DETENCIÓN DEL CRECIMIENTO';
      }
      else if ((-2 >= pt && pt > -3 || -2 >= imc && imc > -3) &&
          (te > -3 && te <= -2)) {
        tempResult =
        'DESNUTRICIÓN AGUDA DE INTENSIDAD MODERADA (emaciación) CON DETENCIÓN DEL CRECIMIENTO';
      }
      else if ((-3 >= pt || -3 >= imc) && (te > -3 && te <= -2)) {
        tempResult =
        'DESNUTRICIÓN AGUDA DE INTENSIDAD GRAVE (severamente emaciaciado) CON DETENCIÓN DEL CRECIMIENTO';
      }
      ////
      else if ((2 > pt && pt >= 1 || 2 > imc && imc >= 1) &&
          (te > -3 && te <= -2)) {
        tempResult = 'SOBREPESO CON DETENCIÓN DEL CRECIMIENTO';
      }
      else
      if ((3 > pt && pt >= 2 || 3 > imc && imc >= 2) && (te > -3 && te <= -2)) {
        tempResult = 'OBESIDAD CON DETENCIÓN DEL CRECIMIENTO';
      }
      else if ((3.5 > pt && pt >= 3 || 3.5 > imc && imc >= 3) &&
          (te > -3 && te <= -2)) {
        tempResult = 'OBESIDAD EXTREMA CON DETENCIÓN DEL CRECIMIENTO';
      }
      else if ((3.5 <= pt && pt!=1000 || 3.5 <= imc && imc!=1000) && (te > -3 && te <= -2)) {
        tempResult = 'OBESIDAD MÓRBIDA CON DETENCIÓN DEL CRECIMIENTO';
      }
      ////
      else if ((1 > pt && pt > -1 || 1 >= imc && imc > -1) &&
          (te <= -3)) {
        tempResult = 'NORMOPESO CON ESTATURA BAJA PARA LA EDAD';
      }
      else
      if ((-1 >= pt && pt > -2 || -1 >= imc && imc > -2) && (te <= -3)) {
        tempResult =
        'DESNUTRICIÓN CRÓNICO AGUDIZADA DE INTENSIDAD LEVE (emaciación y desmedro)';
      }
      else
      if ((-2 >= pt && pt > -3 || -2 >= imc && imc > -3) && (te <= -3)) {
        tempResult =
        'DESNUTRICIÓN CRÓNICO AGUDIZADA DE INTENSIDAD MODERADA (emaciación y desmedro)';
      }
      else if ((-3 >= pt || -3 >= imc) && (te <= -3)) {
        tempResult =
        'DESNUTRICIÓN CRÓNICO AGUDIZADA DE INTENSIDAD GRAVE (emaciación y desmedro)';
      }
      ////
      else if ((2 > pt && pt >= 1 || 2 > imc && imc >= 1) && (te <= -3)) {
        tempResult = 'SOBREPESO CON ESTATURA BAJA PARA LA EDAD';
      }
      else if ((3 > pt && pt >= 2 || 3 > imc && imc >= 2) && (te <= -3)) {
        tempResult = 'OBESIDAD CON ESTATURA BAJA PARA LA EDAD';
      }
      else if ((3.5 > pt && pt >= 3 || 3.5 > imc && imc >= 3) && (te <= -3)) {
        tempResult = 'OBESIDAD EXTREMA CON ESTATURA BAJA PARA LA EDAD';
      }
      else if ((3.5 <= pt && pt!=1000 || 3.5 <= imc && imc!=1000) && (te <= -3)) {
        tempResult = 'OBESIDAD MÓRBIDA CON ESTATURA BAJA PARA LA EDAD';
      }
    }
  }
  else if(selectedItem=='Percentiles'){
    double pt=pt_[1];
    double imc=imc_[1];
    double te=te_[1];
    if(te!=1000&&(imc!=1000||pt!=1000)) {
      if ((85 > pt && pt >= 10 || 85 > imc && imc >= 10) &&
          (te >= 5 && te <= 95)) {
        tempResult = 'EUTRÓFICO (peso y estatura adecuados)';
      }
      else if ((10 >= pt && pt >= 5 || 10 >= imc && imc >= 5) &&
          (te >= 5 && te <= 95)) {
        tempResult = 'RIESGO DE DESNUTRICIÓN';
      }
      else if ((5 >= pt || 5 >= imc) && (te >= 5 && te <= 95)) {
        tempResult = 'DESNUTRICIÓN';
      }
      else if ((95 > pt && pt >= 85 || 95 > imc && imc >= 85) &&
          (te >= 5 && te <= 95)) {
        tempResult = 'SOBREPESO';
      }
      else if ((120 >= imc && imc >= 95) && (te >= 5 && te <= 95)) {
        tempResult = 'OBESIDAD (Clase I)';
      }
      else if ((140 > imc && imc >= 120) && (te >= 5 && te <= 95)) {
        tempResult = 'OBESIDAD SEVERA (Clase II)';
      }
      else if ((imc >= 140 && imc!= 1000) && (te >= 5 && te <= 95)) {
        tempResult = 'OBESIDAD MÓRBIDA (Clase III)';
      }
      else if ((85 > pt && pt >= 10 || 84 >= imc && imc >= 10) && (te <= 5)) {
        tempResult = 'NORMOPESO CON TALLA BAJA PARA LA EDAD';
      }
      else if ((10 > pt && pt >= 5 || 84 >= imc && imc >= 10) && (te <= 5)) {
        tempResult = 'RIESGO DE DESNUTRICIÓN CON TALLA BAJA PARA LA EDAD';
      }
      else if ((5 >= pt || 5 >= imc) && (te <= 5)) {
        tempResult = 'DESNUTRICIÓN con estatura baja para la edad';
      }
      else if ((95 > pt && pt >= 85 || 95 > imc && imc >= 85) && (te <= 5)) {
        tempResult = 'SOBREPESO CON TALLA BAJA PARA LA EDAD';
      }
      else if ((120 >= imc && imc >= 95) && (te <= 5)) {
        tempResult = 'OBESIDAD (Clase I) CON TALLA BAJA PARA LA EDAD';
      }
      else if ((140 > imc && imc >= 120) && (te <= 5)) {
        tempResult = 'OBESIDAD SEVERA (Clase II) CON TALLA BAJA PARA LA EDAD';
      }
      else if ((140 <= imc && imc!=1000) && (te <= 5)) {
        tempResult = 'OBESIDAD MÓRBIDA (Clase III) CON TALLA BAJA PARA LA EDAD';
      }
      else if ((85 > pt && pt >= 10 || 84 >= imc && imc >= 10) && (te >= 95)) {
        tempResult = 'NORMOPESO CON ESTATURA ELEVADA PARA LA EDAD';
      }
      else if ((10 > pt && pt >= 5 || 10 > imc && imc >= 5) && (te >= 95)) {
        tempResult = 'RIESGO DE DESNUTRICIÓN con estatura elevada para la edad';
      }
      else if ((5 >= pt || 5 >= imc) && (te >= 95)) {
        tempResult = 'DESNUTRICIÓN con estatura elevada para la edad';
      }
      else if ((95 > pt && pt >= 85 || 95 > imc && imc >= 85) && (te >= 95)) {
        tempResult = 'SOBREPESO con estatura elevada para la edad';
      }
      else if ((120 >= imc && imc >= 95) && (te >= 95)) {
        tempResult = 'OBESIDAD (Clase I) con estatura elevada para la edad';
      }
      else if ((140 > imc && imc >= 120) && (te >= 95)) {
        tempResult =
        'OBESIDAD SEVERA (Clase II) con estatura elevada para la edad';
      }
      else if ((140 <= imc && imc!=1000) && (te >= 95)) {
        tempResult =
        'OBESIDAD MÓRBIDA (Clase III) con estatura elevada para la edad';
      }
      else if(pt>=95) tempResult='OBESIDAD';
    }
  }
  else if(selectedItem=='% de la Mediana'){
    double pt=pt_[2];
    double imc=imc_[2];
    double te=te_[2];

    if(te!=1000&&(imc!=1000||pt!=1000)) {
      if ((110 > pt && pt >= 90) && (te >= 95 && te <= 105)) {
        tempResult = 'EUTRÓFICO (peso y talla adecuados)';
      }
      else if ((90 > pt && pt >= 80) && (te >= 95 && te <= 105)) {
        tempResult = 'DESNUTRICIÓN AGUDA DE INTENSIDAD LEVE (emaciación)';
      }
      else if ((80 > pt && pt >= 70) && (te >= 95 && te <= 105)) {
        tempResult = 'DESNUTRICIÓN AGUDA DE INTENSIDAD MODERADA (emaciación)';
      }
      else if ((70 > pt) && (te >= 95 && te <= 105)) {
        tempResult = 'DESNUTRICIÓN AGUDA DE INTENSIDAD GRAVE (emaciación)';
      }
      else if ((110 > pt && pt >= 90) && (te < 95)) {
        tempResult =
        'DESNUTRICIÓN CRÓNICO COMPENSADA  (peso adecuado para la talla con talla baja para la edad)';
      }
      else if ((90 > pt && pt >= 80) && (te < 95)) {
        tempResult =
        'DESNUTRICIÓN CRÓNICO AGUDIZADA DE INTENSIDAD LEVE (emaciación y desmedro)';
      }
      else if ((80 > pt && pt >= 70) && (te < 95)) {
        tempResult =
        'DESNUTRICIÓN CRÓNICO AGUDIZADA DE INTENSIDAD MODERADA (emaciación y desmedro)';
      }
      else if ((70 > pt) && (te < 95)) {
        tempResult =
        'DESNUTRICIÓN CRÓNICO AGUDIZADA DE INTENSIDAD GRAVE (emaciación y desmedro)';
      }
      else if ((120 > pt && pt >= 110) && (95 > te)) {
        tempResult = 'SOBREPESO CON TALLA BAJA PARA LA EDAD';
      }
      else if ((pt >= 120 && pt!=1000) && (95 > te)) {
        tempResult = 'OBESIDAD CON TALLA BAJA PARA LA EDAD';
      }

      else if ((120 > pt && pt >= 110) && (105 >= te && te > 95)) {
        tempResult = 'SOBREPESO';
      }
      else if ((pt >= 120 && pt!=1000) && (105 >= te && te > 95)) {
        tempResult = 'OBESIDAD';
      }

      else if ((110 > pt && pt >= 90) && (te > 105)) {
        tempResult = 'NORMOPESO CON TALLA ELEVADA PARA LA EDAD';
      }
      else if ((90 > pt && pt >= 80) && (te > 105)) {
        tempResult =
        'DESNUTRICIÓN AGUDA DE INTENSIDAD LEVE (emaciación) CON TALLA ELEVADA PARA LA EDAD';
      }
      else if ((80 > pt && pt >= 70) && (te > 105)) {
        tempResult =
        'DESNUTRICIÓN AGUDA DE INTENSIDAD MODERADA (emaciación) CON TALLA ELEVADA PARA LA EDAD';
      }
      else if ((70 > pt) && (te > 105)) {
        tempResult =
        'DESNUTRICIÓN AGUDA DE INTENSIDAD GRAVE (emaciación) CON TALLA ELEVADA PARA LA EDAD';
      }
      else if ((120 > pt && pt >= 110) && (te > 105)) {
        tempResult = 'SOBREPESO CON TALLA ELEVADA PARA LA EDAD';
      }
      else if ((pt >= 120 && pt!=1000) && (te > 105)) {
        tempResult = 'OBESIDAD CON TALLA ELEVADA PARA LA EDAD';
      }       // in here imc is missed now
    }
  }
  setState(() {
    diagnoseResult=tempResult!;
  });
}
////////////////////////////////////////////////////////////////////////////

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();

    // weight_tall.text=(widget.weight/(widget.tall*0.01)).toStringAsFixed(2);
    // weight_age.text=(widget.weight).toStringAsFixed(2);
    // tall_age.text=(widget.tall).toStringAsFixed(2);
    // headlength_age.text=(widget.headlength).toStringAsFixed(2);
    // fat_age.text=(widget.imc).toStringAsFixed(2);





    ////////////////////////////////        *P/E
    String days='';
    double months=0;
    days=((widget.year*12*30.4375+widget.month*30.4375+widget.day).toInt()).toString();
    months=widget.year*12+widget.month+widget.day*0.0247;

    String table = ' ';
    String filter_cond='';
    String filter_value='';
    String sex="1";
    if(months<=240) {
      if (widget.isMale) {
          sex="1";
      }
      else {
          sex="2";
      }
      if(months<36) {
        table = 'wtageinf';
      }
      else
      {
        table = 'wtage';
      }
      filter_value=((months.round()).toInt()).toString()+'.5';
      loadData(table,'Sex',sex,'Agemos', filter_value).then((result) {
        var data = result;
        final meduim = data?['M'];
        var percent;
        var delta = 1000.0;
        var currentValue;
        var milestoneValue;

        data?.forEach((key, value) {
          if (key != 'Sex' &&key != 'Agemos' && key != 'L' && key != 'M' && key != 'S') {
            if (delta > (widget.weight - value).abs()) {
              delta = (widget.weight - value).abs();
              percent = key;
              currentValue=widget.weight;
              milestoneValue=value;
            }
          }
        });

        int indexOfKey=data!.keys.toList().indexOf(percent);
        if(currentValue>milestoneValue){
          indexOfKey++;
        }

        if(indexOfKey!=-1&&indexOfKey>5&&indexOfKey<=13){
          var previousKey=data!.keys.toList()[indexOfKey-1];
          var nextKey=data!.keys.toList()[indexOfKey];
          int previousNumber=int.parse(RegExp(r'\d+').firstMatch(previousKey)![0]!);
          int nextNumber=int.parse(RegExp(r'\d+').firstMatch(nextKey)![0]!);
          var previouseValue=data[previousKey];
          var nextValue=data[nextKey];
          percent=((currentValue-previouseValue)*(nextNumber-previousNumber)/(nextValue-previouseValue)+previousNumber).toStringAsFixed(1);
          // percent=((currentValue-previouseValue)*(nextNumber-previousNumber)/(nextValue-previouseValue)+previousNumber).toStringAsFixed(1)+"%";
        }
        else{
          percent=percent.replaceAll('P', '');
          if(currentValue>=data[data!.keys.toList()[13]]){
            percent=((97*currentValue)/data[data!.keys.toList()[13]]).toStringAsFixed(1);
          }
          else if(currentValue<data[data!.keys.toList()[5]]){
            percent=((3*currentValue)/data[data!.keys.toList()[5]]).toStringAsFixed(1);
          }
        }

        setState(() {
          item_table[2][2] = (100*widget.weight/meduim).toStringAsFixed(2);
          weight_age.text=(meduim).toStringAsFixed(1);

          item_table[2][1] = percent;
        });

        // Do something with the age variable
      });
      //print(months.toString()+"months");
      if(months<36) {
          table = 'zwtageinf';
      }
      else {
          table = 'zwtage';
      }
      filter_value=((((widget.year*12+widget.month+widget.day*0.0247)*2).round())/2).toStringAsFixed(1);

      // double value = ((widget.year * 12 + widget.month + widget.day * 0.0247) * 2).round() / 2;
      // filter_value = value.toStringAsFixed(1);
      // if (value % 1 == 0) {
      //   filter_value = value.toInt().toString();
      // }

      loadData(table, 'Sex',sex,'Agemos', filter_value).then((result) {
        var data = result;
        var zscore;
        var delta = 1000.0;
        var currentValue;
        var milestoneValue;
        data?.forEach((key, value) {
          if (key != 'Sex' &&key != 'Agemos' && key != 'L' && key != 'M' && key != 'S') {
            if (delta > (widget.weight - value).abs()) {
              delta = (widget.weight - value).abs();
              zscore = key;
              currentValue=widget.weight;
              milestoneValue=value;
            }
          }
        });
        int indexOfKey=data!.keys.toList().indexOf(zscore);
        if(currentValue>milestoneValue){
          indexOfKey++;
        }

        if(indexOfKey!=-1&&indexOfKey>2&&indexOfKey<=10){
          var previousKey=data!.keys.toList()[indexOfKey-1];
          var nextKey=data!.keys.toList()[indexOfKey];
          double previousNumber=double.parse(previousKey);
          double nextNumber=double.parse(nextKey);
          var previouseValue=data[previousKey];
          var nextValue=data[nextKey];
          zscore=((currentValue-previouseValue)*(nextNumber-previousNumber)/(nextValue-previouseValue)+previousNumber).toStringAsFixed(1);
        }
        else{

        }

        setState(() {
          item_table[2][0] = zscore;
        });
      });
    }

    /////////////////////////////////////////////



    ////////////////////////////////        *IMC/E

    if(months>=24&&months<=240.5) {
      table = 'bmiagerev';
      filter_value=((months.round()).toInt()).toString()+'.5';

      imcTable=table;
      imcTableLabel='Agemos';

      loadData(table,'Sex',sex,'Agemos', filter_value).then((result) {
        var data = result;
        final meduim = data?['M'];
        setState(() {
          if(pt_formula){
            item_table[0][2] = (100*widget.weight/(meduim*widget.tall*widget.tall*0.0001)).toStringAsFixed(2);
            pt_[2]=double.parse(item_table[0][2]);
            weight_tall.text=(meduim*widget.tall*widget.tall*0.0001).toStringAsFixed(1);
          }
        });
        //print(currentIMC);
        var percent;
        var delta = 1000.0;
        var currentValue;
        var milestoneValue;
        data?.forEach((key, value) {
          if (key != 'Sex' &&key != 'Agemos' && key != 'L' && key != 'M' && key != 'S') {
            if (delta > (widget.imc - value).abs()) {
              delta = (widget.imc - value).abs();
              percent = key;
              currentValue=widget.imc;

              milestoneValue=value;
            }
          }
        });


        int indexOfKey=data!.keys.toList().indexOf(percent);
        if(currentValue>milestoneValue){
          indexOfKey++;
        }
        double tmp_imc_p=1000;
        if(indexOfKey!=-1&&indexOfKey>6&&indexOfKey<=14){
          var previousKey=data!.keys.toList()[indexOfKey-1];
          var nextKey=data!.keys.toList()[indexOfKey];
          int previousNumber=int.parse(RegExp(r'\d+').firstMatch(previousKey)![0]!);
          int nextNumber=int.parse(RegExp(r'\d+').firstMatch(nextKey)![0]!);
          var previouseValue=data[previousKey];
          var nextValue=data[nextKey];
          percent=(currentValue-previouseValue)*(nextNumber-previousNumber)/(nextValue-previouseValue)+previousNumber;
          percent=percent.toStringAsFixed(1);
          // if(percent<=5) percent="<= 5";
          // else if(percent<85) percent="5 a 84";
          // else if(percent<95) percent="85 a 94";
          tmp_imc_p=double.parse(percent);


        }
        else{
          percent=percent.replaceAll('P', '');
          if(currentValue>=data[data!.keys.toList()[13]])
          {
            tmp_imc_p=(95*currentValue)/data[data!.keys.toList()[13]];
            percent=((95*currentValue)/data[data!.keys.toList()[13]]).toStringAsFixed(1)+'% \n> P95';
          }
          else if(currentValue<data[data!.keys.toList()[5]]){
            percent=((3*currentValue)/data[data!.keys.toList()[5]]).toStringAsFixed(1);
            tmp_imc_p=double.parse(percent);
          }
        }


        setState(() {

          //currentIMC=meduim;
          if (meduim != Null) {
            item_table[1][2] = (100*widget.imc/meduim).toStringAsFixed(2);

            imc_[2]=double.parse(item_table[1][2]);
            fat_age.text=(meduim).toStringAsFixed(1);
          }
          item_table[1][1] = percent;

          imc_[1]=tmp_imc_p;  ////diagnose imc_
        });

        // Do something with the age variable
      });


      table = 'zbmiage';
      imcTablez=table;
      imcTablezLabel='Agemos';

      filter_value=((((widget.year*12+widget.month+widget.day*0.0247)*2).round())/2).toStringAsFixed(1);
      loadData(table,'Sex',sex,'Agemos', filter_value).then((result) {
        var data = result;
        var zscore;
        var delta = 1000.0;
        var currentValue;
        var milestoneValue;
        data?.forEach((key, value) {
          if (key != 'Sex' &&key != 'Agemos' && key != 'L' && key != 'M' && key != 'S') {
            if (delta > (widget.imc - value).abs()) {
              delta = (widget.imc - value).abs();
              zscore = key;
              currentValue=widget.imc;
              milestoneValue=value;
            }
          }
        });


        int indexOfKey=data!.keys.toList().indexOf(zscore);
        if(currentValue>milestoneValue){
          indexOfKey++;
        }

        if(indexOfKey!=-1&&indexOfKey>2&&indexOfKey<=10){
          var previousKey=data!.keys.toList()[indexOfKey-1];
          var nextKey=data!.keys.toList()[indexOfKey];

          double previousNumber=double.parse(previousKey);
          double nextNumber=double.parse(nextKey);
          var previouseValue=data[previousKey];
          var nextValue=data[nextKey];
          zscore=((currentValue-previouseValue)*(nextNumber-previousNumber)/(nextValue-previouseValue)+previousNumber).toStringAsFixed(1);
        }

        setState(() {
          item_table[1][0] = zscore;
          imc_[0]=double.parse(item_table[1][0]);
        });
      });
    }
    /////////////////////////////////////////////
    ////////////////////////////////        *P/T
    if(widget.tall<=121.5) {
      String length_or_height;

      if (months > 36) {
          table = 'wtstat';
          length_or_height = 'Height';
          ptTable=table;
      }
      else {
          table = 'wtleninf';
          length_or_height = 'Length';
          ptTable=table;
      }

      var PT = widget.weight;

      ptTableLabel=length_or_height;
      loadData(table, 'Sex',sex,length_or_height, (widget.tall).toStringAsFixed(1)).then((
          result) {
        var data = result;
        final meduim = data?['M'];
        var percent;
        var delta = 1000.0;
        var currentValue;
        var milestoneValue;
        data?.forEach((key, value) {
          if (key != 'Sex' && key != length_or_height && key != 'L' && key != 'M' &&
              key != 'S') {
            if (delta > (PT - value).abs()) {
              delta = (PT - value).abs();
              percent = key;
              currentValue=PT;
              milestoneValue=value;
            }
          }
        });

        int indexOfKey=data!.keys.toList().indexOf(percent);
        if(currentValue>milestoneValue){
          indexOfKey++;
        }
        int temp=13;
        if(table=='wtstat') temp=14;
        else temp=13;
        if(indexOfKey!=-1&&indexOfKey>5&&indexOfKey<=temp){
          var previousKey=data!.keys.toList()[indexOfKey-1];
          var nextKey=data!.keys.toList()[indexOfKey];
          int previousNumber=int.parse(RegExp(r'\d+').firstMatch(previousKey)![0]!);
          int nextNumber=int.parse(RegExp(r'\d+').firstMatch(nextKey)![0]!);
          var previouseValue=data[previousKey];
          var nextValue=data[nextKey];
          percent=((currentValue-previouseValue)*(nextNumber-previousNumber)/(nextValue-previouseValue)+previousNumber).toStringAsFixed(1);
        }
        else{
          percent=percent.replaceAll('P', '');
          if(currentValue>=data[data!.keys.toList()[temp]]){
            percent=((97*currentValue)/data[data!.keys.toList()[temp]]).toStringAsFixed(1);
          }
          else if(currentValue<data[data!.keys.toList()[5]]){
            percent=((3*currentValue)/data[data!.keys.toList()[5]]).toStringAsFixed(1);
          }
        }
        setState(() {
          if (meduim != Null) {
            item_table[0][2] = (100*widget.weight/meduim).toStringAsFixed(2);
            pt_[2]=double.parse(item_table[0][2]);
            weight_tall.text=(meduim).toStringAsFixed(1);

          }
          item_table[0][1] = percent;
          pt_[1]=double.parse(item_table[0][1]);

        });

        // Do something with the age variable
      });

      if (months > 36) {
        table = 'zwtstat';
        length_or_height = 'Height';
        ptTablez=table;
      }
      else {
        table = 'zwtleninf';
        length_or_height = 'Length';
        ptTablez=table;
      }

      ptTablezLabel=length_or_height;
      filter_value=(((widget.tall*2).round())/2).toStringAsFixed(1);
      loadData(table,'Sex',sex, length_or_height, filter_value).then((
          result) {
        var data = result;
        var zscore;
        var delta = 1000.0;
        var currentValue;
        var milestoneValue;
        data?.forEach((key, value) {
          if (key != 'Sex' && key != length_or_height && key != 'L' && key != 'M' &&
              key != 'S') {
            if (delta > (PT - value).abs()) {
              delta = (PT - value).abs();

              zscore = key;
              currentValue=PT;
              milestoneValue=value;
            }
          }
        });


        int indexOfKey=data!.keys.toList().indexOf(zscore);
        if(currentValue>milestoneValue){
          indexOfKey++;
        }

        if(indexOfKey!=-1&&indexOfKey>2&&indexOfKey<=10){
          var previousKey=data!.keys.toList()[indexOfKey-1];
          var nextKey=data!.keys.toList()[indexOfKey];
          double previousNumber=double.parse(previousKey);
          double nextNumber=double.parse(nextKey);
          var previouseValue=data[previousKey];
          var nextValue=data[nextKey];
          zscore=((currentValue-previouseValue)*(nextNumber-previousNumber)/(nextValue-previouseValue)+previousNumber).toStringAsFixed(1);
        }

        setState(() {
          item_table[0][0] = zscore;
          pt_[0]=double.parse(item_table[0][0]);
        });
      });
    }
    else{
      setState(() {
        //print(currentIMC);
        pt_formula=true;

      });
    }
    /////////////////////////////////////////////
    ////////////////////////////////        *T/E
    if(months<=240) {
     
      if(months>=36) {
          table = 'statage';
      }
      else {
          table = 'lenageinf';
      }

      filter_value=((months.round()).toInt()).toString()+'.5';
      teTable=table;
      teTableLabel='Agemos';
      print(months);
      print(table);
      loadData(table,'Sex',sex,'Agemos', filter_value).then((result) {
        var data = result;
        final meduim = data?['M'];
        var percent;
        var delta = 1000.0;
        var currentValue;
        var milestoneValue;

        data?.forEach((key, value) {
          if (key != 'Sex' &&key != 'Agemos' && key != 'L' && key != 'M' && key != 'S' && key != 'StDev') {
            if (delta > (widget.tall - value).abs()) {
              delta = (widget.tall - value).abs();
              percent = key;
              currentValue=widget.tall;
              milestoneValue=value;
            }
          }
        });

        int indexOfKey=data!.keys.toList().indexOf(percent);
        if(currentValue>milestoneValue){
          indexOfKey++;
        }

        if(indexOfKey!=-1&&indexOfKey>5&&indexOfKey<=13){
          var previousKey=data!.keys.toList()[indexOfKey-1];
          var nextKey=data!.keys.toList()[indexOfKey];
          int previousNumber=int.parse(RegExp(r'\d+').firstMatch(previousKey)![0]!);
          int nextNumber=int.parse(RegExp(r'\d+').firstMatch(nextKey)![0]!);
          var previouseValue=data[previousKey];
          var nextValue=data[nextKey];
          percent=((currentValue-previouseValue)*(nextNumber-previousNumber)/(nextValue-previouseValue)+previousNumber).toStringAsFixed(1);
        }
        else{
          percent=percent.replaceAll('P', '');
          if(currentValue>=data[data!.keys.toList()[12]]){
            percent=((97*currentValue)/data[data!.keys.toList()[12]]).toStringAsFixed(1);
          }
          else if(currentValue<data[data!.keys.toList()[5]]){
            percent=((3*currentValue)/data[data!.keys.toList()[5]]).toStringAsFixed(1);
          }
        }

        setState(() {
          item_table[3][2] = (100*widget.tall/meduim).toStringAsFixed(1);
          te_[2]=double.parse(item_table[3][2]);

          tall_age.text=(meduim).toStringAsFixed(1);
          // percent=int.parse(RegExp(r'\d+').firstMatch(percent)![0]!);

          item_table[3][1] = percent;
          te_[1]=double.parse(item_table[3][1]);

        });

        // Do something with the age variable
      });
      if(months>=36) {
        table = 'zstatage';
      }
      else {
        table = 'zlenageinf';
      }

      teTablez=table;
      teTablezLabel='Agemos';

      filter_value=((((widget.year*12+widget.month+widget.day*0.0247)*2).round())/2).toStringAsFixed(1);
      loadData(table,'Sex',sex,'Agemos', filter_value).then((result) {
        var data = result;
        var zscore;
        var delta = 1000.0;
        var currentValue;
        var milestoneValue;
        data?.forEach((key, value) {
          if (key != 'Sex' &&key != 'Agemos' && key != 'L' && key != 'M' && key != 'S' && key != 'StDev') {
            if (delta > (widget.tall - value).abs()) {
              delta = (widget.tall - value).abs();
              zscore = key;
              currentValue=widget.tall;
              milestoneValue=value;
            }
          }
        });

        // print(zscore);
        int indexOfKey=data!.keys.toList().indexOf(zscore);
        if(currentValue>milestoneValue){
          indexOfKey++;
        }

        if(indexOfKey!=-1&&indexOfKey>2&&indexOfKey<=10){
          var previousKey=data!.keys.toList()[indexOfKey-1];
          var nextKey=data!.keys.toList()[indexOfKey];
          double previousNumber=double.parse(previousKey);
          double nextNumber=double.parse(nextKey);
          var previouseValue=data[previousKey];
          var nextValue=data[nextKey];
          zscore=((currentValue-previouseValue)*(nextNumber-previousNumber)/(nextValue-previouseValue)+previousNumber).toStringAsFixed(1);
        }

        setState(() {
          item_table[3][0] = zscore;
          te_[0]=double.parse(item_table[3][0]);
          diagnose();
        });
      });
    }
    /////////////////////////////////////////////
    ////////////////////////////////
    /////////////////////////////////////////////
    ////////////////////////////////        *PC/E
    if(widget.headlength!=null  && months<=36) {

      table = 'hcageinf';
      print("here ");


      if(months<36) filter_value=filter_value=((months.round()).toInt()).toString()+'.5';
      else if(months==36) filter_value="35.5";
      print(filter_value);
      print(months);
      print(table);
      loadData(table, 'Sex',sex,'Agemos', filter_value).then((result) {
        var data = result;
        final meduim = data?['M'];
        print("mediom");
        print(meduim);
        var percent;
        var delta = 1000.0;
        var currentValue;
        var milestoneValue;
        data?.forEach((key, value) {
          if (key != 'Sex' &&key != 'Agemos' && key != 'L' && key != 'M' && key != 'S') {
            if (delta > (double.parse(widget.headlength) - value).abs()) {
              delta = (double.parse(widget.headlength) - value).abs();
              percent = key;
              currentValue=double.parse(widget.headlength);
              milestoneValue=value;
            }
          }
        });


        int indexOfKey=data!.keys.toList().indexOf(percent);
        if(currentValue>milestoneValue){
          indexOfKey++;
        }

        if(indexOfKey!=-1&&indexOfKey>5&&indexOfKey<=13){
          var previousKey=data!.keys.toList()[indexOfKey-1];
          var nextKey=data!.keys.toList()[indexOfKey];
          int previousNumber=int.parse(RegExp(r'\d+').firstMatch(previousKey)![0]!);
          int nextNumber=int.parse(RegExp(r'\d+').firstMatch(nextKey)![0]!);
          var previouseValue=data[previousKey];
          var nextValue=data[nextKey];
          percent=((currentValue-previouseValue)*(nextNumber-previousNumber)/(nextValue-previouseValue)+previousNumber).toStringAsFixed(1);
        }
        else{
          percent=percent.replaceAll('P', '');
          if(currentValue>=data[data!.keys.toList()[12]]){
            percent=((97*currentValue)/data[data!.keys.toList()[12]]).toStringAsFixed(1);
          }
          else if(currentValue<data[data!.keys.toList()[5]]){
            percent=((3*currentValue)/data[data!.keys.toList()[5]]).toStringAsFixed(1);
          }
        }

        setState(() {
          item_table[4][2] = (100*double.parse(widget.headlength)/meduim).toStringAsFixed(2);
          headlength_age.text=(meduim).toStringAsFixed(1);
          item_table[4][1] = percent;
        });

        // Do something with the age variable
      });
      table = 'zhcageinf';
      filter_value=((((widget.year*12+widget.month+widget.day*0.0247)*2).round())/2).toStringAsFixed(1);
      if((((widget.year*12+widget.month+widget.day*0.0247)*2).round())/2==36) filter_value="35.5";
      loadData(table, 'Sex',sex,'Agemos', filter_value).then((result) {
        var data = result;
        var zscore;
        var delta = 1000.0;
        var currentValue;
        var milestoneValue;
        data?.forEach((key, value) {
          if (key != 'Sex' &&key != 'Agemos' && key != 'L' && key != 'M' && key != 'S') {
            if (delta > (double.parse(widget.headlength) - value).abs()) {
              delta = (double.parse(widget.headlength) - value).abs();
              zscore = key;
              currentValue=double.parse(widget.headlength);
              milestoneValue=value;
            }
          }
        });


        int indexOfKey=data!.keys.toList().indexOf(zscore);
        if(currentValue>milestoneValue){
          indexOfKey++;
        }

        if(indexOfKey!=-1&&indexOfKey>2&&indexOfKey<=10){
          var previousKey=data!.keys.toList()[indexOfKey-1];
          var nextKey=data!.keys.toList()[indexOfKey];
          double previousNumber=double.parse(previousKey);
          double nextNumber=double.parse(nextKey);
          var previouseValue=data[previousKey];
          var nextValue=data[nextKey];
          zscore=((currentValue-previouseValue)*(nextNumber-previousNumber)/(nextValue-previouseValue)+previousNumber).toStringAsFixed(1);
        }

        setState(() {
          item_table[4][0] = zscore;

        });
      });
    }
    /////////////////////////////////////////////

  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = screenHeight * 0.09;
    bool _isCompositionButtonVisible = true;

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
                'Diagnóstico Antropométrico',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Container(
              //   width: 40,
              //   height: 40,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     image: DecorationImage(
              //       fit: BoxFit.fill,
              //       image: AssetImage('assets/1.jpg'),
              //     ),
              //     //Icon(Icons.accessibility_rounded)
              //   ),
              // ),
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
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child:
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.8,
              //   child: ElevatedButton(
              //     onPressed: () {
              //
              //     },
              //     child:
                  Text('CDC 2000',
                    style: TextStyle(
                        color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                //   style: ElevatedButton.styleFrom(
                //     primary: Colors.indigo,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8.0),
                //     ),
                //   ),
                // ),
              // ),
            ),
          ),
          Container (
            // height: MediaQuery.of(context).size.height * 0.18,
            child:Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.11,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              child:Row(
                children: [
                  Text(
                    'INDICADOR: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // SizedBox(width: MediaQuery.of(context).size.width * 0.16,),

                  Text(
                    'Valor esperado (p50)',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),
          ),
          Container(
            // height: MediaQuery.of(context).size.height * 0.18,
            child:Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.11,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              child:Row(
                children: [
                  Text(
                    '* Peso/Talla (P/T):',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // SizedBox(width: MediaQuery.of(context).size.width * 0.06,),
                  Expanded(
                    child: TextField(
                      controller: weight_tall,
                      keyboardType: TextInputType.number,
                      enabled: false,
                      decoration: InputDecoration(
                        // hintText: 'Input',
                        // labelText: 'Peso/Edad',
                        // border: OutlineInputBorder(),
                        filled: false,
                        fillColor: Colors.grey[200],
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black, // Set the text color for the disabled state
                      ),
                    ),
                  ),
                  Text(
                    'kg',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),
          ),
          Container(
            // height: MediaQuery.of(context).size.height * 0.18,
            child:Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.11,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              child:Row(
                children: [
                  Text(
                    '* IMC/Edad (IMC/E):',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // SizedBox(width: MediaQuery.of(context).size.width * 0.16,),
                  Expanded(
                    child: TextField(
                      controller: fat_age,
                      keyboardType: TextInputType.number,
                      enabled: false,
                      decoration: InputDecoration(
                        // hintText: 'Input',
                        // labelText: 'Peso/Edad',
                        // border: OutlineInputBorder(),
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black, // Set the text color for the disabled state
                      ),
                    ),

                  ),
                  Text(
                    'kg/m²',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),
          ),
          Container(
            // height: MediaQuery.of(context).size.height * 0.18,
            child:Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.11,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              child:Row(
                children: [
                  Text(
                    '* Peso/Edad (P/E):',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: weight_age,
                      keyboardType: TextInputType.number,
                      enabled: false,
                      decoration: InputDecoration(
                        // hintText: 'Input',
                        // labelText: 'Peso/Edad',
                        // border: OutlineInputBorder(),
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black, // Set the text color for the disabled state
                      ),
                    ),
                  ),
                  Text(
                    'kg',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),
          ),
          Container(
            // height: MediaQuery.of(context).size.height * 0.18,
            child:Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.11,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              child:Row(
                children: [
                  Text(
                    '* Talla/Edad (T/E):',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // SizedBox(width: MediaQuery.of(context).size.width * 0.16,),
                  Expanded(
                    child: TextField(
                      controller: tall_age,
                      keyboardType: TextInputType.number,
                      enabled: false,
                      decoration: InputDecoration(
                        // labelText: 'Talla/Edad',
                        // border: OutlineInputBorder(),
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black, // Set the text color for the disabled state
                      ),
                    ),
                  ),
                  Text(
                    'cm',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),
          ),
          if(widget.headlength.trim()!='')
          Container(
            // height: MediaQuery.of(context).size.height * 0.18,
            child:Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.11,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              child:Row(
                children: [
                  Text(
                    '* Perimetero \ncefálico/Edad(PC/E):',
                    style: TextStyle(
                      // fontSize: MediaQuery.of(context).size.width*0.045,
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // SizedBox(width: MediaQuery.of(context).size.width * 0.01,),
                  Expanded(
                    child: TextField(
                      controller: headlength_age,
                      keyboardType: TextInputType.number,
                      enabled: false,
                      decoration: InputDecoration(
                        // labelText: 'Años',
                        // border: OutlineInputBorder(),
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black, // Set the text color for the disabled state
                      ),
                    ),
                  ),

                  Text(
                    'cm',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.08,
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            child: Table(
              border: TableBorder.all(width: 1, color: Colors.grey),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  children: [
                    TableCell(
                      child: Center(
                        child: Text(
                          'Indicador',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),

                    TableCell(
                      child: Center(
                        child: Text(
                          'Z-Score',//Puntuación Z
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          'Percentil',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          '% Mediana',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Center(
                        child: Text(
                          'P/T',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          item_table[0][0],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          item_table[0][1],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          item_table[0][2],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Center(
                        child: Text(
                          'IMC/E',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          item_table[1][0],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          item_table[1][1],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          item_table[1][2],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Center(
                        child: Text(
                          'P/E',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          item_table[2][0],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          item_table[2][1],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          item_table[2][2],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Center(
                        child: Text(
                          'T/E',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          item_table[3][0],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          item_table[3][1],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          item_table[3][2],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                  ],
                ),
                if(widget.headlength.trim()!='')
                  TableRow(
                    children: [
                      TableCell(
                        child: Center(
                          child: Text(
                            'PC/E',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),
                      TableCell(
                        child: Center(
                          child: Text(
                            item_table[4][0],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),
                      TableCell(
                        child: Center(
                          child: Text(
                            item_table[4][1],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),
                      TableCell(
                        child: Center(
                          child: Text(
                            item_table[4][2],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.08,
              vertical: MediaQuery.of(context).size.height * 0.0,
            ),
            child:Align(
              alignment: Alignment.centerLeft,
              child:
              Text('INTERPRETACIÓN Y DIAGNÓSTICO'
                ,style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),

            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.08,
              vertical: MediaQuery.of(context).size.height * 0.0,
            ),
            child:Align(
              alignment: Alignment.centerLeft,
              child:
              Text('Selecciona el método de interpretación'
                ,style: TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),

            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: selectedItem,
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item,
                        style: TextStyle(fontSize: 20),
                    ),
                  );
                }).toList(),
                onChanged: (String? selectedValue) {
                  setState(() {
                    selectedItem = selectedValue!;
                  });
                  diagnose();
                },

                dropdownColor: Color.fromRGBO(232, 221, 250, 1.0),
                // isExpanded: true,
                style: TextStyle(color: Colors.black),
                // iconEnabledColor: Colors.black,
                underline: Container(
                  height: 0.5,
                  color: Colors.black,
                ),
              )

            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.purple,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child:  Text(
                  diagnoseResult,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => graph(
                        isMale: widget.isMale,
                        headlength: widget.headlength ,
                        day: widget.day,
                        imc: widget.imc,
                        weight: widget.weight,
                        month: widget.month,
                        tall:  widget.tall,
                        year:  widget.year,
                        ptTable: ptTable!,
                        imcTable: imcTable!,
                        teTable: teTable!,
                        ptTablez: ptTablez!,
                        imcTablez: imcTablez!,
                        teTablez: teTablez!,
                        ptTableLabel: ptTableLabel!,
                        imcTableLabel: imcTableLabel!,
                        teTableLabel: teTableLabel!,
                        ptTablezLabel: ptTablezLabel!,
                        imcTablezLabel: imcTablezLabel!,
                        teTablezLabel: teTablezLabel!,
                        OMS_CDC: false,
                        // currentPT: pt_,
                        // currentIMCE: imc_,
                        // currentTE: te_,
                          currentEStyleForIMCE:"Month",
                          currentEStyleForTE:"Month"
                      )),
                    );
                  },
                  child: Text('GRAFICAR',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        // fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    primary: Color.fromRGBO(84, 26, 138, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              )

            ],
          ),
          SizedBox(height: 20,)
          // Add more rows of components he
          // re
          // Positioned(
          //   bottom: 20,
          //   right: 20,
          //   child: Visibility(
          //     visible: _isCompositionButtonVisible,
          //     child: FloatingActionButton(
          //       onPressed: () {
          //         // Scroll up the page
          //         Scrollable.ensureVisible(
          //           context.findRenderObject(),
          //           duration: Duration(milliseconds: 500),
          //         );
          //       },
          //       child: Icon(Icons.arrow_upward),
          //     ),
          //   ),
          // ),
        ],
      ),
    );

  }

}
