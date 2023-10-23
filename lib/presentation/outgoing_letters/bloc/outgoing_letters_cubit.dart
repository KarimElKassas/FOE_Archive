import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/data/models/user_model.dart';
import 'package:foe_archive/domain/usecase/get_outgoing_internal_letters_use_case.dart';
import 'package:foe_archive/presentation/outgoing_letters/bloc/outgoing_letters_state.dart';

import '../../../data/models/letter_model.dart';
import '../../../domain/usecase/get_outgoing_external_letters_use_case.dart';
import '../../../resources/strings_manager.dart';
import '../../../utils/prefs_helper.dart';

class OutgoingLettersCubit extends Cubit<OutgoingLettersStates>{
  OutgoingLettersCubit(this.getOutgoingInternalLettersUseCase,this.getOutgoingExternalLettersUseCase): super(OutgoingLettersInitial());
  
  static OutgoingLettersCubit get(context)=> BlocProvider.of(context);

  GetOutgoingInternalLettersUseCase getOutgoingInternalLettersUseCase;
  GetOutgoingExternalLettersUseCase getOutgoingExternalLettersUseCase;

  String? selectedSortMethod;
  List<String> sortMethods = [AppStrings.letterNumber.tr(),AppStrings.letterDirection.tr(),AppStrings.letterDate.tr()];
  ScrollController internalScrollController = ScrollController();
  ScrollController externalScrollController = ScrollController();

  List<LetterModel> internalLettersList = [];
  List<LetterModel> filteredInternalLettersList = [];
  List<LetterModel> externalLettersList = [];
  List<LetterModel> filteredExternalLettersList = [];

  LetterModel? selectedLetter;
  bool isInternalSelected = true;
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
      emit(OutgoingLettersChangeSortMethod());
    }
  }
  void searchLetters(String value){
    if(isInternalSelected){
      filteredInternalLettersList = internalLettersList.where((element) => element.letterNumber.contains(value) || element.letterAbout.contains(value) || element.letterContent.contains(value)).toList();
    }else{
      filteredExternalLettersList = externalLettersList.where((element) => element.letterNumber.contains(value) || element.letterAbout.contains(value) || element.letterContent.contains(value)).toList();
    }
    emit(OutgoingLettersSearchLetters());
  }
  String formatDate(String date) {
    var format2 = DateFormat("EEE , d MMM , yyyy" ,"ar");
    var dateString = format2.format(DateTime.parse(date));
    return dateString;
  }

  void changeSelectedLetter(LetterModel? letterModel){
    selectedLetter = letterModel;
    emit(OutgoingLettersChangeSelectedLetter());
  }
  void changeInternalOrExternal(int index){
    if(index == 0){
      isInternalSelected = true;
    }else{
      isInternalSelected = false;
    }
    emit(OutgoingLettersChangeInternal());
  }

  bool isSecretary(){
    var userMap = Preference.prefs.getString('User');
    UserModel userModel = UserModel.fromJson(jsonDecode(userMap!));
    return userModel.roleId == 3;
  }

  Future<void> getOutgoingInternalLetters() async {
    emit(OutgoingLettersLoadingLetters());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getOutgoingInternalLettersUseCase(GetOutgoingLettersParameters(sessionToken));
    result.fold(
            (l) => emit(OutgoingLettersErrorGetLetters(l.errMessage)),
            (r) {
          internalLettersList = [];
          internalLettersList = r;
          print("RESULT INTERNAL : $r");

          filteredInternalLettersList = internalLettersList;
          emit(OutgoingLettersSuccessfulGetLetters());
        });
  }
  Future<void> getOutgoingExternalLetters() async {
    emit(OutgoingLettersLoadingLetters());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getOutgoingExternalLettersUseCase(GetOutgoingLettersParameters(sessionToken));
    result.fold(
            (l) => emit(OutgoingLettersErrorGetLetters(l.errMessage)),
            (r) {
          externalLettersList = [];
          externalLettersList = r;
          print("RESULT EXTERNAL : $r");
          filteredExternalLettersList = externalLettersList;
          emit(OutgoingLettersSuccessfulGetLetters());
        });
  }
  Future<void> getData()async{
    await getOutgoingInternalLetters();
    if(isSecretary()){
      await getOutgoingExternalLetters();
    }
  }
}