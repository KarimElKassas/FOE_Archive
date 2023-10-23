import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/data/models/direction_model.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/data/models/user_model.dart';
import 'package:foe_archive/domain/usecase/create_letter_use_case.dart';
import 'package:foe_archive/domain/usecase/get_directions_use_case.dart';
import 'package:foe_archive/domain/usecase/upload_letter_files_use_case.dart';
import 'package:foe_archive/presentation/new_letter/bloc/new_letter_states.dart';
import 'package:hive/hive.dart';

import '../../../data/models/department_model.dart';
import '../../../data/models/sector_model.dart';
import '../../../data/models/selected_department_model.dart';
import '../../../data/models/tag_model.dart';
import '../../../domain/usecase/get_departments_use_case.dart';
import '../../../domain/usecase/get_letter_by_id_use_case.dart';
import '../../../domain/usecase/get_sectors_use_case.dart';
import '../../../domain/usecase/get_tags_use_case.dart';
import '../../../resources/strings_manager.dart';
import '../../../utils/prefs_helper.dart';

class NewLetterCubit extends Cubit<NewLetterStates>{
  NewLetterCubit(this.getSectorsUseCase,this.getDepartmentsUseCase,this.getTagsUseCase,this.getDirectionsUseCase,this.createLetterUseCase,this.uploadLetterFilesUseCase,this.getLetterByIdUseCase) : super(NewLetterInitial());

  static NewLetterCubit get(context)=> BlocProvider.of(context);

  GetTagsUseCase getTagsUseCase;
  GetSectorsUseCase getSectorsUseCase;
  GetDepartmentsUseCase getDepartmentsUseCase;
  GetDirectionsUseCase getDirectionsUseCase;
  CreateLetterUseCase createLetterUseCase;
  UploadLetterFilesUseCase uploadLetterFilesUseCase;
  GetLetterByIdUseCase getLetterByIdUseCase;

  TextEditingController letterAboutController = TextEditingController();
  TextEditingController letterNumberController = TextEditingController();
  TextEditingController letterContentController = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<PlatformFile> pickedFiles = [];
  List<MultipartFile> multipartFiles = [];
  List<String>? filesSize;
  List<String>? filesName;
  List<String> selectedMentions = [];

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

  int securityLevel = 1;
  int necessaryLevel = 1;
  void changeSecurityLevel(int newLevel){
    securityLevel = newLevel;
    emit(NewLetterChangeSecurityLevel());
  }
  void changeNecessaryLevel(int newLevel){
    necessaryLevel = newLevel;
    emit(NewLetterChangeNecessaryLevel());
  }
  void clearData(){
    letterAboutController.clear();
    letterNumberController.clear();
    letterContentController.clear();
    pickedFiles.clear();
    selectedTagsList.clear();
    selectedDirection = null;
    necessaryLevel = 1;
    securityLevel = 1;
    selectedKnowDepartmentsList.clear();
    selectedActionDepartmentsList.clear();
  }
  void removeFromAction(SelectedDepartmentModel model){
    selectedActionDepartmentsList.remove(model);
    emit(NewLetterRemoveDepartmentFromAction());
  }
  void removeFromKnow(SelectedDepartmentModel model){
    selectedKnowDepartmentsList.remove(model);
    emit(NewLetterRemoveDepartmentFromKnow());
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
    emit(NewLetterAddDepartmentToAction());
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
    emit(NewLetterAddDepartmentToKnow());
  }

  void addOrRemoveTag(TagModel model){
    selectedTagsList.contains(model) ?
    selectedTagsList.remove(model) : selectedTagsList.add(model);
    emit(NewLetterAddTags());
  }
  void changeSelectedSector(SectorModel model) {
    selectedSectorModel = model;
    getDepartments(model.sectorId);
    emit(NewLetterChangeSelectedSector());
  }
  void changeSelectedDirection(DirectionModel model) {
    selectedDirection = model;
    emit(NewLetterChangeSelectedDirection());
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
    emit(NewLetterPickFiles());
  }
  void deleteFile(PlatformFile file){
    pickedFiles.retainWhere((element) => element != file);
    emit(NewLetterRemoveFile());
  }
  Future<void> preparedFiles()async {
    multipartFiles = [];
    filesSize = [];
    filesName = [];
    for(int i = 0; i < pickedFiles.length; i++) {
      final file = await MultipartFile.fromFile(pickedFiles[i].path!, filename: pickedFiles[i].name,);
      var size = "";
      if (pickedFiles[i].size > 1000000){
        size = "${(pickedFiles[i].size * 0.000001).toStringAsFixed(2)} MB";
      }else {
        size = "${(pickedFiles[i].size * 0.001).toStringAsFixed(2)} KB";
      }
      multipartFiles.add(file);
      filesSize?.add(size);
      filesName?.add(file.filename??"");
    }
  }

