import 'dart:io';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/resources/constants_manager.dart';
import 'package:foe_archive/resources/language_manager.dart';
import 'package:foe_archive/utils/bloc_observer.dart';
import 'package:foe_archive/utils/constant.dart';
import 'package:foe_archive/utils/dio_helper.dart';
import 'package:foe_archive/utils/prefs_helper.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'app/app.dart';
import 'core/service/service_locator.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Preference.load();
  DioHelper.init();
  Bloc.observer = MyBlocObserver();
  ServiceLocator().setup();

  await Hive.initFlutter();
  await AppConstants.initCaching();

  Constants.currentLocale = await AppConstants.getAppLanguage();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  var currentVersion = "${packageInfo.version.replaceAll(".", "")}0";
  Constants.currentVersionNumber = int.parse(currentVersion);

  windowManager.setTitle("ارشيف مستقبل مصر");
  windowManager.maximize();
  windowManager.setResizable(false);

  bool needUpdate = await checkForUpdate();
  if(needUpdate){
    print("NEED UPDATE \n");
    var myPath = r"\\172.16.9.43\System\Archiving\versions";
    var myFile = "foe_archive_${Constants.latestVersion}.msix";
    ProcessResult result = await Process.run('cmd', ['/c', 'start', '', '$myPath/$myFile']);

    if (result.exitCode == 0) {
      await windowManager.destroy();
    }
    else {
      print("Bad ${result.stdout}\n");
      runApp(EasyLocalization(
          supportedLocales: const [ARABIC_LOCAL, ENGLISH_LOCAL],
          path: ASSET_PATH_LOCALISATIONS,
          child: MyApp(Constants.currentTheme)
      ));
    }
  }else{
    print("BIG ELSE\n");
    //initWindow();

    runApp(EasyLocalization(
        supportedLocales: const [ARABIC_LOCAL, ENGLISH_LOCAL],
        path: ASSET_PATH_LOCALISATIONS,
        child: MyApp(Constants.currentTheme)
    ));
  }
/*  runApp(EasyLocalization(
      supportedLocales: const [ARABIC_LOCAL, ENGLISH_LOCAL],
      path: ASSET_PATH_LOCALISATIONS,
      child: MyApp(Constants.currentTheme)
  ));*/
}

Future<bool> checkForUpdate()async{
  List<int> versions = [];
  Directory directory =  Directory(r"\\172.16.9.43\System\Archiving\versions");
  directory.listSync(recursive: false).forEach((element) {
    var fileName = element.path.replaceAll(r"\", "/").split("/").last.split("foe_archive_").last.split(".msix").first.replaceAll(".", "");
    versions.add(int.parse(fileName));
  });
  Constants.latestVersionNumber = versions.reduce(max);
  Constants.latestVersion = Constants.latestVersionNumber.toString().trim().replaceAllMapped(RegExp(r".{1}"), (match) => "${match.group(0)}.");
  Constants.latestVersion = Constants.latestVersion.substring(0, Constants.latestVersion.length - 1);
  print("LATEST : ${Constants.latestVersionNumber}\nLATEST : ${Constants.latestVersion}\n CURRENT : ${Constants.currentVersionNumber}\n");
  return Constants.currentVersionNumber < Constants.latestVersionNumber;
}