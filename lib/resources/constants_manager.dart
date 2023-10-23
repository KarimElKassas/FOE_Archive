import 'package:flutter/material.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/data/models/user_model.dart';
import 'package:foe_archive/domain/entities/user.dart';
import 'package:hive/hive.dart';
import '../utils/constant.dart';
import '../utils/prefs_helper.dart';
import 'language_manager.dart';

class AppConstants {
  static const int toastTimeIOS = 3; //in seconds
  static const String prefsKeyLang = "PREFS_KEY_LANG";
  static const String prefsKeyTheme = "PREFS_KEY_THEME";
  static const String sharePath = "\\\\nas.foe\\إدارة الرقمنة\\Archive Letters";
  static ValueNotifier<bool> boxKeyNotifier = ValueNotifier(false);

  /// The default borderRadius
  static const double borderRadius = 8.0;

  /// The default unit of spacing
  static const double spaceUnit = 16;

  /// sm spacing value (8pt)
  static const double sm = 0.5 * spaceUnit;

  /// md spacing value (12pt)
  static const double md = 0.75 * spaceUnit;

  /// lg spacing value (16pt)
  static const double lg = spaceUnit;
  /// xlg spacing value (24pt)
  static const double xlg = 1.5 * spaceUnit;

  static void registerAdapters(){
    if(!Hive.isAdapterRegistered(1)){
      Hive.registerAdapter(UserModelAdapter());
    }
    if(!Hive.isAdapterRegistered(3)){
      Hive.registerAdapter(FilesListAdapter());
    }
    if(!Hive.isAdapterRegistered(4)){
      Hive.registerAdapter(DepartmentLettersAdapter());
    }
    if(!Hive.isAdapterRegistered(5)){
      Hive.registerAdapter(LetterTagsAdapter());
    }
    if(!Hive.isAdapterRegistered(6)){
      Hive.registerAdapter(LetterMentionsAdapter());
    }
    if(!Hive.isAdapterRegistered(2)){
      Hive.registerAdapter(LetterModelAdapter());
    }
  }
  static Future<void> initCaching()async {
    registerAdapters();
    await Hive.openBox<Map<String, dynamic>>('Users');
    await Hive.openBox<Map<String, dynamic>>('Settings');
    await Hive.openBox('IncomingInternalLetters');
    await Hive.openBox('IncomingExternalLetters');
    await Hive.openBox('OutgoingInternalLetters');
    await Hive.openBox('OutgoingExternalLetters');
    await Hive.openBox('ArchivedLetters');
    await Hive.openBox('ForMeLetters');
    //await Hive.box('Conversations').clear();
  }

  static void finish(BuildContext context, route) {
    Navigator.pushReplacementNamed(context, route);
  }

  static void finishWithArguments(
      BuildContext context, route, Object? arguments) {
    Navigator.pushReplacementNamed(context, route, arguments: arguments);
  }

  static void navigate(BuildContext context, route, Object? arguments) {
    Navigator.pushNamed(context, route, arguments: arguments);
  }


  static Future<String> getAppLanguage() async {
    var key = Preference.prefs.getString(prefsKeyLang);
    if(Preference.prefs.containsKey(prefsKeyLang)){
      if(key!.isNotEmpty){
        return key == "English" ? LanguageType.ENGLISH.getValue() : LanguageType.ARABIC.getValue();
      }else{
        return LanguageType.ARABIC.getValue();
      }
    }else{
      return LanguageType.ARABIC.getValue();
    }
  }
  static Future<String> getMyToken()async{
    if(Preference.prefs.containsKey('sessionToken')){
      var token = Preference.prefs.getString('sessionToken').toString();
      return token;
    }
    return "Empty";
  }

  static ThemeMode getAppTheme() {
    String? theme = "";
      theme = Preference.prefs.getString(prefsKeyTheme);
    if(Preference.prefs.containsKey(prefsKeyTheme)){
      if(theme!.isNotEmpty){
        return theme == "Dark" ? ThemeMode.dark : ThemeMode.light;
      }else{
        return ThemeMode.light;
      }
    }else{
      return ThemeMode.light;
    }
  }

  static Future<void> changeAppTheme() async {
    ThemeMode currentTheme = getAppTheme();

    if (currentTheme == ThemeMode.dark) {
      // set light
      Preference.prefs.setString(prefsKeyTheme, "Light");
    } else {
      // set dark
      Preference.prefs.setString(prefsKeyTheme, "Dark");
    }
  }

  static Future<void> changeAppLanguage() async {
    String currentLang = await getAppLanguage();

    if (currentLang == LanguageType.ARABIC.getValue()) {
      // set english
      Preference.prefs.setString(prefsKeyLang, "English");
      Constants.currentLocale = LanguageType.ENGLISH.getValue();
    } else {
      // set arabic
      Preference.prefs.setString(prefsKeyLang, "Arabic");
      Constants.currentLocale = LanguageType.ARABIC.getValue();
    }
  }

  static Future<Locale> getLocal() async {
    String currentLang = await getAppLanguage();

    if (currentLang == LanguageType.ARABIC.getValue()) {
      return ARABIC_LOCAL;
    } else {
      return ENGLISH_LOCAL;
    }
  }

  static bool isArabic() {
    return Constants.currentLocale == LanguageType.ARABIC.getValue();
    //return Preference.prefs.getString(AppConstants.prefsKeyLang) == "Arabic";
  }

  static bool isDark() {
      return Preference.prefs.getString(AppConstants.prefsKeyTheme) == "Dark";
  }
}