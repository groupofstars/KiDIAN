import 'package:flutter/cupertino.dart';
import 'package:kidian/language/languages.dart';
import 'package:kidian/language/language_en.dart';
import 'package:kidian/language/language_es.dart';

class AppLocalizationDelegate extends LocalizationsDelegate<Languages>{
  const AppLocalizationDelegate();
  @override
  bool isSupported(Locale locale) => ['es','en','es_MX'].contains(locale.languageCode);
  @override
  Future<Languages> load(Locale locale)  => _load(locale);
  static Future<Languages> _load(Locale locale) async {
    switch(locale.languageCode){
      case 'en':
        return LanguageEn();
      case 'es':
        return LanguageEs();
      default:
        return LanguageEn();
    }
  }
  @override
  bool shouldReload(LocalizationsDelegate<Languages> old) => false;

}