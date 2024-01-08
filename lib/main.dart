import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:intl/date_symbol_data_local.dart';
import 'localization/delegation.dart';
import 'signing.dart';
import 'loading.dart';
// import 'mainPage.dart';
import 'localization/locale_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
void main() {
  // initializeDateFormatting('es_MX', null).then((_) {
    runApp(const ProviderScope(
      child: MyApp(),
    ),);
  // });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ref, _) {
          final locale = ref.watch(localeProvider).getProviderLocale();
          return FutureBuilder<Locale>(
              future: locale,
              builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return MaterialApp(
                      localizationsDelegates: [
                        AppLocalizationDelegate(),
                        GlobalMaterialLocalizations.delegate,
                        DefaultMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                        DefaultMaterialLocalizations.delegate,
                      ],
                      supportedLocales: [
                        const Locale('en'),
                        const Locale('es'),
                        const Locale('en', 'US'),
                        const Locale('es', 'MX'),
                      ],
                      locale: snapshot.data,
                      // localeResolutionCallback: (locale, supportedLocales) {
                      //   for (var supportedLocale in supportedLocales) {
                      //     if (supportedLocale.languageCode == locale?.languageCode &&
                      //         supportedLocale.countryCode == locale?.countryCode) {
                      //       return supportedLocale;
                      //     }
                      //   }
                      //   return supportedLocales.first;
                      // },
                      debugShowCheckedModeBanner: false,
                      title: 'KiDIAN',
                      theme: ThemeData(
                        colorScheme: ColorScheme.fromSeed(
                            seedColor: Colors.black),
                        useMaterial3: true,
                      ),
                      home: FutureBuilder<void>(
                        future: Future.delayed(Duration(seconds: 3)),
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return SingingPage();
                          } else {
                            return LoadingPage();
                          }
                        },
                      ),
                    );
                  }
                  else {
                    return CircularProgressIndicator();
                  }
              }
              );
        }
    );
  }
}
