import 'package:flutter/material.dart';

abstract class Languages {
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }
  String get appName;

  String get welcomeText;

  String get appDescription;

  String get selectLanguage;
  String get home;
  String get plzEnterPatientInfo ;
  String get gender;
  String get age ;
  String get birthday;
  String get year ;
  String get month ;
  String get day ;
  String get weight ;
  String get tall => "Tall";
  String get bmi => "BMI";
  String get headLength => "Head circumference";
  String get data => "data";
  String get Data => "Data";
  String get sizeEstimationBySegmentos => "Size estimation by segments";
  String get calculate => "CALCULATE";
  String get who => "WHO";
  String get mainAppbarCaption => "Anthropometric data";
  String get enterData => "Enter the data";
  String get select_segments => "Selects the segments to be used for size estimation";
  String get shoulder_elbow => "Shoulder-elbow";
  String get knee_heel => "Knee-heel";
  String get tibia_malleolus => "Tibia-malleolus";
  String get average => "Average";
  String get inputWarning => "Please enter the following data";
  String get expectedValue => "Expected value";
  String get indicator => "Indicador";
  String get INDICATOR => "INDICADOR";
  String get percentile => "Percentile";
  String get z_score => "Z-score";
  String get median => "Median";
  String get intepretation_and_diagnosis => "INTERPRETATION AND DIAGNOSIS";
  String get select_intepretation_method => "Select the method of interpretation";
  String get ofMedian => "of the Median";
  String get graph => "GRAPH";
  String get anthroDiagnosis;
  String get select_method_plot => "Selecciona el método a graficar";
  String get select_indicator_plot => "Selecciona el indicador a graficar";
}