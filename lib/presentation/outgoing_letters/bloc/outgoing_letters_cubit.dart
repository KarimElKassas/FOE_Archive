import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/domain/usecase/get_outgoing_letters_use_case.dart';
import 'package:foe_archive/presentation/outgoing_letters/bloc/outgoing_letters_state.dart';

import '../../../data/models/letter_model.dart';
import '../../../resources/strings_manager.dart';
import '../../../utils/prefs_helper.dart';

class OutgoingLettersCubit extends Cubit<OutgoingLettersStates>{
  OutgoingLettersCubit(this.getOutgoingLettersUseCase): super(OutgoingLettersInitial());
  
  static OutgoingLettersCubit get(context)=> BlocProvider.of(context);

  GetOutgoingLettersUseCase getOutgoingLettersUseCase;

  String? selectedSortMethod;
  List<String> sortMethods = [AppStrings.letterNumber.tr(),AppStrings.letterDirection.tr(),AppStrings.letterDate.tr()];
  ScrollController scrollController = ScrollController();

  List<LetterModel> lettersList = [];
  List<LetterModel> filteredLettersList = [];
  LetterModel? selectedLetter;

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
      emit(OutgoingLettersChangeSortMethod());
    }
  }
  void searchLetters(String value){
    filteredLettersList = lettersList.where((element) => element.letterNumber.contains(value) || element.letterAbout.contains(value) || element.letterContent.contains(value)).toList();
    emit(OutgoingLettersSearchLetters());
  }
  String formatDate(DateTime date) {
    var format2 = DateFormat("EEE , d MMM , yyyy" ,"ar");
    var dateString = format2.format(date);
    return dateString;
  }

  void changeSelectedLetter(LetterModel? letterModel){
    selectedLetter = letterModel;
    emit(OutgoingLettersChangeSelectedLetter());
  }

  Future<void> getOutgoingLetters() async {
    emit(OutgoingLettersLoadingLetters());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getOutgoingLettersUseCase(GetOutgoingLettersParameters(sessionToken));
    result.fold(
            (l) => emit(OutgoingLettersErrorGetLetters(l.errMessage)),
            (r) {
          lettersList = [];
          lettersList = r;
          filteredLettersList = lettersList;
          emit(OutgoingLettersSuccessfulGetLetters());
        });
  }

}