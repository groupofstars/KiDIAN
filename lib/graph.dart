import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'LineChart.dart';
import 'package:kidian/language/languages.dart';
class graph extends StatefulWidget {
  const graph({
    super.key,
    required this.isMale,
    required this.year,
    required this.month,
    required this.day,
    required this.weight,
    required this.tall,
    required this.imc,
    required this.headlength,
    required this.ptTable,
    required this.imcTable,
    required this.teTable,
    required this.ptTablez,
    required this.imcTablez,
    required this.teTablez,
    required this.ptTableLabel,
    required this.imcTableLabel,
    required this.teTableLabel,
    required this.ptTablezLabel,
    required this.imcTablezLabel,
    required this.teTablezLabel,
    required this.OMS_CDC,
    // required this.currentPT,
    // required this.currentIMCE,
    // required this.currentTE,
    required this.currentEStyleForIMCE,
    required this.currentEStyleForTE
  });

  final bool isMale;
  final int  year ;
  final int  month ;
  final int  day ;
  final double  weight ;
  final double  tall ;
  final double  imc ;
  final String  headlength ;
  final String  ptTable;
  final String imcTable;
  final String teTable;
  final String  ptTablez;
  final String imcTablez;
  final String teTablez;
  final String  ptTableLabel;
  final String imcTableLabel;
  final String teTableLabel;
  final String  ptTablezLabel;
  final String imcTablezLabel;
  final String teTablezLabel;
  final bool OMS_CDC;
  // final List<double> currentPT;
  // final List<double> currentIMCE;
  // final List<double> currentTE;
  final String currentEStyleForIMCE;
  final String currentEStyleForTE;
  @override
  State<graph> createState() => _graphOMSState();
}

class _graphOMSState extends State<graph> {

  // bool _isFemale = false;
  bool isSwitched=false;

  TextEditingController  weight_tall=TextEditingController();
  TextEditingController  weight_age=TextEditingController();
  TextEditingController  tall_age=TextEditingController();
  TextEditingController  headlength_age=TextEditingController();
  TextEditingController  fat_age=TextEditingController();

  List<String> items = [
    'Puntuación Z',
    'Percentiles',
  ];

