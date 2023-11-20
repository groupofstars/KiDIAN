import 'package:flutter/material.dart';
import 'items.dart';
import 'mainPage.dart';
class SingingPage extends StatelessWidget {
  const SingingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Singing Page'),
      // ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.11,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Alefinal-completo.png'),
            SizedBox(height: 16),
            Text(
              'KiDIAN',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(3, 114, 75, 1),
              ),
            ),
            SizedBox(height: 26),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(84, 26, 138, 1.0),),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  // MaterialPageRoute(builder: (context) => ItemsCounting()),
                MaterialPageRoute(builder: (context) => MyHomePage( title: 'Kidian',))
                );
              },
              child: Text('Inicio',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {
            //     // Do something when the "Iniciar sesión" button is pressed
            //   },
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.lightBlue,
            //   ),
            //   child: Text('Iniciar sesión'),
            // ),
            // SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {
            //     // Do something when the "Registro" button is pressed
            //   },
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.green,
            //   ),
            //   child: Text('Registro'),
            // ),
          ],
        ),
      ),
    );
  }
}