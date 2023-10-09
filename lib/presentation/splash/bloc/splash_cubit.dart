import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/presentation/splash/bloc/splash_states.dart';

class SplashCubit extends Cubit<SplashStates> {
  SplashCubit() : super(SplashInitialState());

  static SplashCubit get(context) => BlocProvider.of(context);

  Future<void> navigate() async => await Future.delayed(const Duration(milliseconds: 2000), () {});
}
