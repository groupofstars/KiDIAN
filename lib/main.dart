import 'package:flutter/material.dart';
import 'signing.dart';
import 'loading.dart';

import 'mainPage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: FutureBuilder<void>(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingingPage();
          } else {
            return LoadingPage();
          }
        },
      ),
    );
  }
}
