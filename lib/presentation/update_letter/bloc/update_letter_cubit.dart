import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/data/models/tag_model.dart';
import 'package:foe_archive/domain/usecase/get_directions_use_case.dart';
import 'package:foe_archive/domain/usecase/get_sectors_use_case.dart';
import 'package:foe_archive/domain/usecase/update_letter_use_case.dart';
import 'package:foe_archive/presentation/update_letter/bloc/update_letter_states.dart';
import 'package:foe_archive/resources/strings_manager.dart';

import '../../../data/models/department_model.dart';
import '../../../data/models/direction_model.dart';
import '../../../data/models/letter_model.dart';
import '../../../data/models/sector_model.dart';
import '../../../data/models/selected_department_model.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/usecase/get_departments_use_case.dart';
import '../../../domain/usecase/get_tags_use_case.dart';
import '../../../utils/prefs_helper.dart';

class UpdateLetterCubit extends Cubit<UpdateLetterStates>{
  UpdateLetterCubit(this.updateLetterUseCase,this.getSectorsUseCase,this.getDepartmentsUseCase,this.getDirectionsUseCase,this.getTagsUseCase):super(UpdateLetterInitState());

  static UpdateLetterCubit get(context)=> BlocProvider.of(context);

  UpdateLetterUseCase updateLetterUseCase;
  GetSectorsUseCase getSectorsUseCase;
  GetDepartmentsUseCase getDepartmentsUseCase;
  GetDirectionsUseCase getDirectionsUseCase;
  GetTagsUseCase getTagsUseCase;

  TextEditingController letterAboutController = TextEditingController();
  TextEditingController letterNumberController = TextEditingController();
  TextEditingController letterContentController = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<PlatformFile> pickedFiles = [];
  List<MultipartFile> multipartFiles = [];
  List<String>? filesSize;
  List<String>? filesName;

  List<TagModel> tagsList = [];
  List<TagModel> selectedTagsList = [];
  DirectionModel? selectedDirection;
  List<DirectionModel> directionsList = [];

  List<SectorModel> sectorsList = [];
  SectorModel? selectedSectorModel;

  List<DepartmentModel> departmentsList = [];
  List<SelectedDepartmentModel?> selectedActionDepartmentsList = [];
  List<SelectedDepartmentModel?> selectedKnowDepartmentsList = [];
  List<Map<String,dynamic>> uploadDepartmentsList = [];
  List<int> uploadTagsList = [];
  List<Map<String,dynamic>> uploadMentionsList = [];
  List<SelectedDepartmentModel> removedDepartments = [];
  List<SelectedDepartmentModel> newDepartments = [];

  int securityLevel = 1;
  int necessaryLevel = 1;

  void initData(LetterModel letterModel, List<PlatformFile> letterFiles, List<SelectedDepartmentModel?> selectedActionList,List<SelectedDepartmentModel?> selectedKnowList){
    letterAboutController.text = letterModel.letterAbout;
    letterContentController.text = letterModel.letterContent;
    letterNumberController.text = letterModel.letterNumber;
    pickedFiles = letterFiles;
    selectedActionDepartmentsList = selectedActionList;
    selectedKnowDepartmentsList = selectedKnowList;
    necessaryLevel = letterModel.necessaryId;
    securityLevel = letterModel.confidentialityId;
  }

  void removeFromAction(SelectedDepartmentModel model){
    selectedActionDepartmentsList.remove(model);
    removedDepartments.add(model);
    emit(UpdateLetterRemoveDepartmentFromAction());
  }
  void removeFromKnow(SelectedDepartmentModel model){
    selectedKnowDepartmentsList.remove(model);
    removedDepartments.add(model);
    emit(UpdateLetterRemoveDepartmentFromKnow());
  }

  void addDepartmentToAction(DepartmentModel model){
    bool isThereActionExist = selectedActionDepartmentsList.any((element) => (element?.sectorId == model.sectorId) && (element?.actionName == AppStrings.action.tr()));
    if(isThereActionExist){
      var department = selectedActionDepartmentsList.where((element) => (element?.sectorId == model.sectorId) && (element?.actionName == AppStrings.action.tr())).first;
      selectedActionDepartmentsList.remove(department);
    }
    if(isDepartmentFoundAsKnow(model)){
      var department = selectedKnowDepartmentsList.where((element) => element?.departmentId == model.departmentId).first;
      selectedKnowDepartmentsList.remove(department);
    }
    if(isDepartmentFoundAsAction(model)){
      var department = selectedActionDepartmentsList.where((element) => (element?.sectorId == model.sectorId)).first;
      selectedActionDepartmentsList.remove(department);
    }else{
      var sector = sectorsList.where((element) => element.sectorId == model.sectorId).first;
      selectedActionDepartmentsList.add(SelectedDepartmentModel(model.departmentId, model.departmentName, sector.sectorId,sector.sectorName, AppStrings.action.tr()));
    }
    emit(UpdateLetterAddDepartmentToAction());
  }

