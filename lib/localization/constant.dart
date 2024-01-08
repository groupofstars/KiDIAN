import "package:flutter/material.dart";
// import 'package:kidian/localization/locale_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


Locale _locale(String languageCode){
  return languageCode.isNotEmpty ? Locale(languageCode,'') : const Locale('es','MX');
}
Future<Locale> setLocale(String languageCode) async {
  SharedPreferences preferences= await SharedPreferences.getInstance();
  preferences.setString('language', languageCode);
  return _locale(languageCode);
}
Future<Locale> getLocale() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String languageCode = preferences.getString('language') ?? 'es';
  return _locale(languageCode);
}
