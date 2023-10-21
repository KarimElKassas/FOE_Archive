import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/domain/usecase/get_directions_use_case.dart';
import 'package:foe_archive/domain/usecase/get_letters_use_case.dart';
import 'package:foe_archive/presentation/home/bloc/home_states.dart';

import '../../../data/models/direction_model.dart';
import '../../../data/models/letter_model.dart';
import '../../../data/models/user_model.dart';
import '../../../resources/strings_manager.dart';
import '../../../utils/prefs_helper.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit(this.getLettersUseCase,this.getDirectionsUseCase) : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);
  GetLettersUseCase getLettersUseCase;
  GetDirectionsUseCase getDirectionsUseCase;

  int selectedMenuBox = 0;
  String? selectedSortMethod;
  List<String> sortMethods = [AppStrings.letterNumber.tr(),AppStrings.letterDirection.tr(),AppStrings.letterDate.tr()];
  ScrollController scrollController = ScrollController();
  PageController elPageController = PageController();

  List<LetterModel> lettersList = [];
  List<LetterModel> filteredLettersList = [];
  LetterModel? selectedLetter;
  //================== filter method ==============//
  bool isFilterByDirection = false;
  bool isFilterByTwoDates = false;
  bool isFilterByYear = false;
  bool isFilterByMonth = false;
  bool isFilterByDay = false;
  bool isFilterByTag = false;
  bool isRefresh = false;
  List<DirectionModel> directionsList = [];
  List<DirectionModel> selectedDirectionsList = [];

  //================== end filter method ==============//
  void addOrRemoveFilteredDirection(DirectionModel model){
    selectedDirectionsList.contains(model) ?
    selectedDirectionsList.remove(model) : selectedDirectionsList.add(model);
    emit(HomeAddOrRemoveFilteredDirectionState());
  }
  void prepareListAfterFilter(){
    filteredLettersList = lettersList.where((letter) {
      return selectedDirectionsList.any((direction) => direction.directionId == letter.directionId);
    }).toList();
    emit(HomePrepareFilteredList());

  }
  void resetFilteredList(){
    filteredLettersList = lettersList;
  }
  void changeDirectionFilter(bool newValue){
    isFilterByDirection = newValue;
    emit(HomeChangeFilterDirection());
  }
  void changeTwoDatesFilter(bool newValue){
    isFilterByTwoDates = newValue;
    emit(HomeChangeFilterTwoDates());
  }
  void changeYearFilter(bool newValue){
    isFilterByYear = newValue;
    emit(HomeChangeFilterByYear());
  }
  void changeMonthFilter(bool newValue){
    isFilterByMonth = newValue;
    emit(HomeChangeFilterByMonth());
  }
  void changeDayFilter(bool newValue){
    isFilterByDay = newValue;
    emit(HomeChangeFilterByDay());
  }
  void changeTagFilter(bool newValue){
    isFilterByTag = newValue;
    emit(HomeChangeFilterByTag());
  }

  void initSortMethod(){
    selectedSortMethod = sortMethods[0];
  }

  void changeSortMethod(String newValue){
    if(selectedSortMethod != newValue){
      selectedSortMethod = newValue;
      if(selectedSortMethod == AppStrings.letterNumber.tr()){
        filteredLettersList.sort((a,b) {return a.letterNumber.compareTo(b.letterNumber);});
      }else if(selectedSortMethod == AppStrings.letterDirection.tr()){
        filteredLettersList.sort((a,b) {return a.directionId.compareTo(b.directionId);});
      }else if(selectedSortMethod == AppStrings.letterDate.tr()){
        filteredLettersList.sort((a,b) {return a.letterDate!.compareTo(b.letterDate!);});
      }
      emit(HomeChangeSortMethod());
    }
  }
  void searchLetters(String value){
    filteredLettersList = lettersList.where((element) => element.letterNumber.contains(value) || element.letterAbout.contains(value) || element.letterContent.contains(value)).toList();
    emit(HomeSearchLetters());
  }
  String formatDate(DateTime date) {
    var format2 = DateFormat("EEE , d MMM , yyyy" ,"ar");
    var dateString = format2.format(date);
    return dateString;
  }

  void changeSelectedLetter(LetterModel? letterModel){
    selectedLetter = letterModel;
    emit(HomeChangeSelectedLetter());
  }

  void changeSelectedBox(int boxNumber){
      selectedMenuBox = boxNumber;
      elPageController.jumpToPage(boxNumber);
      emit(HomeChangeSelectedBox());
  }
  Future<void> getAllLetters() async {
    emit(HomeLoadingLetters());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getLettersUseCase(GetLettersParameters(sessionToken));
    result.fold(
            (l) => emit(HomeGetLettersError(l.errMessage)),
            (r) {
            lettersList = [];
            lettersList = r;
            filteredLettersList = lettersList;
            emit(HomeGetLettersSuccess());
        });
  }
  Future<void> getAllDirections() async {
    emit(HomeLoadingDirections());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getDirectionsUseCase(GetDirectionsParameters(sessionToken));
    result.fold(
            (l) => emit(HomeGetDirectionsError(l.errMessage)),
            (r) {
          directionsList = [];
          directionsList = r;
          emit(HomeGetDirectionsSuccess());
        });
  }


  void logOut() async {
    await Preference.prefs.remove('sessionToken');
    await Preference.prefs.remove('User');
    emit(HomeLogOut());
  }
}
