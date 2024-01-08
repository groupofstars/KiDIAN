import 'dart:io';

import 'package:flutter/services.dart';

import 'package:sqflite/sqflite.dart';

import 'package:flutter/material.dart';
// import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'graph.dart';
import 'package:kidian/language/languages.dart';

class OMS extends StatefulWidget {
  const OMS({
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
  State<OMS> createState() => _OMSState();
}

class _OMSState extends State<OMS> {

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

  String selectedItem = 'Puntuación Z';  //MÉTODO
  String diagnoseResult='No se puede diagnosticar.';
  String? currentEStyleForIMCE="";
  String? currentEStyleForTE="";
///////////////////////////////////////////////////////////////////////////////

  Future<Database> openDB() async {


    final dbPath = await getDatabasesPath();
    // final path = join(dbPath, '123.db');
    final path = dbPath + '/1122.db';
    if(!File(path).existsSync()){
      final dbData = await rootBundle.load('assets/123.db');
     
      await File(path).writeAsBytes(dbData.buffer.asUint8List());
    }
    
   
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      // Create the table if it doesn't exist
      await db.execute('CREATE TABLE IF NOT EXISTS my_table (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)');
    });
  }

  Future<Map<String, dynamic>?> loadData(String table,String where_name,String name) async {
    final db = await openDB();
    //final List<Map<String, dynamic>> data = await db.query(table, where: where_name + ' ='+name);
    final List<Map<String, dynamic>> data = await db.query(table, where: where_name + ' = ?',whereArgs : [name] );
    //final List<Map<String, dynamic>> data = await db.query(table, where: where_name + ' = ? AND ' + where_age + ' > ?', whereArgs: [name, age]);
    return data.isNotEmpty? data.first : null;
  }


////////////////////////////////////////////////////////////////////////////
void diagnose(){
  String tempResult='No se puede diagnosticar.';
  double? pt;
  double? imc;
  double? te;
  if(selectedItem=='Puntuación Z'){
    pt=pt_[0];
    imc=imc_[0];
    te=te_[0];
    if(te!=1000&&(imc!=1000||pt!=1000)) {
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
    pt=pt_[1];
    imc=imc_[1];
    te=te_[1];

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
    pt=pt_[2];
    imc=imc_[2];
    te=te_[2];
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }
  void initialize(){

    // weight_tall.text=(widget.weight/(widget.tall*0.01)).toStringAsFixed(2);
    // weight_age.text=(widget.weight).toStringAsFixed(2);
    // tall_age.text=(widget.tall).toStringAsFixed(2);
    // headlength_age.text=(widget.headlength).toStringAsFixed(2);
    // fat_age.text=(widget.imc).toStringAsFixed(2);

    



  ////////////////////////////////        *P/E
    String days='';
    int months=0;
    days=((widget.year*12*30.4375+widget.month*30.4375+widget.day).toInt()).toString();
    months=(widget.year*12+widget.month+widget.day*0.0247).toInt();

    String table = ' ';
    String filter_cond='';
    String filter_value='';
    if(months<=120) {

      if (widget.isMale) {
        if(months<61) {
          filter_cond='Age';
          filter_value=days;
          table = 'wfa_boys_percentiles';
        }
        else
        {
          filter_cond='Month';
          filter_value=months.toString();
          table = 'wfa_5_10_boys_perc';
        }
      }
      else {
        if(months<61) {
          filter_cond='Age';
          filter_value=days;
          table = 'wfa_girls_percentiles';
        }
        else {
          filter_cond='Month';
          filter_value=months.toString();
          table = 'wfa_5_10_girls_perc';
        }
      }

      loadData(table, filter_cond, filter_value).then((result) {
        var data = result;
        final meduim = data?['M'];
        var percent;
        var delta = 1000.0;
        var currentValue;
        var milestoneValue;
        
        data?.forEach((key, value) {
          if (key != filter_cond && key != 'L' && key != 'M' && key != 'S') {
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
        
        if(indexOfKey!=-1&&indexOfKey>4&&indexOfKey<=18){
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
          percent=percent.replaceAll('%', '');
          if(currentValue>=data[data!.keys.toList()[18]]){
            percent=((99.9*currentValue)/data[data!.keys.toList()[18]]).toStringAsFixed(1);
          }
          else if(currentValue<data[data!.keys.toList()[4]]){
            percent=((0.1*currentValue)/data[data!.keys.toList()[4]]).toStringAsFixed(1);
          }
        }

        setState(() {
          
          item_table[2][2] = (100*widget.weight/meduim).toStringAsFixed(2);
          weight_age.text=(meduim).toStringAsFixed(1);

          item_table[2][1] = percent;
        });

        // Do something with the age variable
      });
      if (widget.isMale) {
        if(months<61) {
          filter_cond='Day';
          filter_value=days;
          table = 'wfa_boys_zscore';
        }
        else {
          filter_cond='Month';
          filter_value=months.toString();
          table = 'wfa_5_10_boys_z';
        }
      }
      else {
        if(months<61) {
          filter_cond='Day';
          filter_value=days;
          table = 'wfa_girls_zscore';
        }
        else {
          filter_cond='Month';
          filter_value=months.toString();
          table = 'wfa_5_10_girls_z';
        }
      }
      loadData(table, filter_cond, filter_value).then((result) {
        var data = result;
        var zscore;
        var delta = 1000.0;
        var currentValue;
        var milestoneValue;
        data?.forEach((key, value) {
          if (key != filter_cond && key != 'L' && key != 'M' && key != 'S') {
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
        
        if(indexOfKey!=-1&&indexOfKey>4&&indexOfKey<=12){
          var previousKey=data!.keys.toList()[indexOfKey-1];
          var nextKey=data!.keys.toList()[indexOfKey];
          int previousNumber=int.parse(previousKey);
          int nextNumber=int.parse(nextKey);
          var previouseValue=data[previousKey];
          var nextValue=data[nextKey];
          zscore=((currentValue-previouseValue)*(nextNumber-previousNumber)/(nextValue-previouseValue)+previousNumber).toStringAsFixed(1);
        }

        setState(() {
          item_table[2][0] = zscore;
        });
      });
    }
  /////////////////////////////////////////////

    

    ////////////////////////////////        *IMC/E

    if(months<=228) {
      if (widget.isMale) {
        table = 'boys';
      }
      else {
        table = 'girls';
      }
      if(months<61) {
        filter_cond='Age';
        filter_value=days;
        table = 'bfa_'+table+'_percentiles';
        currentEStyleForIMCE="Day";
      }
      else {
        filter_cond='Month';
        filter_value=months.toString();
        table = 'bmi_'+table+'_perc';
        currentEStyleForIMCE="Month";

      }
      imcTable=table;
      imcTableLabel=filter_cond;

      loadData(table, filter_cond, filter_value).then((result) {
        var data = result;
        final meduim = data?['M'];
        setState(() {
          if(pt_formula){
            item_table[0][2] = (100*widget.weight/(meduim*widget.tall*widget.tall*0.0001)).toStringAsFixed(1);
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
          if (key != filter_cond && key != 'L' && key != 'M' && key != 'S') {
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
        
        double tmp_imc_percentage;

        if(indexOfKey!=-1&&indexOfKey>4&&indexOfKey<=15){
          var previousKey=data!.keys.toList()[indexOfKey-1];
          var nextKey=data!.keys.toList()[indexOfKey];
          int previousNumber=int.parse(RegExp(r'\d+').firstMatch(previousKey)![0]!);
          int nextNumber=int.parse(RegExp(r'\d+').firstMatch(nextKey)![0]!);
          var previouseValue=data[previousKey];
          var nextValue=data[nextKey];
          percent=(currentValue-previouseValue)*(nextNumber-previousNumber)/(nextValue-previouseValue)+previousNumber;
          tmp_imc_percentage=percent;
          percent=percent.toStringAsFixed(1);
          // if(percent<=5) percent="<= 5";
          // else if(percent<85) percent="5 a 84";
          // else if(percent<95) percent="85 a 94";


        }
        else if(indexOfKey>15){
          var previousKey=data!.keys.toList()[15];
          int previousNumber=int.parse(RegExp(r'\d+').firstMatch(previousKey)![0]!);
          var previouseValue=data[previousKey];
          
          percent=(100*currentValue)/previouseValue;
          tmp_imc_percentage=percent;
          if(percent<120) percent=percent.toStringAsFixed(1)+"% \n> P95";
          else if(percent<140) percent=percent.toStringAsFixed(1) +"% \n> P95";
          else percent=percent.toStringAsFixed(1) +"% \n> P95";
        }
        else{
          tmp_imc_percentage=0.1;
          percent="0.1";
          print(indexOfKey);
        }

        setState(() {
          
          //currentIMC=meduim;
          if (meduim != Null) {
            imc_[2]=100*widget.imc/meduim;
            item_table[1][2] = (imc_[2]).toStringAsFixed(2);

            fat_age.text=(meduim).toStringAsFixed(1);
          }
          imc_[1]=tmp_imc_percentage;
          item_table[1][1] = percent;
        });

        // Do something with the age variable
      });
      if (widget.isMale) {
        table = 'boys';
      }
      else {
        table = 'girls';
      }
      if(months<61) {
        filter_cond='Day';
        filter_value=days;
        table = 'bfa_'+table+'_zscore';

      }
      else {
        filter_cond='Month';
        filter_value=months.toString();
        table = 'bmi_'+table+'_z';

      }

      imcTablez=table;
      imcTablezLabel=filter_cond;

      loadData(table, filter_cond, filter_value).then((result) {
        var data = result;
        var zscore;
        var delta = 1000.0;
        var currentValue;
        var milestoneValue;
        data?.forEach((key, value) {
          if (key != filter_cond && key != 'L' && key != 'M' && key != 'S') {
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
        
        if(indexOfKey!=-1&&indexOfKey>4&&indexOfKey<=12){
          var previousKey=data!.keys.toList()[indexOfKey-1];
          var nextKey=data!.keys.toList()[indexOfKey];
          int previousNumber=int.parse(previousKey);
          int nextNumber=int.parse(nextKey);
          var previouseValue=data[previousKey];
          var nextValue=data[nextKey];

          zscore=((currentValue-previouseValue)*(nextNumber-previousNumber)/(nextValue-previouseValue)+previousNumber).toStringAsFixed(1);

        }

        setState(() {

          imc_[0]=double.parse(zscore);

          item_table[1][0] = zscore;
        });
      });
    }
    /////////////////////////////////////////////
    ////////////////////////////////        *P/T
    if(widget.tall>=45 && widget.tall<=120) {
      String length_or_height;
      if (widget.isMale) {
        if (int.parse(days) > 730) {
          table = 'wfh_boys_percentiles';

          length_or_height = 'Height';
        }
        else {
          table = 'wfl_boys_percentiles';
          length_or_height = 'Length';
        }
      }
      else {
        if (int.parse(days) > 730) {
          table = 'wfh_girls_percentiles';
          length_or_height = 'Height';
        }
        else {
          table = 'wfl_girls_percentiles';
          length_or_height = 'Length';
        }
      }
      var PT = widget.weight;

      ptTable=table;
      ptTableLabel=length_or_height;

      loadData(table, length_or_height, (widget.tall).toStringAsFixed(1)).then((
          result) {
        var data = result;
        final meduim = data?['M'];
        var percent;
        var delta = 1000.0;
        var currentValue;
        var milestoneValue;
        data?.forEach((key, value) {
          if (key != length_or_height && key != 'L' && key != 'M' &&
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
        
        if(indexOfKey!=-1&&indexOfKey>4&&indexOfKey<=18){
          var previousKey=data!.keys.toList()[indexOfKey-1];
          var nextKey=data!.keys.toList()[indexOfKey];
          int previousNumber=int.parse(RegExp(r'\d+').firstMatch(previousKey)![0]!);
          int nextNumber=int.parse(RegExp(r'\d+').firstMatch(nextKey)![0]!);
          var previouseValue=data[previousKey];
          var nextValue=data[nextKey];
          
          percent=((currentValue-previouseValue)*(nextNumber-previousNumber)/(nextValue-previouseValue)+previousNumber).toStringAsFixed(1);
          
        }
        else{
          percent=percent.replaceAll('%', '');
          if(currentValue>data[data!.keys.toList()[18]]){
            percent=((99.9*currentValue)/data[data!.keys.toList()[18]]).toStringAsFixed(1);
          }
          else{
            percent=((0.1*currentValue)/data[data!.keys.toList()[4]]).toStringAsFixed(1);
          }
        }
        pt_[1]=double.parse(percent);
        setState(() {
          if (meduim != Null) {
            item_table[0][2] = (100*widget.weight/meduim).toStringAsFixed(2);
            pt_[2]=double.parse(item_table[0][2]);
            weight_tall.text=(meduim).toStringAsFixed(1);
          
          }
          item_table[0][1] = percent;
        });

        // Do something with the age variable
      });

      if (widget.isMale) {
        if (int.parse(days) > 730) {
          table = 'wfh_boys_zscore';
          length_or_height = 'Height';
        }
        else {
          table = 'wfl_boys_zscore';
          length_or_height = 'Length';
        }
      }
      else {
        if (int.parse(days) > 730) {
          table = 'wfh_girls_zscore';
          length_or_height = 'Height';
        }
        else {
          table = 'wfl_girls_zscore';
          length_or_height = 'Length';
        }
      }
      ptTablez=table;
      ptTablezLabel=length_or_height;
      loadData(table, length_or_height, (widget.tall).toStringAsFixed(1)).then((
          result) {
        var data = result;
        var zscore;
        var delta = 1000.0;
        var currentValue;
        var milestoneValue;
        data?.forEach((key, value) {
          if (key != length_or_height && key != 'L' && key != 'M' &&
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
        
        if(indexOfKey!=-1&&indexOfKey>4&&indexOfKey<=12){
          var previousKey=data!.keys.toList()[indexOfKey-1];
          var nextKey=data!.keys.toList()[indexOfKey];
          int previousNumber=int.parse(previousKey);
          int nextNumber=int.parse(nextKey);
          var previouseValue=data[previousKey];
          var nextValue=data[nextKey];
          zscore=((currentValue-previouseValue)*(nextNumber-previousNumber)/(nextValue-previouseValue)+previousNumber).toStringAsFixed(1);
        }

        setState(() {
          item_table[0][0] = zscore;
          pt_[0]=double.parse(zscore);
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
    if(months<=228) {
      if (widget.isMale) {
        if(months<61) {
          filter_cond='Day';
          filter_value=days;
          table = 'lhfa_boys_percentiles';
          currentEStyleForTE="Day";
        }
        else {
          filter_cond='Month';
          filter_value=months.toString();
          table = 'hfa_boys_perc';
          currentEStyleForTE="Month";
        }
      }
      else {
        if(months<61) {
          filter_cond='Day';
          filter_value=days;
          table = 'lhfa_girls_percentiles';
          currentEStyleForTE="Day";
        }
        else {
          filter_cond='Month';
          filter_value=months.toString();
          table = 'hfa_girls_perc';
          currentEStyleForTE="Month";
        }
      }
      teTable=table;
      teTableLabel=filter_cond;
      loadData(table, filter_cond, filter_value).then((result) {
        var data = result;
        final meduim = data?['M'];
        var percent;
        var delta = 1000.0;
        var currentValue;
        var milestoneValue;
        data?.forEach((key, value) {
          if (key != filter_cond && key != 'L' && key != 'M' && key != 'S' && key != 'StDev') {
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
        
        if(indexOfKey!=-1&&indexOfKey>4&&indexOfKey<=18){
          var previousKey=data!.keys.toList()[indexOfKey-1];
          var nextKey=data!.keys.toList()[indexOfKey];
          int previousNumber=int.parse(RegExp(r'\d+').firstMatch(previousKey)![0]!);
          int nextNumber=int.parse(RegExp(r'\d+').firstMatch(nextKey)![0]!);
          var previouseValue=data[previousKey];
          var nextValue=data[nextKey];
          percent=((currentValue-previouseValue)*(nextNumber-previousNumber)/(nextValue-previouseValue)+previousNumber).toStringAsFixed(1);
        }
        else{
          // int temp=1;
          // if(months<61) {
          //   temp=0;
          // }
          // else temp=1;

          percent=percent.replaceAll('%', '');
          if(currentValue>data[data!.keys.toList()[18]]){
            percent=((99.9*currentValue)/data[data!.keys.toList()[18]]).toStringAsFixed(1);
          }
          else if(currentValue<data[data!.keys.toList()[4]]){
            percent=((0.1*currentValue)/data[data!.keys.toList()[4]]).toStringAsFixed(1);
          }
        }
        setState(() {
          item_table[3][2] = (100*widget.tall/meduim).toStringAsFixed(2);
          te_[2]=double.parse(item_table[3][2]);
          tall_age.text=(meduim).toStringAsFixed(1);

         // percent=int.parse(RegExp(r'\d+').firstMatch(percent)![0]!);
          item_table[3][1] = percent;
          te_[1]=double.parse(item_table[3][1]);
        });

        // Do something with the age variable
      });
      if (widget.isMale) {
        if(months<61) {
          filter_cond='Day';
          filter_value=days;
          table = 'lhfa_boys_zscore';
        }
        else {
          filter_cond='Month';
          filter_value=months.toString();
          table = 'hfa_boys_z';
        }
      }
      else {
        if(months<61) {
          filter_cond='Day';
          filter_value=days;
          table = 'lhfa_girls_zscore';
        }
        else {
          filter_cond='Month';
          filter_value=months.toString();
          table = 'hfa_girls_z';
        }
      }
      teTablez=table;
      teTablezLabel=filter_cond;
      loadData(table, filter_cond, filter_value).then((result) {
        var data = result;
        var zscore;
        var delta = 1000.0;
        var currentValue;
        var milestoneValue;
        data?.forEach((key, value) {
          if (key != filter_cond && key != 'L' && key != 'M' && key != 'S' && key != 'StDev') {
            if (delta > (widget.tall - value).abs()) {
              delta = (widget.tall - value).abs();
              zscore = key;
              currentValue=widget.tall;
              milestoneValue=value;
            }
          }
        });

        
        int indexOfKey=data!.keys.toList().indexOf(zscore);
        if(currentValue>milestoneValue){
            indexOfKey++;
        }
        
        if(indexOfKey!=-1&&indexOfKey>4&&indexOfKey<=12){
          var previousKey=data!.keys.toList()[indexOfKey-1];
          var nextKey=data!.keys.toList()[indexOfKey];
          int previousNumber=int.parse(previousKey);
          int nextNumber=int.parse(nextKey);
          var previouseValue=data[previousKey];
          var nextValue=data[nextKey];
          zscore=((currentValue-previouseValue)*(nextNumber-previousNumber)/(nextValue-previouseValue)+previousNumber).toStringAsFixed(1);
        }

        setState(() {
          item_table[3][0] = zscore;
          te_[0]=double.parse(zscore);
          diagnose();
        });
      });
    }
    /////////////////////////////////////////////
    ////////////////////////////////
    /////////////////////////////////////////////
    ////////////////////////////////        *PC/E
    if(widget.headlength.trim()!=''  && months<61) {
      if (widget.isMale) {
        table = 'hcfa_boys_percentiles';
      }
      else {
        table = 'hcfa_girls_percentiles';
      }

      loadData(table, 'Age', days).then((result) {
        var data = result;
        final meduim = data?['M'];
        var percent;
        var delta = 1000.0;
        var currentValue;
        var milestoneValue;
        data?.forEach((key, value) {
          if (key != 'Age' && key != 'L' && key != 'M' && key != 'S') {
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
        
        if(indexOfKey!=-1&&indexOfKey>4&&indexOfKey<=18){
          var previousKey=data!.keys.toList()[indexOfKey-1];
          var nextKey=data!.keys.toList()[indexOfKey];
          int previousNumber=int.parse(RegExp(r'\d+').firstMatch(previousKey)![0]!);
          int nextNumber=int.parse(RegExp(r'\d+').firstMatch(nextKey)![0]!);
          var previouseValue=data[previousKey];
          var nextValue=data[nextKey];
          percent=((currentValue-previouseValue)*(nextNumber-previousNumber)/(nextValue-previouseValue)+previousNumber).toStringAsFixed(1);
        }
        else{
          percent=percent.replaceAll('%', '');
          if(currentValue>=data[data!.keys.toList()[18]]){
            percent=((99.9*currentValue)/data[data!.keys.toList()[18]]).toStringAsFixed(1);
          }
          else if(currentValue<data[data!.keys.toList()[4]]){
            percent=((0.1*currentValue)/data[data!.keys.toList()[4]]).toStringAsFixed(1);
          }
        }

        setState(() {
          item_table[4][2] = (100*double.parse(widget.headlength)/meduim).toStringAsFixed(2);
          headlength_age.text=(meduim).toStringAsFixed(1);
          item_table[4][1] = percent;
        });

        // Do something with the age variable
      });
      if (widget.isMale) {
        table = 'hcfa_boys_zscore';
      }
      else {
        table = 'hcfa_girls_zscore';
      }
      loadData(table, 'Day', days).then((result) {
        var data = result;
        var zscore;
        var delta = 1000.0;
        var currentValue;
        var milestoneValue;
        data?.forEach((key, value) {
          if (key != 'Day' && key != 'L' && key != 'M' && key != 'S') {
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
        
        if(indexOfKey!=-1&&indexOfKey>4&&indexOfKey<=12){
          var previousKey=data!.keys.toList()[indexOfKey-1];
          var nextKey=data!.keys.toList()[indexOfKey];
          int previousNumber=int.parse(previousKey);
          int nextNumber=int.parse(nextKey);
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
                Languages.of(context)!.anthroDiagnosis,
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
                //
                    Text(Languages.of(context)!.who +' 2006,2007',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // style: ElevatedButton.styleFrom(
                    //   primary: Colors.indigo,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(8.0),
                    //   ),
                    // ),
                  ),
                // ),
            // ),
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
                    Languages.of(context)!.INDICATOR+': ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // SizedBox(width: MediaQuery.of(context).size.width * 0.16,),

                  Text(
                    Languages.of(context)!.expectedValue+' (p50)',
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
                    '* '+Languages.of(context)!.weight+'/'+Languages.of(context)!.tall+' ('+Languages.of(context)!.weight.characters.first+'/T):',
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
                    '* '+Languages.of(context)!.bmi+'/'+Languages.of(context)!.age+' ('+Languages.of(context)!.bmi+'/'+Languages.of(context)!.age.characters.first+'):',
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
                    '* '+Languages.of(context)!.weight+'/'+Languages.of(context)!.age+' ('+Languages.of(context)!.weight.characters.first+'/'+Languages.of(context)!.age.characters.first+'):',
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
                    '* '+Languages.of(context)!.tall+'/'+Languages.of(context)!.age+' ('+Languages.of(context)!.tall.characters.first+'/'+Languages.of(context)!.age.characters.first+'):',
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
                  Expanded(
                  child:
                  Text(
                    '* '+Languages.of(context)!.headLength+'/'+Languages.of(context)!.age+' ('+Languages.of(context)!.headLength.characters.first+'C/'+Languages.of(context)!.age.characters.first+'):',
                    style: TextStyle(
                      // fontSize: MediaQuery.of(context).size.width*0.045,
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01,),
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
              horizontal: MediaQuery.sizeOf(context).width * 0.08,
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
                        textAlign: TextAlign.center,
                        Languages.of(context)!.indicator,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.033,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    verticalAlignment: TableCellVerticalAlignment.middle,
                  ),

                  TableCell(
                   child: Center(
                    child:Expanded( child: Text(
                      Languages.of(context)!.z_score,//Puntuación Z
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.033,
                          color: Colors.black,
                       ),
                      ),
                    ),
                   ),
                    verticalAlignment: TableCellVerticalAlignment.middle,
                  ),
                  TableCell(
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                       Languages.of(context)!.percentile,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.033,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    verticalAlignment: TableCellVerticalAlignment.middle,
                  ),
                  TableCell(
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        '% '+Languages.of(context)!.median,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.033,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Center(
                      child: Text(
                        Languages.of(context)!.weight.characters.first+'/'+Languages.of(context)!.tall.characters.first,
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
                        Languages.of(context)!.bmi+'/'+Languages.of(context)!.age.characters.first,
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
                    Languages.of(context)!.weight.characters.first+'/'+Languages.of(context)!.age.characters.first,
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
                    Languages.of(context)!.tall.characters.first+'/'+Languages.of(context)!.age.characters.first,
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
                          Languages.of(context)!.weight.characters.first+'C/'+Languages.of(context)!.age.characters.first,
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
                Text(Languages.of(context)!.intepretation_and_diagnosis
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
               // Text('Seleccionar método de interpretación'
               Text(Languages.of(context)!.select_intepretation_method
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

                dropdownColor: Color.fromRGBO(228, 215, 248, 1.0),
                // isExpanded: true,
                style: TextStyle(color: Colors.black),
                // iconEnabledColor: Colors.white,
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
                        OMS_CDC: true,
                        // currentPT: pt_,
                        // currentIMCE: imc_,
                        // currentTE: te_,
                        currentEStyleForIMCE:currentEStyleForIMCE!,
                        currentEStyleForTE:currentEStyleForTE!
                      )),
                    );
                  },
                  child: Text(Languages.of(context)!.graph,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22
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