  void departmentLetterList(){
    uploadDepartmentsList = [];
    for (var element in selectedActionDepartmentsList) {
      Map<String,dynamic> map = {
        'requiredAction': true,
        'departmentId' : element?.departmentId
      };
      uploadDepartmentsList.add(map);
    }
    for (var element in selectedKnowDepartmentsList) {
      Map<String,dynamic> map = {
        'requiredAction': false,
        'departmentId' : element?.departmentId
      };
      uploadDepartmentsList.add(map);
    }
  }
  void selectedTags(){
    uploadTagsList = [];
    for(var tag in selectedTagsList){
      uploadTagsList.add(tag.tagId);
    }
  }
  void prepareMentions(){
    uploadMentionsList = [];
    for (var element in selectedMentions) {
      Map<String,dynamic> map = {
        'mentionId': 1,
        'letterNumber' : element.toString()
      };
      uploadMentionsList.add(map);
    }
  }

  Future<void> getTags() async {
    emit(NewLetterLoadingTags());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getTagsUseCase(GetTagsParameters(sessionToken));
    result.fold(
            (l) => emit(NewLetterErrorGetTags(l.errMessage)),
            (r) {
          tagsList = [];
          tagsList = r;
          emit(NewLetterSuccessfulGetTags());
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
  Future<void> getSectors() async {
    emit(NewLetterLoadingSectors());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getSectorsUseCase(GetSectorsParameters(sessionToken));
    result.fold(
            (l) => emit(NewLetterErrorGetSectors(l.errMessage)),
            (r) {
          sectorsList = [];
          sectorsList = r;
          emit(NewLetterSuccessfulGetSectors());
        });
  }
  Future<void> getDepartments(int sectorId) async {
    emit(NewLetterLoadingDepartments());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    var userMap = jsonDecode(Preference.getString("User").toString());
    UserModel myUserModel = UserModel.fromJson(userMap);
    final result = await getDepartmentsUseCase(GetDepartmentsParameters(sessionToken,sectorId));
    result.fold(
            (l) => emit(NewLetterErrorGetDepartments(l.errMessage)),
            (r) {
          departmentsList = [];
          departmentsList = r;
          departmentsList.removeWhere((element) => element.departmentId == myUserModel.departmentId);
          emit(NewLetterSuccessfulGetDepartments());
        });
  }
  Future<void> createLetter()async {
    emit(NewLetterLoadingCreate());
    String token = Preference.prefs.getString("sessionToken").toString();

    departmentLetterList();
    selectedTags();
    prepareMentions();

    Map <String, dynamic> letterData = {
      'receivedDepartments': uploadDepartmentsList,
      'letterAbout' : letterAboutController.text.toString(),
      'letterNumber' : letterNumberController.text.toString(),
      'letterContent' : letterContentController.text.toString(),
      'necessaryId' : necessaryLevel,
      'confidentialityId' : securityLevel,
      'tagsId' : uploadTagsList,
      'letterMentions' : uploadMentionsList,
    };

    if(isSecretary()){
      letterData['directionId'] = selectedDirection?.directionId;
    }

    final result = await createLetterUseCase(CreateLetterParameters(letterData,token));
    result.fold(
            (l) => emit(NewLetterErrorCreate(l.errMessage)),
            (r) {
          if(pickedFiles.isNotEmpty){
            uploadLetterFiles(r, token);
          }else{
            clearData();
            emit(NewLetterSuccessfulCreate());
          }
          getLetterById(r);
        });
  }
  Future<void> uploadLetterFiles(int letterId, String token)async {
    await preparedFiles();
    Map <String, dynamic> letterData = {
      'letterId': letterId,
      'Files':multipartFiles,
    };

    final result = await uploadLetterFilesUseCase(UploadLetterFilesParameters(FormData.fromMap(letterData),token));
    result.fold(
            (l) => emit(NewLetterErrorCreate(l.errMessage)),
            (r) {
          clearData();
          emit(NewLetterSuccessfulCreate());
        });
  }

  Future<void> getAllDirections() async {
    emit(NewLetterLoadingDirections());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getDirectionsUseCase(GetDirectionsParameters(sessionToken));
    result.fold(
            (l) => emit(NewLetterErrorGetDirections(l.errMessage)),
            (r) {
          directionsList = [];
          directionsList = r;
          emit(NewLetterSuccessfulGetDirections());
        });
  }
  Future<void> addLetterToCache(LetterModel letter)async{
    var lettersBox = Hive.box('OutgoingInternalLetters');
    var list = List<LetterModel>.from((lettersBox.get("lettersList", defaultValue: []) as List<dynamic>).map((e) => LetterModel.fromJson((e as LetterModel).toJson())));
    list.add(letter);
    lettersBox.put('lettersList', list);
  }
  Future<void> getLetterById(int letterId) async {
    emit(NewLetterLoadingGetLetter());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getLetterByIdUseCase(GetLetterByIdParameters(letterId ,sessionToken));
    result.fold(
            (l) => emit(NewLetterErrorGetLetter(l.errMessage)),
            (r) {
              addLetterToCache(r!);
          emit(NewLetterSuccessfulGetLetter());
        });
  }
}