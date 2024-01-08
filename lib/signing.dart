import 'package:flutter/material.dart';
import 'items.dart';
import 'language/languages.dart';
import 'mainPage.dart';
import 'language/language_model.dart';
import 'package:kidian/localization/locale_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidian/language/languages.dart';
class SingingPage extends StatelessWidget {
  const SingingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Singing Page'),
      // ),
        body: Consumer(
            builder: (context, ref, _) {
              return Stack(
                children:[
                  Positioned(
                    right: MediaQuery.of(context).size.width*0.1,
                    top: MediaQuery.of(context).size.height*0.05,
                    child: DropdownButton<LanguageModel>(
                      iconSize: 20,
                      hint: Text(Languages.of(context)!.selectLanguage),
                      onChanged: (LanguageModel? language) {
                        var mm = ref.read(localeProvider);
                        ref.watch(localeProvider.notifier).changeLanguage(language!.languageCode);
                      },
                      items: LanguageModel.languageList()
                          .map<DropdownMenuItem<LanguageModel>>(
                            (e) =>
                            DropdownMenuItem<LanguageModel>(
                              value: e,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    e.languageName,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                      )
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery
                          .of(context)
                          .size
                          .width * 0.11,
                      vertical: MediaQuery
                          .of(context)
                          .size
                          .height * 0.01,
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
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(84, 26, 138, 1.0),),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                // MaterialPageRoute(builder: (context) => ItemsCounting()),
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyHomePage(title: 'Kidian',))
                            );
                          },
                          child: Text(Languages.of(context)!.home,
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
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
                    )
                  )
                ]
              );
            }
            )
    );
  }
}
