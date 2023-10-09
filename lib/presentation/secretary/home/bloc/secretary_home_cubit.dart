import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/domain/usecase/get_directions_use_case.dart';
import 'package:foe_archive/domain/usecase/get_letters_use_case.dart';
import 'package:foe_archive/presentation/secretary/home/bloc/secretary_home_states.dart';
import '../../../../data/models/direction_model.dart';
import '../../../../data/models/letter_model.dart';
import '../../../../resources/strings_manager.dart';
import '../../../../utils/prefs_helper.dart';
import '../../../home/bloc/home_states.dart';

class SecretaryHomeCubit extends Cubit<SecretaryHomeStates> {
  SecretaryHomeCubit(this.getLettersUseCase,this.getDirectionsUseCase) : super(SecretaryHomeInitialState());

  static SecretaryHomeCubit get(context) => BlocProvider.of(context);
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

  List<DirectionModel> directionsList = [];
  List<DirectionModel> selectedDirectionsList = [];

  //================== end filter method ==============//
  void addOrRemoveFilteredDirection(DirectionModel model){
    selectedDirectionsList.contains(model) ?
    selectedDirectionsList.remove(model) : selectedDirectionsList.add(model);
    emit(SecretaryHomeAddOrRemoveFilteredDirectionState());
  }
  void prepareListAfterFilter(){
    filteredLettersList = lettersList.where((letter) {
      return selectedDirectionsList.any((direction) => direction.directionId == letter.directionId);
    }).toList();
    emit(SecretaryHomePrepareFilteredList());

  }
  void resetFilteredList(){
    filteredLettersList = lettersList;
  }
  void changeDirectionFilter(bool newValue){
    isFilterByDirection = newValue;
    emit(SecretaryHomeChangeFilterDirection());
  }
  void changeTwoDatesFilter(bool newValue){
    isFilterByTwoDates = newValue;
    emit(SecretaryHomeChangeFilterTwoDates());
  }
  void changeYearFilter(bool newValue){
    isFilterByYear = newValue;
    emit(SecretaryHomeChangeFilterByYear());
  }
  void changeMonthFilter(bool newValue){
    isFilterByMonth = newValue;
    emit(SecretaryHomeChangeFilterByMonth());
  }
  void changeDayFilter(bool newValue){
    isFilterByDay = newValue;
    emit(SecretaryHomeChangeFilterByDay());
  }
  void changeTagFilter(bool newValue){
    isFilterByTag = newValue;
    emit(SecretaryHomeChangeFilterByTag());
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
      emit(SecretaryHomeChangeSortMethod());
    }
  }
  void searchLetters(String value){
    filteredLettersList = lettersList.where((element) => element.letterNumber.contains(value) || element.letterAbout.contains(value) || element.letterContent.contains(value)).toList();
    emit(SecretaryHomeSearchLetters());
  }
  String formatDate(DateTime date) {
    var format2 = DateFormat("EEE , d MMM , yyyy" ,"ar");
    var dateString = format2.format(date);
    return dateString;
  }

  void changeSelectedLetter(LetterModel? letterModel){
    selectedLetter = letterModel;
    emit(SecretaryHomeChangeSelectedLetter());
  }

  void changeSelectedBox(int boxNumber){
    if(selectedMenuBox != boxNumber){
      selectedMenuBox = boxNumber;
      elPageController.jumpToPage(boxNumber);
      emit(SecretaryHomeChangeSelectedBox());
    }
  }

  Future<void> getAllLetters() async {
    emit(SecretaryHomeLoadingLetters());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getLettersUseCase(GetLettersParameters(sessionToken));
    result.fold(
            (l) => emit(SecretaryHomeGetLettersError(l.errMessage)),
            (r) {
            lettersList = [];
            lettersList = r;
            filteredLettersList = lettersList;
            emit(SecretaryHomeGetLettersSuccess());
        });
  }
  Future<void> getAllDirections() async {
    emit(SecretaryHomeLoadingDirections());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getDirectionsUseCase(GetDirectionsParameters(sessionToken));
    result.fold(
            (l) => emit(SecretaryHomeGetDirectionsError(l.errMessage)),
            (r) {
          directionsList = [];
          directionsList = r;
          emit(SecretaryHomeGetDirectionsSuccess());
        });
  }


  void logOut() async {
    await Preference.prefs.remove('sessionToken');
    await Preference.prefs.remove('User');
    emit(SecretaryHomeLogOut());
  }
}
