class LanguageModel {
  final String country;
  final String languageName;
  final String languageCode;

  LanguageModel(
      {required this.country,
        required this.languageName,
        required this.languageCode});

  static List<LanguageModel> languageList() {
    return <LanguageModel>[
      LanguageModel(
        country: "US",
        languageName: "En",
        languageCode: 'en',
      ),
      LanguageModel(
        country: "MX",
        languageName: "Es",
        languageCode: 'es',
      ),
    ];

  }
}