  String selectedItem = 'Puntuación Z';  //MÉTODO
///////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////
  late double days;
  late double months;

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    days=(widget.year*12*30.4375+widget.month*30.4375+widget.day).toInt().toDouble();
    months=(widget.year*12+widget.month+widget.day*0.0247).toDouble();
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
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
                    Text(Languages.of(context)!.graph,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 27,
                          fontWeight: FontWeight.bold
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
              ),

              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.08),
                    child: Text(
                      Languages.of(context)!.select_method_plot+':',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      value: selectedItem,
                      items: items.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item,
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? selectedValue) {
                        setState(() {
                          selectedItem = selectedValue!;
                        });
                      },
                      dropdownColor: Color.fromRGBO(244, 230, 248, 1.0),
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.08),
                    child: Text(
                      Languages.of(context)!.select_indicator_plot+':',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

              if(selectedItem=='Puntuación Z'&&widget.ptTablez!="NA"||selectedItem=='Percentiles'&&widget.ptTable!="NA")
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ElevatedButton(
                        onPressed: () {
                          String tempTableName;
                          String tempLabelColumn;
                          if(selectedItem=='Puntuación Z'){
                            tempTableName=widget.ptTablez;
                            tempLabelColumn=widget.ptTablezLabel;
                          }
                          else {
                            tempTableName=widget.ptTable;
                            tempLabelColumn=widget.ptTableLabel;
                          }
                          if(tempTableName!='NA') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  LineChartCustomized(
                                      isMale: widget.isMale, table: tempTableName,labelColumn: tempLabelColumn,OMS_CDC: widget.OMS_CDC,currentX: widget.tall,currentY: widget.weight,yLabel: "Peso (Kg)",title:selectedItem=='Puntuación Z' ? 'Peso/Talla (P/T) Puntuación Z':'Peso/Talla (P/T) Percentiles',
                                  )),
                            );
                          }
                          else {
                            showDialog(
                              context: context,
                              builder: (BuildContext contxt) {
                                return AlertDialog(
                                  title: Text("Warning"),
                                  content: Text("There is not content for this"),
                                );
                              },
                            );
                          }
                        },
                        child: Text(
                          Languages.of(context)!.weight+'/'+Languages.of(context)!.tall+' ('+Languages.of(context)!.weight.characters.first+'/'+Languages.of(context)!.tall.characters.first+')',
                          style: TextStyle(
                            color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width * 0.043// Adjust the font size as needed
                          ),
                          textAlign: TextAlign.center,
                        ),
                        style: ElevatedButton.styleFrom(

                          primary: Color.fromRGBO(124, 51, 220, 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          minimumSize: Size(double.infinity, 60), // Adjust the height as needed
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if(selectedItem=='Puntuación Z'&&widget.imcTablez!="NA"||selectedItem=='Percentiles'&&widget.imcTable!="NA")
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ElevatedButton(
                        onPressed: () {
                          String tempTableName;
                          String tempLabelColumn;
                          if(selectedItem=='Puntuación Z'){
                            tempTableName=widget.imcTablez;
                            tempLabelColumn=widget.imcTablezLabel;
                          }
                          else {
                            tempTableName = widget.imcTable;
                            tempLabelColumn=widget.imcTableLabel;
                          }
                          if(tempTableName!='NA') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  LineChartCustomized(
                                    isMale: widget.isMale, table: tempTableName,labelColumn: tempLabelColumn,OMS_CDC: widget.OMS_CDC,currentX: widget.currentEStyleForIMCE =="Day" ? days : months ,currentY: widget.imc,yLabel: 'IMC (Kg/m²)',title:  selectedItem=='Puntuación Z' ? 'IMC/Edad (IMC/E) Puntuación Z':'IMC/Edad (IMC/E) Percentiles',
                                  )),
                            );
                          }
                          else {
                            showDialog(
                              context: context,
                              builder: (BuildContext contxt) {
                                return AlertDialog(
                                  title: Text("Warning"),
                                  content: Text("There is not content for this"),
                                );
                              },
                            );
                          }
                        },
                        child: Text(
                          Languages.of(context)!.bmi+'/'+Languages.of(context)!.age+' ('+Languages.of(context)!.bmi+'/'+Languages.of(context)!.age.characters.first+')',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.043, // Adjust the font size as needed
                          ),
                          textAlign: TextAlign.center,
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(88, 22, 141, 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          minimumSize: Size(double.infinity,MediaQuery.of(context).size.width * 0.12), // Adjust the height as needed
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if(selectedItem=='Puntuación Z'&&widget.teTablez!="NA"||selectedItem=='Percentiles'&&widget.teTable!="NA")
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ElevatedButton(
                        onPressed: () {
                          String tempTableName;
                          String tempLabelColumn;
                          if(selectedItem=='Puntuación Z'){
                            tempTableName=widget.teTablez;
                            tempLabelColumn=widget.teTablezLabel;
                          }
                          else {
                            tempTableName = widget.teTable;
                            tempLabelColumn=widget.teTableLabel;
                          }
                          if(tempTableName!='NA') {
                            // print(tempTableName);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  LineChartCustomized(
                                    isMale: widget.isMale, table: tempTableName,labelColumn: tempLabelColumn,OMS_CDC: widget.OMS_CDC,currentX: widget.currentEStyleForTE =="Day" ? days : months,currentY: widget.tall,yLabel: 'Talla (cm)',title:selectedItem=='Puntuación Z' ? 'Talla/Edad (T/E) Puntuación Z':'Talla/Edad (T/E) Percentiles'
                                  )),
                            );
                          }
                          else {
                            showDialog(
                              context: context,
                              builder: (BuildContext contxt) {
                                return AlertDialog(
                                  title: Text("Warning"),
                                  content: Text("There is not content for this"),
                                );
                              },
                            );
                          }
                        },
                        child: Text(

                          Languages.of(context)!.tall+'/'+Languages.of(context)!.age+' ('+Languages.of(context)!.tall.characters.first+'/'+Languages.of(context)!.age.characters.first+')',
                          style: TextStyle(
                            color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width * 0.043, // Adjust the font size as needed
                          ),
                          textAlign: TextAlign.center,
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(
                              171, 19, 161, 0.8941176470588236),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          minimumSize: Size(double.infinity, MediaQuery.of(context).size.width * 0.12), // Adjust the height as needed
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 5,)
            ],
          ),
        ),
      ),
    );

  }

}
