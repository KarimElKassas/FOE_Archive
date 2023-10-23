import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/presentation/home/ui/home_screen.dart';
import 'package:foe_archive/presentation/letter_details/helper/letter_details_args.dart';
import 'package:foe_archive/presentation/letter_details/ui/letter_details_screen.dart';
import 'package:foe_archive/presentation/letter_reply/ui/letter_reply_screen.dart';
import 'package:foe_archive/presentation/login/ui/login_screen.dart';
import 'package:foe_archive/presentation/update_letter/ui/update_letter_screen.dart';
import '../presentation/secretary/home/ui/secretary_home_screen.dart';
import '../presentation/splash/ui/splash_screen.dart';
import 'strings_manager.dart';

class RoutesManager{
  static const String splashRoute = "/";
  static const String loginRoute = "/login";
  static const String archiveHomeRoute = "/archiveHome";
  static const String archiveSecretaryHomeRoute = "/archiveSecretaryHome";
  static const String letterDetailsRoute = "/letterDetails";
  static const String letterReplyRoute = "/letterReply";
  static const String updateLetterRoute = "/updateLetter";

}
class RouteGenerator{
  static Route<dynamic> getRoute(RouteSettings settings){
    final args = settings.arguments;
    switch (settings.name){
      case RoutesManager.splashRoute :
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RoutesManager.loginRoute :
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RoutesManager.archiveHomeRoute :
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RoutesManager.archiveSecretaryHomeRoute :
        return MaterialPageRoute(builder: (_) => const SecretaryHomeScreen());
      case RoutesManager.letterDetailsRoute :
        LetterDetailsArgs arguments = args! as LetterDetailsArgs;
        return MaterialPageRoute(builder: (_) => LetterDetailsScreen(letterModel: arguments.letterModel, letterType: arguments.letterType, fromReplyScreen: arguments.openedFromReply,));
      case RoutesManager.letterReplyRoute :
        return MaterialPageRoute(builder: (_) => LetterReplyScreen(letterModel: args as LetterModel,));
      case RoutesManager.updateLetterRoute :
        UpdateLetterArgs arguments = args! as UpdateLetterArgs;
        return MaterialPageRoute(builder: (_) => UpdateLetterScreen(letterModel: arguments.letterModel, letterFiles: arguments.letterFiles,selectedActionList: arguments.selectedActionList,selectedKnowList: arguments.selectedKnowList,));
      default:
        return unDefinedRoute();
    }
  }
  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text(AppStrings.noRouteFound.tr()),),
        body: Center(child: Text(AppStrings.noRouteFound.tr()),),
      );
    });
  }
}