import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:fl_nynberapp/src/app.dart';
import 'package:fl_nynberapp/src/blocs/auth_bloc.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/constant_parameter.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/language_app.dart';
import 'package:fl_nynberapp/src/resources/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

// void main() => runApp(MyApp(
//     new AuthBloc(),
//     new MaterialApp(
//       debugShowCheckedModeBanner: false,
//      // home: LoginPage(),
//     home: ScreenPage()
//    //home: GeoJsonPage(),
//     )));
// //void main() => runApp(MyHomePage());


void main() {
  print("Main Here");
  WidgetsFlutterBinding.ensureInitialized();
  String path = "assets/json/ipconfig.json";
  String pathLanguageConfig = "assets/excel/CVlang.xlsx";
  LanguageConfig languageConfig;
  parseExcelFromAssets(pathLanguageConfig).then((excel) {
    languageConfig = new LanguageConfig("VIE", excel);
    // checkExistSelectLanguage().then((value){
    //   languageConfig = new LanguageConfig("VIE", excel);
    //   // if(value == null || value == "ENG")  languageConfig = new LanguageConfig("ENG", excel);
    //   // else if(value == "VIE"){
    //   //    languageConfig = new LanguageConfig("VIE", excel);
    //   // }

    // });
  });

  parseJsonFromAssets(path).then((dmap) {
    ConstantParameter cstParameter;
    cstParameter = ConstantParameter.fromJson(dmap);
    runApp(MyApp(
        new AuthBloc(),
        new MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()
            // home: GeoJsonPage(),
            )));
  });
}

Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
  return rootBundle
      .loadString(assetsPath)
      .then((jsonStr) => jsonDecode(jsonStr));
}

Future<Excel> parseExcelFromAssets(String assetPath) async {
  ByteData data = await rootBundle.load(assetPath);
  var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  return Excel.decodeBytes(
    bytes,
    // update: true,
  );
}

Future<String> checkExistSelectLanguage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("selectLanguage");
}
