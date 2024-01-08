import 'package:flutter/cupertino.dart';
import 'package:kidian/localization/constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final localeProvider = ChangeNotifierProvider((ref) =>LocaleProvider());
class LocaleProvider extends ChangeNotifier {

  Locale? _locale = Locale('es');
  Locale? get locale => _locale;
  Locale? getProviderLocale() {
    getLocale().then((value) => {
      _locale=value
    });
    return _locale;
  }
  void setProviderLocale(Locale newLocale) {
    _locale = newLocale;
    setLocale(_locale!.languageCode).then((value) => { _locale = value } );
    notifyListeners();
  }

  void changeLanguage(String selectedLanguageCode) async {
    setProviderLocale(selectedLanguageCode.isNotEmpty ? Locale(selectedLanguageCode,'') : const Locale('es','MX'));
    // setProviderLocale(locale);
  }
}