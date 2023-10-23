import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../../../../resources/constants_manager.dart';
import '../../../../../resources/routes_manager.dart';
import '../../../domain/usecase/get_user_use_case.dart';
import '../../../domain/usecase/login_user_use_case.dart';
import '../../../utils/prefs_helper.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates>{
  LoginCubit(this.loginUserUseCase, this.getUserUseCase) : super(LoginInitState());

  static LoginCubit get(context)=> BlocProvider.of(context);
  LoginUserUseCase loginUserUseCase;
  GetUserUseCase getUserUseCase;

  bool isPassword = true;
  bool isSecretary = false;
  IconData suffix = Icons.visibility_rounded;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    emit(LoginLoadingState());

    Map<String, dynamic> dataMap = {
      'userHandle' : nameController.text.toString(),
      'password': passwordController.text.toString()
    };

    final result = await loginUserUseCase(LoginUserParameters(dataMap));
    result.fold(
            (l) {
              emit(LoginErrorState(l.errMessage));
            } ,
            (r)async {
              await getUserData(r);
            });
  }

  Future<void> getUserData(String sessionToken) async {
    emit(LoginLoadingState());
    final result = await getUserUseCase(GetUserParameters(sessionToken, passwordController.text.toString()));
    result.fold(
            (l) {
              emit(LoginErrorState(l.errMessage));
            },
            (r) {
              isSecretary = r.roleId == 3;
              var data = jsonEncode(r);
              Preference.prefs.setString("sessionToken", sessionToken);
              Preference.prefs.setString("User", data);
              emit(LoginSuccessState());
            });
  }

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded;

    emit(LoginChangePassVisibility());
  }
  Future<void> cacheUserData(Map<String, dynamic> userData) async {
    final userBox = Hive.box<Map<String, dynamic>>('Users');
    await userBox.put(userData['userId'], userData);
  }
  void navigate(BuildContext context){
    if(Platform.isWindows){
      AppConstants.finish(context, isSecretary ? RoutesManager.archiveHomeRoute : RoutesManager.archiveHomeRoute);
    }
  }
}