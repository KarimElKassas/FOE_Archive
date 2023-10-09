import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/data/models/department_model.dart';
import 'package:foe_archive/data/models/direction_model.dart';
import 'package:foe_archive/data/models/selected_department_model.dart';
import 'package:foe_archive/data/models/user_model.dart';
import 'package:foe_archive/domain/usecase/create_letter_use_case.dart';
import 'package:foe_archive/domain/usecase/get_departments_use_case.dart';
import 'package:foe_archive/domain/usecase/get_directions_use_case.dart';
import 'package:foe_archive/domain/usecase/get_sectors_use_case.dart';
import 'package:foe_archive/domain/usecase/get_tags_use_case.dart';
import 'package:foe_archive/domain/usecase/upload_letter_files_use_case.dart';
import 'package:foe_archive/presentation/letter_reply/bloc/letter_reply_states.dart';
import 'package:foe_archive/resources/color_manager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../data/models/sector_model.dart';
import '../../../data/models/tag_model.dart';
import '../../../resources/strings_manager.dart';
import '../../../utils/prefs_helper.dart';

class LetterReplyCubit extends Cubit<LetterReplyStates>{
  LetterReplyCubit(this.createLetterUseCase,this.uploadLetterFilesUseCase,this.getTagsUseCase,this.getSectorsUseCase,this.getDepartmentsUseCase,this.getDirectionsUseCase)
      : super(LetterReplyInitial());

  static LetterReplyCubit get(context) => BlocProvider.of(context);

  CreateLetterUseCase createLetterUseCase;
  UploadLetterFilesUseCase uploadLetterFilesUseCase;
  GetTagsUseCase getTagsUseCase;
  GetSectorsUseCase getSectorsUseCase;
  GetDepartmentsUseCase getDepartmentsUseCase;
  GetDirectionsUseCase getDirectionsUseCase;

  TextEditingController letterAboutController = TextEditingController();
  TextEditingController letterNumberController = TextEditingController();
  TextEditingController letterContentController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Color letterNumberColor = ColorManager.goldColor;

  List<PlatformFile> pickedFiles = [];
  List<MultipartFile> multipartFiles = [];
  List<String>? filesSize;
  List<String>? filesName;

  List<TagModel> tagsList = [];
  List<TagModel> selectedTagsList = [];

  List<SectorModel> sectorsList = [];
  SectorModel? selectedSectorModel;

  DirectionModel? selectedDirection;
  List<DirectionModel> directionsList = [];

  List<DepartmentModel> departmentsList = [];
  List<SelectedDepartmentModel?> selectedActionDepartmentsList = [];
  List<SelectedDepartmentModel?> selectedKnowDepartmentsList = [];
  List<DepartmentModel> departmentsToKnowList = [];
  List<Map<String,dynamic>> uploadDepartmentsList = [];
  List<int> uploadTagsList = [];
  List<Map<String,dynamic>> uploadMentionsList = [];
  List<String> selectedMentions = [];

  int securityLevel = 1;
  int necessaryLevel = 1;
  void changeSecurityLevel(int newLevel){
    securityLevel = newLevel;
    emit(LetterReplyChangeSecurityLevel());
  }
  void changeNecessaryLevel(int newLevel){
    necessaryLevel = newLevel;
    emit(LetterReplyChangeNecessaryLevel());
  }
  void changeSelectedDirection(DirectionModel model) {
    selectedDirection = model;
    emit(LetterReplyChangeSelectedDirection());
  }

  bool isSecretary(){
    var userMap = jsonDecode(Preference.getString("User").toString());
    UserModel myUserModel = UserModel.fromJson(userMap);
    return myUserModel.roleId == 3;
  }

