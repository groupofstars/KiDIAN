import 'package:flutter/material.dart';
class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.10,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('./assets/Alefinal-completo.png'),
            SizedBox(height: 16),
            Text(
              'KiDIAN',
              style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color:Color.fromRGBO(3, 114, 75, 1)
              ),
            ),
          ],
        ),
      ),
    );
  }
}