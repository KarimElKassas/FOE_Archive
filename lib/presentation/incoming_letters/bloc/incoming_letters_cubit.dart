import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/data/models/user_model.dart';
import 'package:foe_archive/domain/usecase/get_incoming_external_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_incoming_internal_letters_use_case.dart';
import 'package:foe_archive/presentation/incoming_letters/bloc/incoming_letters_state.dart';

import '../../../data/models/letter_model.dart';
import '../../../resources/strings_manager.dart';
import '../../../utils/prefs_helper.dart';

class IncomingLettersCubit extends Cubit<IncomingLettersStates>{
  IncomingLettersCubit(this.getIncomingInternalLettersUseCase,this.getIncomingExternalLettersUseCase): super(IncomingLettersInitial());
  
  static IncomingLettersCubit get(context)=> BlocProvider.of(context);

  GetIncomingInternalLettersUseCase getIncomingInternalLettersUseCase;
  GetIncomingExternalLettersUseCase getIncomingExternalLettersUseCase;

  String? selectedSortMethod;
  List<String> sortMethods = [AppStrings.letterNumber.tr(),AppStrings.letterDirection.tr(),AppStrings.letterDate.tr()];
  ScrollController internalScrollController = ScrollController();
  ScrollController externalScrollController = ScrollController();

  List<LetterModel> internalLettersList = [];
  List<LetterModel> filteredInternalLettersList = [];
  List<LetterModel> externalLettersList = [];
  List<LetterModel> filteredExternalLettersList = [];
  bool isInternalSelected = true;
  LetterModel? selectedLetter;

  void changeSortMethod(String newValue){
    if(selectedSortMethod != newValue){
      selectedSortMethod = newValue;
      if(isInternalSelected){
        if(selectedSortMethod == AppStrings.letterNumber.tr()){
          filteredInternalLettersList.sort((a,b) {return a.letterNumber.compareTo(b.letterNumber);});
        }else if(selectedSortMethod == AppStrings.letterDirection.tr()){
          filteredInternalLettersList.sort((a,b) {return a.directionId.compareTo(b.directionId);});
        }else if(selectedSortMethod == AppStrings.letterDate.tr()){
          filteredInternalLettersList.sort((a,b) {return a.letterDate!.compareTo(b.letterDate!);});
        }
      }else{
        if(selectedSortMethod == AppStrings.letterNumber.tr()){
          filteredExternalLettersList.sort((a,b) {return a.letterNumber.compareTo(b.letterNumber);});
        }else if(selectedSortMethod == AppStrings.letterDirection.tr()){
          filteredExternalLettersList.sort((a,b) {return a.directionId.compareTo(b.directionId);});
        }else if(selectedSortMethod == AppStrings.letterDate.tr()){
          filteredExternalLettersList.sort((a,b) {return a.letterDate!.compareTo(b.letterDate!);});
        }

      }
      emit(IncomingLettersChangeSortMethod());
    }
  }
  void searchLetters(String value){
    if(isInternalSelected){
      filteredInternalLettersList = internalLettersList.where((element) => element.letterNumber.contains(value) || element.letterAbout.contains(value) || element.letterContent.contains(value)).toList();
    }else{
      filteredExternalLettersList = externalLettersList.where((element) => element.letterNumber.contains(value) || element.letterAbout.contains(value) || element.letterContent.contains(value)).toList();
    }
    emit(IncomingLettersSearchLetters());
  }
  String formatDate(String date) {
    var format2 = DateFormat("EEE , d MMM , yyyy" ,"ar");
    var dateString = format2.format(DateTime.parse(date));
    return dateString;
  }

  void changeSelectedLetter(LetterModel? letterModel){
    selectedLetter = letterModel;
    emit(IncomingLettersChangeSelectedLetter());
  }
  void changeInternalOrExternal(int index){
    if(index == 0){
      isInternalSelected = true;
    }else{
      isInternalSelected = false;
    }
    emit(IncomingLettersChangeInternal());
  }
  bool isSecretary(){
    var userMap = Preference.prefs.getString('User');
    UserModel userModel = UserModel.fromJson(jsonDecode(userMap!));
    return userModel.roleId == 3;
  }

  Future<void> getIncomingInternalLetters() async {
    emit(IncomingLettersLoadingLetters());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getIncomingInternalLettersUseCase(GetIncomingLettersParameters(sessionToken));
    result.fold(
            (l) => emit(IncomingLettersErrorGetLetters(l.errMessage)),
            (r) {
          internalLettersList = [];
          internalLettersList = r;
          filteredInternalLettersList = internalLettersList;
          emit(IncomingLettersSuccessfulGetLetters());
        });
  }
  Future<void> getIncomingExternalLetters() async {
    emit(IncomingLettersLoadingLetters());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getIncomingExternalLettersUseCase(GetIncomingLettersParameters(sessionToken));
    result.fold(
            (l) => emit(IncomingLettersErrorGetLetters(l.errMessage)),
            (r) {
          externalLettersList = [];
          externalLettersList = r;
          filteredExternalLettersList = externalLettersList;
          emit(IncomingLettersSuccessfulGetLetters());
        });
  }
  Future<void> getData()async{
      await getIncomingInternalLetters();
      if(isSecretary()){
        await getIncomingExternalLetters();
      }
  }
}