  void removeFromAction(SelectedDepartmentModel model){
    selectedActionDepartmentsList.remove(model);
    emit(LetterReplyRemoveDepartmentFromAction());
  }
  void removeFromKnow(SelectedDepartmentModel model){
    selectedKnowDepartmentsList.remove(model);
    emit(LetterReplyRemoveDepartmentFromKnow());
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

    var sector = sectorsList.where((element) => element.sectorId == model.sectorId).first;
    selectedActionDepartmentsList.add(SelectedDepartmentModel(model.departmentId, model.departmentName, sector.sectorId,sector.sectorName, AppStrings.action.tr()));
    emit(LetterReplyAddDepartmentToAction());
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
  bool isContainDepartment(DepartmentModel model){
    return isDepartmentFoundAsAction(model) || isDepartmentFoundAsKnow(model);
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
    emit(LetterReplyAddDepartmentToKnow());
  }

  void addOrRemoveTag(TagModel model){
    selectedTagsList.contains(model) ?
    selectedTagsList.remove(model) : selectedTagsList.add(model);
    emit(LetterReplyAddTags());
  }
  void changeSelectedSector(SectorModel model) {
    selectedSectorModel = model;
    getDepartments(model.sectorId);
    emit(LetterReplyChangeSelectedSector());
  }

  void changeLetterNumberColor(Color newColor){
    if(letterNumberColor != newColor){
      letterNumberColor = newColor;
      emit(LetterReplyChangeColor());
    }
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
    emit(LetterReplyPickFiles());
  }
  void deleteFile(PlatformFile file){
    pickedFiles.retainWhere((element) => element != file);
    emit(LetterReplyRemoveFile());
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
  void tokenHandle(){
    String token = Preference.prefs.getString("sessionToken").toString();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    print("END TIME : ${JwtDecoder.getExpirationDate(token)}");
    print("DATA TOKEN : ${decodedToken}");
  }
  Future<void> createLetter(int replyOnLetterId)async {
    emit(LetterReplyLoadingSend());
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
      'previousLetterId' : replyOnLetterId,
      'tagsId' : uploadTagsList,
      'letterMentions' : uploadMentionsList,
    };
    print("TOKEN : $token");
    final result = await createLetterUseCase(CreateLetterParameters(letterData,token));
    result.fold(
            (l) => emit(LetterReplyErrorSend(l.errMessage)),
            (r) {
              if(pickedFiles.isNotEmpty){
                uploadLetterFiles(r, token);
              }else{
                print("RETURN : $r");
                emit(LetterReplySuccessfulSend());
              }
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
            (l) => emit(LetterReplyErrorSend(l.errMessage)),
            (r) {
              print("RETURN File List : $r");
          emit(LetterReplySuccessfulSend());
        });
  }
  Future<void> getTags() async {
    emit(LetterReplyLoadingTags());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getTagsUseCase(GetTagsParameters(sessionToken));
    result.fold(
            (l) => emit(LetterReplyErrorGetTags(l.errMessage)),
            (r) {
          tagsList = [];
          tagsList = r;
          emit(LetterReplySuccessfulGetTags());
        });
  }
  Future<void> getSectors() async {
    emit(LetterReplyLoadingSectors());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getSectorsUseCase(GetSectorsParameters(sessionToken));
    result.fold(
            (l) => emit(LetterReplyErrorGetSectors(l.errMessage)),
            (r) {
          sectorsList = [];
          sectorsList = r;
          emit(LetterReplySuccessfulGetSectors());
        });
  }
  Future<void> getDepartments(int sectorId) async {
    emit(LetterReplyLoadingDepartments());
    var userMap = jsonDecode(Preference.getString("User").toString());
    UserModel myUserModel = UserModel.fromJson(userMap);
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getDepartmentsUseCase(GetDepartmentsParameters(sessionToken,sectorId));
    result.fold(
            (l) => emit(LetterReplyErrorGetDepartments(l.errMessage)),
            (r) {
          departmentsList = [];
          departmentsList = r;
          departmentsList.removeWhere((element) => element.departmentId == myUserModel.departmentId);
          emit(LetterReplySuccessfulGetDepartments());
        });
  }
  Future<void> getAllDirections() async {
    emit(LetterReplyLoadingDirections());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getDirectionsUseCase(GetDirectionsParameters(sessionToken));
    result.fold(
            (l) => emit(LetterReplyErrorGetDirections(l.errMessage)),
            (r) {
          directionsList = [];
          directionsList = r;
          emit(LetterReplySuccessfulGetDirections());
        });
  }

}