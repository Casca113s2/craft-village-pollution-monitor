class LanguageApp {
  String languageName;
  int languageID;
  LanguageApp({this.languageID, this.languageName});
  static List<LanguageApp> getListLanguage() {
    List<LanguageApp> list = [];
    list.add(new LanguageApp(languageID: 1, languageName: "VIE"));
    list.add(new LanguageApp(languageID: 2, languageName: "ENG"));
    return list;
  }
}
