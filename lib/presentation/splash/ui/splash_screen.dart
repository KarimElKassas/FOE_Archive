import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../resources/asset_manager.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/constants_manager.dart';
import '../../../resources/routes_manager.dart';
import '../../../resources/values_manager.dart';
import '../../../utils/components.dart';
import '../bloc/splash_cubit.dart';
import '../bloc/splash_states.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..navigate().then(
              (value) => AppConstants.finish(context, RoutesManager.loginRoute)),
      child: BlocConsumer<SplashCubit, SplashStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: ReusableComponents.appBar(
                statusBarColor: ColorManager.transparent,
                backgroundColor: ColorManager.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark),
            extendBodyBehindAppBar: true,
            backgroundColor: Theme.of(context).primaryColorLight,
            body: FadeIn(
              duration: const Duration(seconds: 2),
              child: Padding(
                padding: const EdgeInsets.all(AppSize.s36),
                child: Center(
                  child: SvgPicture.asset(
                    height: MediaQuery.sizeOf(context).height / 2,
                    width: MediaQuery.sizeOf(context).width / 2,
                    ImageAsset.registerLogo,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
