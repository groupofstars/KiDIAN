import 'package:flutter/material.dart';

import 'mainPage.dart';
class ItemsCounting extends StatelessWidget {
  const ItemsCounting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.11,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.051,
                  // vertical: MediaQuery.of(context).size.height * 0.01,
                ),
                child: Image.asset(
                  'assets/Alefinal-completo.png',

                ),
              ),
              SizedBox(height: 16),
              Text(
                'KiDIAN',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal
                ),
              ),
              SizedBox(height: 26),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width*0.7, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                    backgroundColor: Colors.indigo
                ),
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage( title: 'Kidian',)),
                  );

                },
                child: Text('Evaluación\nAntropométrica',
                          textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),

              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width*0.7, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                    backgroundColor: Colors.deepPurple
                ),
                onPressed: () {
                  // Do something when the "Visita rápida" button is pressed
                },
                child: Text('Evaluación\nGlobal Subjetiva',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),

              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width*0.7, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                    backgroundColor: Colors.green
                ),
                onPressed: () {
                  // Do something when the "Visita rápida" button is pressed
                },
                child: Text('Cálculo de fórmulas\ninfantiles',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),

              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width*0.7, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Colors.brown
                ),
                onPressed: () {
                  // Do something when the "Visita rápida" button is pressed
                },
                child: Text('Requerimientos\nnutricionales',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}