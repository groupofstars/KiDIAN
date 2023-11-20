import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'oms.dart';
import 'cdc.dart';
import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {



  int _counter = 0;

  bool _isMale = true;
  // bool _isFemale = false;
  bool isSwitched=false;
  bool _isCalendarSelected = false;
  bool _isSelected_A=false;
  bool _isSelected_B=false;
  bool dialog_show=false;


  TextEditingController  year=TextEditingController();
  TextEditingController  month=TextEditingController();
  TextEditingController  day=TextEditingController();
  TextEditingController  weight=TextEditingController();
  TextEditingController  tall=TextEditingController();
  TextEditingController  imc=TextEditingController();
  TextEditingController  headlength=TextEditingController();

  DateTime _selectedDate = DateTime.now();


  String name = '';
  String gender = '';
  String birthday = '';
  double weight_ = 0.0;
  double tall_ = 0.0;
  // double headLength = 0.0;
  Color label_color= Color.fromRGBO(5, 5, 5, 1.0);
  Color segment_label_color= Color.fromRGBO(57, 148, 134, 1.0);

  double hombro=0;
  double rodilla=0;
  double tibia=0;
  double promedio=0;

  double hombro_tll=0;
  double rodilla_tll=0;
  double tibia_tll=0;
  double promedio_tll=0;

  bool sel_hombro=false;
  bool sel_rodilla=false;
  bool sel_tibia=false;
  bool sel_promedio=false;

  File? _image;

  // final picker = ImagePicker();

  // Future getImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.camera);

  //   setState(() {
  //     _image = File(pickedFile!.path);
  //   });
  // }

  late DateFormat _dateFormat = DateFormat('yyyy年MMMd日', 'ja_JP');
  // Future<void> _selectInform(BuildContext context) async{
  //   showDialog(context: context, builder: (BuildContext context) {
  //     return  InforDialog();
  //   });
  // }
  Future<void> _selectDate(BuildContext context) async {
    // final context = MySingletonClass.getInstance().context;
    // final Locale? locale = Localizations.localeOf(context);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      //  locale: const Locale('es','MX'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.red, // Customize the primary color if needed
            colorScheme :ColorScheme.light(primary: Colors.purple)
          ),
          child: child!,
        );
      },
    );
    _dateFormat.format(_selectedDate);
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        DateTime lastDayOfMonth=(DateTime(_selectedDate.year,_selectedDate.month+1,1)).subtract(Duration(days:1));

        if((DateTime.now().month-_selectedDate.month)>0) {
          year.text=(DateTime.now().year-_selectedDate.year).toString();
          if((DateTime.now().day-_selectedDate.day)>=0)
          {
              month.text=(DateTime.now().month-_selectedDate.month).toString();
              day.text=(DateTime.now().day-_selectedDate.day).toString();
          }
          else  {
            month.text=(DateTime.now().month-_selectedDate.month-1).toString();
            day.text=(DateTime.now().day+lastDayOfMonth.day-_selectedDate.day).toString();
          }
        }
        else if((DateTime.now().month-_selectedDate.month)<0) {
          year.text=(DateTime.now().year-_selectedDate.year-1).toString();
          month.text=(DateTime.now().month+12-_selectedDate.month).toString();
          if((DateTime.now().day-_selectedDate.day)>=0)
          {
              day.text=(DateTime.now().day-_selectedDate.day).toString();
          }
          else  {
            day.text=(DateTime.now().day+lastDayOfMonth.day-_selectedDate.day).toString();
          }
        }
        else{

          if((DateTime.now().day-_selectedDate.day)>=0)
          {
              year.text=(DateTime.now().year-_selectedDate.year).toString();
              day.text=(DateTime.now().day-_selectedDate.day).toString();
              month.text=(DateTime.now().month-_selectedDate.month).toString();
          }
          else  {
            year.text=(DateTime.now().year-_selectedDate.year-1).toString();
            day.text=(DateTime.now().day).toString();
            month.text=(DateTime.now().month+11-_selectedDate.month-1).toString();
          }
        }



      });
    }
  }
  void initState() {
    super.initState();


    //var tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();

    //dateFormat = DateFormat.yMMMMd('cs');
    initializeDateFormatting();

    _dateFormat = DateFormat('yyyy年MMMd日', 'ja_JP');

  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = screenHeight * 0.09;
    // bool _isCompositionButtonVisible = true;

    return CupertinoApp(

      //locale:const Locale('es','MX'),
      localizationsDelegates:[
        GlobalMaterialLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,

      ],
      supportedLocales:[
        const Locale('en'),
        //const Locale('es','MX'),
        const Locale('pl','PL'),
        // Locale('en'),
        // Locale('MX'),
      ],
      locale: const Locale('pl','PL'),
      debugShowCheckedModeBanner: false,
    home:
    Scaffold(
      backgroundColor:  Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 122, 54, 239).withOpacity(1),
          leading:IconButton(icon:Icon(Icons.arrow_back_ios),
            iconSize:20.0,
              onPressed:(){
                Navigator.pop(context);
              }),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Datos Antropométricos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
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
      body:
    // key: _formKey,
    // autovalidate: true, // Enable automatic validation


          ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.11,
                //vertical: MediaQuery.of(context).size.height * 0.01,
              ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      '\nPor favor introduce los datos de tu paciente:',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            // height: MediaQuery.of(context).size.height * 0.18,
            child:Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.11,
                //vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              child:Row(
                children: [
                  Text(
                    'Sexo:',
                    style: TextStyle(
                      fontSize: 16,
                      color: label_color,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.11,),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isMale = true;
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: _isMale ? Colors.blue : Colors.grey[300],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.male,
                              color: Colors.white,
                            ),
                            // SizedBox(width: 10),
                            // Text(
                            //   'Male',
                            //   style: TextStyle(
                            //     color: Colors.white,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isMale = false;
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: !_isMale ? Colors.pink : Colors.grey[300],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.female,
                              color: Colors.white,
                            ),
                            // SizedBox(width: 10),
                            // Text(
                            //   'Female',
                            //   style: TextStyle(
                            //     color: Colors.white,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(width: 20),
                  // Switch(
                  //   value: _isMale,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _isMale = value;
                  //     });
                  //   },
                  // ),
                  // SizedBox(width: MediaQuery.of(context).size.width * 0.15,),
                ],
              ),
            ),
          ),
          // ),
          SizedBox(height: 20),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            child:Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.11,
                // vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              child:Row(
                  children:[
              Expanded(
                child: Align(
                alignment: Alignment.topLeft,
                  child:Text("Edad:",
                      style: TextStyle(
                        fontSize: 16,
                        color: label_color,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                ),
              ),
                  ]
              ),
            ),
          ),
          

          Container(
            height: MediaQuery.of(context).size.height * 0.11,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.09,
                vertical: MediaQuery.of(context).size.height * 0.025,
              ),
              child: Row(
                children: [

                  Expanded(
                    child: Container(
                        width:300,
                        child:Text(
                        '   Fecha de \n         nacimiento',
                          style: TextStyle(
                            fontSize: 17,
                            color: label_color,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child:
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _dateFormat.format(_selectedDate);
                          _selectDate(context);
                        //   showDatePicker(
                        //     context: context,
                        //     initialDate: _selectedDate,
                        //
                        //     firstDate: DateTime(2000),
                        //     lastDate: DateTime(2199),
                        //     //locale: const Locale('es', 'MX'), // Set locale explicitly
                        //   );
                         });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.11,
                        // width: MediaQuery.of(context).size.width*0.0001,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color.fromRGBO(84, 26, 138, 1.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              DateFormat('yyyy-MM-dd').format(_selectedDate.toLocal()),
                              // _selectedDate.to,
                              style: TextStyle(
                                fontSize: 19,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.11,
            // width: MediaQuery.of(context).size.width * 0.61,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.18,
                vertical: MediaQuery.of(context).size.height * 0.02,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: year,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Años',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: TextField(
                      controller: month,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Meses',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: TextField(
                      controller: day,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Días',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  // SizedBox(width: 10,),
                  // Expanded(
                  //   child: GestureDetector(
                  //     onTap: () {
                  //         setState(() {
                  //                           _dateFormat.format(_selectedDate);
                  //                           _selectDate(context);
                  //
                  //         });
                  //       },
                  //     child: Container(
                  //       height: MediaQuery.of(context).size.height * 0.11,
                  //       width: MediaQuery.of(context).size.width*0.0001,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(8),
                  //         color: _isMale ? Colors.cyan : Colors.grey[300],
                  //       ),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           // Icon(
                  //           //   Icons.calendar_today_rounded,
                  //           //   color: Colors.white,
                  //           // ),
                  //           // SizedBox(width: 10),
                  //           Text(
                  //             'Birthday',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.11,
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Peso:',style: TextStyle(
                            fontSize: 16,
                            color: label_color,
                            // fontWeight: FontWeight.bold,
                          )),
                          SizedBox(width: 10),

                          Expanded(
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: weight,
                              // keyboardType: TextInputType.number,
                              keyboardType : TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                hintText: 'dato',
                              ),
                              onChanged: (text) {
                                imc.text=(double.parse(weight.text)/(double.parse(tall.text)*double.parse(tall.text)*0.0001)).toStringAsFixed(1);
                              },
                            ),
                          ),
                          Text('kg'),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Talla:',style: TextStyle(
                            fontSize: 16,
                            color: label_color,
                            // fontWeight: FontWeight.bold,
                          )),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: tall,
                              // keyboardType: TextInputType.number,
                              keyboardType : TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                hintText: 'dato',
                              ),
                              onChanged: (text) {
                                imc.text=(double.parse(weight.text)/(double.parse(tall.text)*double.parse(tall.text)*0.0001)).toStringAsFixed(1);
                              },
                            ),
                          ),
                          Text('cm'),
                        ],
                      ),
                      Row(
                        children: [
                          Text('IMC:',style: TextStyle(
                            fontSize: 16,
                            color: label_color,
                            // fontWeight: FontWeight.bold,
                          )),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: imc,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '',
                              ),
                            ),
                          ),
                          Text('kg/m²'),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      // Row(
                      //   children: [
                      //     Checkbox(value: _isSelected_A, onChanged: (bool? value) {
                      //
                      //
                      //
                      //       setState(() {
                      //         _isSelected_A=value!;
                      //       });
                      //     }),
                      //     // SizedBox(width: 5),
                      //     MediaQuery.of(context).size.width<600 ?
                      //     Text('Estimación de\npeso en\nsituación\nespecial'
                      //       ,style: TextStyle(
                      //         fontSize: 14,
                      //         color: Color.fromARGB(221, 10, 10, 10),
                      //         // fontWeight: FontWeight.bold,
                      //       )):
                      //       Text('Estimación de peso en situación especial'
                      //       ,style: TextStyle(
                      //         fontSize: 13,
                      //         color: Color.fromARGB(221, 5, 5, 5),
                      //         // fontWeight: FontWeight.bold,
                      //       )
                      //       ,
                      //     ),
                      //   ],
                      // ),
                      Row(
                        children: [
                          Checkbox(value: _isSelected_B, onChanged: (bool? value) {

                            // final result = Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => HSCDialog(isMale: _isMale)),
                            // );
                            // if (result != null) {
                            //   setState(() {
                            //
                            //   });
                            // }


                            setState(() {
                              _isSelected_B=value!;
                            });
                          }),
                          // SizedBox(width: 5),
                          MediaQuery.of(context).size.width<600 ?
                          Text('Estimación de\ntalla por\nsegmentos',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(221, 2, 2, 2),
                              // fontWeight: FontWeight.bold,
                            ),):
                            Text('Estimación de talla por segmentos',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(221, 3, 3, 3),
                              // fontWeight: FontWeight.bold,
                            ),),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if(_isSelected_B)

          Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.16,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              child:
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color.fromRGBO(84, 26, 138, 1.0),
                    width: 2,
                  ),
                ),
                child:
                Column(
                children: [
                  SizedBox(height:20),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,   vertical: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child:
                    Text('Introduce los datos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(0, 0, 0, 1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height:10),
                  Row(
                    children: [
                      SizedBox(width:20),
                      Expanded(
                        // child: Center(
                        child: Text(
                          'Hombro-codo:',
                          style: TextStyle(
                            fontSize: 16,
                            color: label_color,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        // ),
                      ),
                      Expanded(
                        child: Center(
                          child: TextFormField(
                            onChanged: (value){
                              setState(() {
                                hombro=double.tryParse(value)!;
                                hombro_tll=4.35*hombro+21.8;
                              });

                            },
                            textAlign: TextAlign.center,
                            // controller: headlength,
                            //keyboardType: TextInputType.number,
                            keyboardType : TextInputType.numberWithOptions(decimal: true),
                            // maxLength: 4,
                            decoration: InputDecoration(
                              // labelText: 'Anos',
                              // border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Text(
                        'cm',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(221, 72, 34, 34),
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width:20),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width:20),
                      Expanded(
                        // child: Center(
                        child: Text(
                          'Rodilla-talón:',
                          style: TextStyle(
                            fontSize: 16,
                            color: label_color,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        // ),
                      ),
                      Expanded(
                        child: Center(
                          child: TextFormField(
                            onChanged: (value){
                              setState(() {
                                rodilla=double.tryParse(value)!;
                                rodilla_tll=2.69*rodilla+24.3;
                              });


                            },
                            textAlign: TextAlign.center,
                            // controller: headlength,
                            //keyboardType: TextInputType.number,
                            keyboardType : TextInputType.numberWithOptions(decimal: true),
                            // maxLength: 4,
                            decoration: InputDecoration(
                              // labelText: 'Anos',
                              // border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Text(
                        'cm',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(221, 72, 34, 34),
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width:20),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width:20),
                      Expanded(
                        // child: Center(
                        child: Text(
                          'Tibia-maleólo:',
                          style: TextStyle(
                            fontSize: 16,
                            color: label_color,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        // ),
                      ),
                      Expanded(
                        child: Center(
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            // controller: headlength,
                            onChanged: (value){
                              setState(() {
                                tibia=double.tryParse(value)!;
                                tibia_tll=tibia*3.26+30.8;
                              });


                            },
                            //keyboardType: TextInputType.number,
                            keyboardType : TextInputType.numberWithOptions(decimal: true),
                            // maxLength: 4,
                            decoration: InputDecoration(
                              // labelText: 'Anos',
                              // border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Text(
                        'cm',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(221, 72, 34, 34),
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width:20),
                    ],
                  ),
                  SizedBox(height:20),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,   vertical: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child:
                    Text('Selecciona los segmentos a utilizar para estimar la talla',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(2, 2, 2, 1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height:10),
                  Row(
                    children: [
                      Checkbox(value: sel_hombro, onChanged: (bool? value) {

                        int count=0;
                        double sum=0;

                        setState(() {
                          sel_hombro=value!;
                          if(sel_hombro) {
                            count++;
                            sum+=hombro_tll;
                          }
                          if(sel_rodilla) {
                            count++;
                            sum+=rodilla_tll;
                          }
                          if(sel_tibia) {
                            count++;
                            sum+=tibia_tll;
                          }
                          promedio_tll=(hombro_tll+rodilla_tll+tibia_tll)/3;

                        });
                        if(!sel_promedio) tall.text=(sum/count).toStringAsFixed(1);
                        else tall.text=((hombro_tll+rodilla_tll+tibia_tll)/3).toStringAsFixed(1);

                      }
                      ),

                      Expanded(
                        // child: Center(
                        child: Text(
                          'hombro-codo:',
                          style: TextStyle(
                            fontSize: 16,
                            color: label_color,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        // ),
                      ),

                      Text(
                        hombro_tll.toStringAsFixed(1)+' cm',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(221, 72, 34, 34),
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width:20),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(value: sel_rodilla, onChanged: (bool? value) {
                        int count=0;
                        double sum=0;

                        setState(() {
                          sel_rodilla=value!;
                          if(sel_hombro) {
                            count++;
                            sum+=hombro_tll;
                          }
                          if(sel_rodilla) {
                            count++;
                            sum+=rodilla_tll;
                          }
                          if(sel_tibia) {
                            count++;
                            sum+=tibia_tll;
                          }
                          promedio_tll=(hombro_tll+rodilla_tll+tibia_tll)/3;

                        });
                        if(!sel_promedio) tall.text=(sum/count).toStringAsFixed(1);
                        else tall.text=((hombro_tll+rodilla_tll+tibia_tll)/3).toStringAsFixed(1);
                      }
                      ),
                      Expanded(
                        // child: Center(
                        child: Text(
                          'rodilla-talón:',
                          style: TextStyle(
                            fontSize: 16,
                            color: label_color,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        // ),
                      ),
                      Text(
                        rodilla_tll.toStringAsFixed(1)+' cm',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(221, 72, 34, 34),
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width:20),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(value: sel_tibia, onChanged: (bool? value) {
                        int count=0;
                        double sum=0;

                        setState(() {
                          sel_tibia=value!;
                          if(sel_hombro) {
                            count++;
                            sum+=hombro_tll;
                          }
                          if(sel_rodilla) {
                            count++;
                            sum+=rodilla_tll;
                          }
                          if(sel_tibia) {
                            count++;
                            sum+=tibia_tll;
                          }
                          promedio_tll=(hombro_tll+rodilla_tll+tibia_tll)/3;

                        });
                        if(!sel_promedio) tall.text=(sum/count).toStringAsFixed(1);
                        else tall.text=((hombro_tll+rodilla_tll+tibia_tll)/3).toStringAsFixed(1);
                      }
                      ),
                      Expanded(
                        // child: Center(
                        child: Text(
                          'tibia-maleólo: ',
                          style: TextStyle(
                            fontSize: 16,
                            color: label_color,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        // ),
                      ),

                      Text(
                        tibia_tll.toStringAsFixed(1) + ' cm',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(221, 72, 34, 34),
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width:20),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          activeColor: Colors.blue,
                          value: sel_promedio,
                          onChanged: (bool? value) {
                            int count=0;
                            double sum=0;

                            setState(() {
                              sel_promedio=value!;
                              if(sel_promedio) {
                                sel_hombro = true;
                                sel_rodilla = true;
                                sel_tibia = true;

                                tall.text=((hombro_tll+rodilla_tll+tibia_tll)/3).toStringAsFixed(1);
                              }
                              else{
                                if(sel_hombro) {
                                  count++;
                                  sum+=hombro_tll;
                                }
                                if(sel_rodilla) {
                                  count++;
                                  sum+=rodilla_tll;
                                }
                                if(sel_tibia) {
                                  count++;
                                  sum+=tibia_tll;
                                }
                                tall.text=(sum/count).toStringAsFixed(1);
                              }

                              promedio_tll=(hombro_tll+rodilla_tll+tibia_tll)/3;

                            });

                          }
                      ),
                      Expanded(
                        // child: Center(
                        child: Text(
                          'Promedio: ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // ),
                      ),

                      Text(
                        promedio_tll.toStringAsFixed(1)+' cm',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width:20),
                    ],
                  ),
                  Text(' Talla '+tall.text+' cm',
                    style: TextStyle(
                    fontSize: 24,
                    color: segment_label_color,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height:20),
                ],
              ),
          ),
            ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.11,
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            child: Row(
              children: [
                Expanded(
                  // child: Center(
                  child: Text(
                    'Perímetro cefálico:',
                    style: TextStyle(
                      fontSize: 16,
                      color: label_color,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  // ),
                ),
                Expanded(
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: headlength,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      // maxLength: 4,
                      decoration: InputDecoration(
                        hintText: 'dato',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Text(
                  'cm',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(221, 7, 7, 7),
                    // fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child:Align(
              alignment: Alignment.center,
              child:
                Text('CALCULAR'
                  ,style: TextStyle(
                      color: Color.fromARGB(221, 3, 3, 3),
                      fontSize: 29,
                      fontWeight: FontWeight.bold
                  ),
                ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.15,
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            child:Align(
              alignment: Alignment.center,
              child:Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text('OMS 2006,\n2007',
                        style: TextStyle(
                            color: Colors.white
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {

                        if (int.tryParse(day.text)==null||double.tryParse(imc.text)==null||int.tryParse(year.text)==null||double.tryParse(weight.text)==null||int.tryParse(month.text)==null||double.tryParse(tall.text)==null) {
                          // setState(() {
                          //   // _errorMessage = 'Please enter a value';
                          // });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Dato"),
                                content: Text("Por favor introduce los datos"),
                                actions: [
                                  ElevatedButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        else
                        {
                           
;                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OMS(
                              title: 'Kidian',
                              isMale: _isMale,
                              isSelected_A: _isSelected_A,
                              isSelected_B: _isSelected_B,
                              headlength: headlength.text ,
                              day: int.parse(day.text),
                              imc: double.parse(imc.text),
                              weight: double.parse(weight.text),
                              month: int.parse(month.text),
                              tall:  double.parse(tall.text),
                              year:  int.parse(year.text),
                            )),
                          );
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(84, 26, 138, 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1, // 50% of screen width
                    height: 50,
                    // child: Container(
                    //    color: Colors.green,
                    // ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      child: Text('CDC\n2000',
                        style: TextStyle(
                            color: Colors.white
                        ),textAlign: TextAlign.center,),
                      onPressed: () {
                        if (int.tryParse(day.text)==null||double.tryParse(imc.text)==null||int.tryParse(year.text)==null||double.tryParse(weight.text)==null||int.tryParse(month.text)==null||double.tryParse(tall.text)==null) {
                          // setState(() {
                          //   // _errorMessage = 'Please enter a value';
                          // });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Dato"),
                                content: Text("Por favor introduce los datos"),
                                actions: [
                                  ElevatedButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        else
                        {

                          ;                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CDC(
                              title: 'Kidian',
                              isMale: _isMale,
                              isSelected_A: _isSelected_A,
                              isSelected_B: _isSelected_B,
                              headlength: headlength.text ,
                              day: int.parse(day.text),
                              imc: double.parse(imc.text),
                              weight: double.parse(weight.text),
                              month: int.parse(month.text),
                              tall:  double.parse(tall.text),
                              year:  int.parse(year.text),
                            )),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(84, 26, 138, 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     SizedBox(
          //       width: MediaQuery.of(context).size.width * 0.4,
          //       child: ElevatedButton(
          //         onPressed: () {

          //         },
          //         child: Text('OTRAS',
          //           style: TextStyle(
          //               color: Colors.white
          //           ),
          //         ),
          //         style: ElevatedButton.styleFrom(
          //           primary: Color.fromRGBO(84, 26, 138, 1.0),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(8.0),
          //           ),
          //         ),
          //       ),
          //     )

          //   ],
          // ),

          // Padding(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: MediaQuery.of(context).size.width * 0.1,
          //     vertical: MediaQuery.of(context).size.height * 0.01,
          //   ),
          //   child:ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       primary: Color.fromRGBO(66, 212, 90, 1),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(8.0),
          //       ),
          //     ),
          //     child: Text('COMPOSICIÓN CORPORAL',
          //       style: TextStyle(
          //           color: Color.fromARGB(255, 225, 23, 178)
          //       ),
          //     ),
          //     onPressed: () {
          //
          //     },
          //
          //   ),
          //
          // ),
          SizedBox(height: 20,),
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
    ),
      );

  }

}