  bool isDepartmentFoundAsAction(DepartmentModel model){
    if(selectedActionDepartmentsList.where((element) => element?.departmentId == model.departmentId).isNotEmpty){
      var department = selectedActionDepartmentsList.where((element) => element?.departmentId == model.departmentId).first;
      return department?.actionName == AppStrings.action.tr();
    }else{
      return false;
    }
  }
  bool isDepartmentFoundAsKnow(DepartmentModel model){
    if(selectedKnowDepartmentsList.where((element) => element?.departmentId == model.departmentId).isNotEmpty){
      var department = selectedKnowDepartmentsList.where((element) => element?.departmentId == model.departmentId).first;
      return department?.actionName == AppStrings.know.tr();
    }else{
      return false;
    }
  }
  void addDepartmentToKnow(DepartmentModel model){
    if(!isDepartmentFoundAsAction(model)){
      if(isDepartmentFoundAsKnow(model)){
        //exist as know
        var department = selectedKnowDepartmentsList.where((element) => element?.departmentId == model.departmentId).first;
        selectedKnowDepartmentsList.remove(department);
      }else{
        // not know not action
        var sector = sectorsList.where((element) => element.sectorId == model.sectorId).first;
        selectedKnowDepartmentsList.add(SelectedDepartmentModel(model.departmentId, model.departmentName, sector.sectorId,sector.sectorName, AppStrings.know.tr()));
      }
    }
    emit(UpdateLetterAddDepartmentToKnow());
  }

  void changeSecurityLevel(int newLevel){
    securityLevel = newLevel;
    emit(UpdateLetterChangeSecurityLevel());
  }
  void changeNecessaryLevel(int newLevel){
    necessaryLevel = newLevel;
    emit(UpdateLetterChangeNecessaryLevel());
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: AppStrings.pickFiles.tr(),
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.isNotEmpty) {
      pickedFiles.addAll(result.files);
    }
    emit(UpdateLetterPickFiles());
  }
  void deleteFile(PlatformFile file){
    pickedFiles.retainWhere((element) => element != file);
    emit(UpdateLetterRemoveFile());
  }

  void changeSelectedSector(SectorModel model) {
    selectedSectorModel = model;
    getDepartments(model.sectorId);
    emit(UpdateLetterChangeSelectedSector());
  }
  void changeSelectedDirection(DirectionModel model) {
    selectedDirection = model;
    emit(UpdateLetterChangeSelectedDirection());
  }

  Future<void> getSectors() async {
    emit(UpdateLetterLoadingSectors());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getSectorsUseCase(GetSectorsParameters(sessionToken));
    result.fold(
            (l) => emit(UpdateLetterErrorGetSectors(l.errMessage)),
            (r) {
          sectorsList = [];
          sectorsList = r;
          emit(UpdateLetterSuccessfulGetSectors());
        });
  }
  Future<void> getTags() async {
    emit(UpdateLetterLoadingTags());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getTagsUseCase(GetTagsParameters(sessionToken));
    result.fold(
            (l) => emit(UpdateLetterErrorGetTags(l.errMessage)),
            (r) {
          tagsList = [];
          tagsList = r;
          emit(UpdateLetterSuccessfulGetTags());
        });
  }

  Future<void> getDepartments(int sectorId) async {
    emit(UpdateLetterLoadingDepartments());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    var userMap = jsonDecode(Preference.getString("User").toString());
    UserModel myUserModel = UserModel.fromJson(userMap);
    final result = await getDepartmentsUseCase(GetDepartmentsParameters(sessionToken,sectorId));
    result.fold(
            (l) => emit(UpdateLetterErrorGetDepartments(l.errMessage)),
            (r) {
          departmentsList = [];
          departmentsList = r;
          departmentsList.removeWhere((element) => element.departmentId == myUserModel.departmentId);
          emit(UpdateLetterSuccessfulGetDepartments());
        });
  }
  Future<void> getAllDirections() async {
    emit(UpdateLetterLoadingDirections());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getDirectionsUseCase(GetDirectionsParameters(sessionToken));
    result.fold(
            (l) => emit(UpdateLetterErrorGetDirections(l.errMessage)),
            (r) {
          directionsList = [];
          directionsList = r;
          emit(UpdateLetterSuccessfulGetDirections());
        });
  }
  Future<void> updateLetter(LetterModel letterModel)async {
    emit(UpdateLetterLoading());
    String token = Preference.prefs.getString("sessionToken").toString();

    Map <String, dynamic> letterData = {
      'letterId': letterModel.letterId,
      'letterAbout' : letterAboutController.text.toString(),
      'letterNumber' : letterNumberController.text.toString(),
      'letterContent' : letterContentController.text.toString(),
      'necessaryId' : necessaryLevel,
      'confidentialityId' : securityLevel,
    };

    if(isSecretary()){
      letterData['directionId'] = selectedDirection?.directionId;
    }

    final result = await updateLetterUseCase(UpdateLetterParameters(letterData,token));
    result.fold(
            (l) => emit(UpdateLetterError(l.errMessage)),
            (r) {
              emit(UpdateLetterSuccessful());
            });
  }

  bool isSecretary(){
    var userMap = jsonDecode(Preference.getString("User").toString());
    if(userMap != null){
      UserModel myUserModel = UserModel.fromJson(userMap);
      return myUserModel.roleId == 3;
    }else{
      return false;
    }
  }
  void addOrRemoveTag(TagModel model){
    selectedTagsList.contains(model) ?
    selectedTagsList.remove(model) : selectedTagsList.add(model);
    emit(UpdateLetterAddTags());
  }

}