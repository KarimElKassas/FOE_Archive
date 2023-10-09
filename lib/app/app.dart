import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:multi_trigger_autocomplete/multi_trigger_autocomplete.dart';
import 'package:sizer/sizer.dart' as res;

import '../resources/constants_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/theme_manager.dart';

class MyApp extends StatefulWidget {

  const MyApp._internal(this.initialTheme);

  static const _instance = MyApp._internal(AdaptiveThemeMode.dark);

  final AdaptiveThemeMode? initialTheme;

  factory MyApp(AdaptiveThemeMode? initialTheme) => _instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void didChangeDependencies() {
    AppConstants.getLocal().then((local) => {context.setLocale(local)});
    super.didChangeDependencies();
  }

  GlobalKey key = GlobalKey();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return res.Sizer(
      builder: (context, orientation, deviceType){
        return AdaptiveTheme(
          light: ThemeManager().getLightTheme(),
          dark: ThemeManager().getDarkTheme(),
          initial: widget.initialTheme ?? ThemeManager().getDarkTheme(),
          builder: (theme, darkTheme) => Portal(
            child: MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              title: AppStrings.archiveApp.tr(),
              key: key,
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              onGenerateRoute: RouteGenerator.getRoute,
              initialRoute: RoutesManager.splashRoute, //Platform.isWindows ? RoutesManager.startRoute : RoutesManager.linkDeviceRoute,
              darkTheme: darkTheme,
              theme: theme,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

  }
}
