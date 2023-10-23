import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/domain/usecase/create_archived_letter_use_case.dart';
import 'package:foe_archive/domain/usecase/create_for_me_letter_use_case.dart';
import 'package:foe_archive/domain/usecase/get_archived_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_for_me_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/upload_letter_files_use_case.dart';
import 'package:foe_archive/presentation/archived_letter/bloc/archived_letter_states.dart';
import 'package:foe_archive/resources/color_manager.dart';
import 'package:foe_archive/resources/font_manager.dart';
import 'package:hive/hive.dart';
import 'package:v_chat_mention_controller/v_chat_mention_controller.dart';

import '../../../data/models/department_model.dart';
import '../../../data/models/direction_model.dart';
import '../../../data/models/sector_model.dart';
import '../../../data/models/selected_department_model.dart';
import '../../../data/models/tag_model.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/usecase/create_letter_use_case.dart';
import '../../../domain/usecase/get_departments_use_case.dart';
import '../../../domain/usecase/get_directions_use_case.dart';
import '../../../domain/usecase/get_letter_by_id_use_case.dart';
import '../../../domain/usecase/get_sectors_use_case.dart';
import '../../../domain/usecase/get_tags_use_case.dart';
import '../../../resources/strings_manager.dart';
import '../../../utils/prefs_helper.dart';

class ArchivedLettersCubit extends Cubit<ArchivedLettersStates>{
  ArchivedLettersCubit(this.getDepartmentsUseCase,this.getSectorsUseCase,this.getTagsUseCase,
      this.createArchivedLetterUseCase,this.createForMeLetterUseCase,
      this.uploadLetterFilesUseCase,this.getArchivedLettersUseCase,this.getForMeLettersUseCase,this.getLetterByIdUseCase,this.getDirectionsUseCase) : super(ArchivedLettersInitial());

  static ArchivedLettersCubit get(context) => BlocProvider.of(context);

  GetDepartmentsUseCase getDepartmentsUseCase;
  GetDirectionsUseCase getDirectionsUseCase;
  GetSectorsUseCase getSectorsUseCase;
  GetTagsUseCase getTagsUseCase;
  GetArchivedLettersUseCase getArchivedLettersUseCase;
  GetForMeLettersUseCase getForMeLettersUseCase;
  CreateArchivedLetterUseCase createArchivedLetterUseCase;
  CreateForMeLetterUseCase createForMeLetterUseCase;
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

  DirectionModel? selectedDirection;
  List<DirectionModel> directionsList = [];

  List<SectorModel> sectorsList = [];
  SectorModel? selectedSectorModel;

  List<TagModel> tagsList = [];
  List<TagModel> selectedTagsList = [];
  List<String> selectedMentions = [];

  List<LetterModel> lettersList = [];
  List<LetterModel> filteredLettersList = [];

  List<DepartmentModel> departmentsList = [];
  List<SelectedDepartmentModel?> selectedActionDepartmentsList = [];
  List<SelectedDepartmentModel?> selectedKnowDepartmentsList = [];
  List<DepartmentModel> departmentsToKnowList = [];
  List<Map<String,dynamic>> uploadDepartmentsList = [];
  List<Map<String,dynamic>> uploadMentionsList = [];
  List<int> uploadTagsList = [];
  List<String> letterOption = [AppStrings.localLetter.tr(),AppStrings.oldArchive.tr(),AppStrings.sendToOutside.tr()];
  String selectedOption = AppStrings.localLetter.tr();
  List<String> suggestions = ['John', 'Jane', 'Smith'];
  List<String> filteredSuggestions = [];
  List<TagModel> filteredTags = [];
  bool isOldArchivedLetter = false;
  int securityLevel = 1;
  int necessaryLevel = 1;
  bool showSuggestions = false;
  DateTime oldArchiveDate = DateTime.now();
  String imageUrl = Uri.encodeFull("\\\\nas.foe\\إدارة الرقمنة\\bassam\\Logo 11111.png");
  final controller = VChatTextMentionController(
    debounce: 500,
    ///set custom style
    mentionStyle: TextStyle(
        color: ColorManager.goldColor,
        fontWeight: FontWeight.w500,
        fontFamily: FontConstants.family,
        decoration: TextDecoration.underline
    ),
  );
  String parsedText = "";
  final logs = <String>[];
  final mentions = <String>[];
  bool isSearchCanView = false;
  void changeLetterOption(String newValue){
    selectedOption = newValue;
    if(selectedOption == AppStrings.oldArchive.tr()){
      isOldArchivedLetter = true;
    }else{
      isOldArchivedLetter = false;
    }
    emit(ArchivedLettersChangeLetterType());
  }

  void initController(){
    controller.onSearch = (str) async {
      mentions.clear();
      filteredTags = tagsList.where((element) => element.tagName.contains(str??"")).toList();

      if (str != null) {
        //  print("search by $str");
        isSearchCanView = true;
        //send request

        /*for (var element in filteredTags) {
          if (element.tagName.contains(str)) {
            mentions.add(element.tagName);
          }
        }*/
      } else {
        //stop request
        isSearchCanView = false;
      }
      emit(ArchivedLettersInitController());
    };
    controller.buildTextSpan();
  }
  Future<void> getAllDirections() async {
    emit(ArchiveLettersLoadingDirections());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getDirectionsUseCase(GetDirectionsParameters(sessionToken));
    result.fold(
            (l) => emit(ArchivedLettersErrorGetDirections(l.errMessage)),
            (r) {
          directionsList = [];
          directionsList = r;
          emit(ArchivedLettersSuccessfulGetDirections());
        });
  }

  void changeShowSuggestions(bool newValue){
    if(showSuggestions != newValue){
      showSuggestions = newValue;
      emit(ArchivedLettersChangeShowSuggestions());
    }
  }
  void updateSuggestionList(String value){
    filteredTags = tagsList.where((suggestion) => suggestion.tagName.contains(value)).toList();
    emit(ArchivedLettersUpdateSuggestions());
  }
  void updateLetterContent(String newText, int cursorPosition){
    letterContentController.value = TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
    emit(ArchivedLettersUpdateContent());
  }
  void changeCalendarDate(DateTime newDate){
    oldArchiveDate = newDate;
    emit(ArchivedLettersChangeDate());
  }
  String formatDate(String date) {
    var format2 = DateFormat("EEE , d MMM , yyyy" ,"ar");
    var dateString = format2.format(DateTime.parse(date));
    return dateString;
  }
  void changeSecurityLevel(int newLevel){
    securityLevel = newLevel;
    emit(ArchivedLettersChangeSecurityLevel());
  }
  void changeNecessaryLevel(int newLevel){
    necessaryLevel = newLevel;
    emit(ArchivedLettersChangeNecessaryLevel());
  }
  void changeOldArchived(){
    isOldArchivedLetter = !isOldArchivedLetter;
    emit(ArchivedLettersChangeOldArchived());
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
    emit(ArchivedLettersPickFiles());
  }
  void changeSelectedDirection(DirectionModel model) {
    selectedDirection = model;
    emit(ArchivedLettersChangeSelectedDirection());
  }

  void removeFromAction(SelectedDepartmentModel model){
    selectedActionDepartmentsList.remove(model);
    emit(ArchivedLettersRemoveDepartmentFromAction());
  }
  void removeFromKnow(SelectedDepartmentModel model){
    selectedKnowDepartmentsList.remove(model);
    emit(ArchivedLettersRemoveDepartmentFromKnow());
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
    emit(ArchivedLettersAddDepartmentToAction());
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
    emit(ArchivedLettersAddDepartmentToKnow());
  }

  void addOrRemoveTag(TagModel model){
    selectedTagsList.contains(model) ?
    selectedTagsList.remove(model) : selectedTagsList.add(model);
    emit(ArchivedLettersAddTags());
  }
  void changeSelectedSector(SectorModel model) {
    selectedSectorModel = model;
    getDepartments(model.sectorId);
    emit(ArchivedLettersChangeSelectedSector());
  }
  void deleteFile(PlatformFile file){
    pickedFiles.retainWhere((element) => element != file);
    emit(ArchivedLettersRemoveFile());
  }
  void initLettersList(){
    var lettersBox = Hive.box("ArchivedLetters");
    filteredLettersList = List<LetterModel>.from((lettersBox.get("lettersList", defaultValue: []) as List<dynamic>).map((e) => LetterModel.fromJson((e as LetterModel).toJson())));
  }

  Future<void> getDepartments(int sectorId) async {
    emit(ArchivedLettersLoadingDepartments());
    var userMap = jsonDecode(Preference.getString("User").toString());
    UserModel myUserModel = UserModel.fromJson(userMap);
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getDepartmentsUseCase(GetDepartmentsParameters(sessionToken,sectorId));
    result.fold(
            (l) => emit(ArchivedLettersErrorGetDepartments(l.errMessage)),
            (r) {
          departmentsList = [];
          departmentsList = r;
          departmentsList.removeWhere((element) => element.departmentId == myUserModel.departmentId);
          emit(ArchivedLettersSuccessfulGetDepartments());
        });
  }
  Future<void> getTags() async {
    emit(ArchivedLettersLoadingTags());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getTagsUseCase(GetTagsParameters(sessionToken));
    result.fold(
            (l) => emit(ArchivedLettersErrorGetTags(l.errMessage)),
            (r) {
          tagsList = [];
          tagsList = r;
          filteredTags = tagsList;
          emit(ArchivedLettersSuccessfulGetTags());
        });
  }
  Future<void> getSectors() async {
    emit(ArchivedLettersLoadingSectors());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getSectorsUseCase(GetSectorsParameters(sessionToken));
    result.fold(
            (l) => emit(ArchivedLettersErrorGetSectors(l.errMessage)),
            (r) {
          sectorsList = [];
          sectorsList = r;
          emit(ArchivedLettersSuccessfulGetSectors());
        });
  }
  Future<void> getArchivedLetters() async {
    emit(ArchivedLettersLoadingLetters());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getArchivedLettersUseCase(GetArchivedLettersParameters(sessionToken));
    result.fold(
            (l) => emit(ArchivedLettersErrorGetLetters(l.errMessage)),
            (r) {
          lettersList = [];
          lettersList = r;
          filteredLettersList = r;
          emit(ArchivedLettersSuccessfulGetLetters());
        });
  }
  Future<void> getForMeLetters() async {
    emit(ArchivedLettersLoadingLetters());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getForMeLettersUseCase(GetForMeLettersParameters(sessionToken));
    result.fold(
            (l) => emit(ArchivedLettersErrorGetLetters(l.errMessage)),
            (r) {
          lettersList = [];
          lettersList = r;
          filteredLettersList = r;
          emit(ArchivedLettersSuccessfulGetLetters());
        });
  }

  Future<void> createArchivedLetter()async {
    emit(ArchivedLettersLoadingCreateLetter());
    String token = Preference.prefs.getString("sessionToken").toString();

    departmentLetterList();
    selectedTags();
    prepareMentions();
    print("SEEL : ${selectedDirection}");
    Map <String, dynamic> letterData = {
      'receivedDepartments': uploadDepartmentsList,
      'confidentialityId' : securityLevel,
      'necessaryId' : necessaryLevel,
      'LetterAbout' : letterAboutController.text.toString(),
      'LetterNumber' : letterNumberController.text.toString(),
      'LetterContent' : controller.text.toString(),
      'LetterDate' : oldArchiveDate.toString(),
      'tagsId' : uploadTagsList,
      'directionId' : selectedDirection?.directionId,
      'letterMentions' : uploadMentionsList
    };
    final result = await createArchivedLetterUseCase(CreateLetterParameters(letterData,token));
    result.fold(
            (l) => emit(ArchivedLettersErrorCreateLetter(l.errMessage)),
            (r) {
          if(pickedFiles.isNotEmpty){
            uploadLetterFiles(r, token);
          }else{
            print("RETURN : $r");
            clearData();
            emit(ArchivedLettersSuccessCreateLetter());
          }
          getLetterById(r);
        });
  }
  Future<void> createForMeLetter()async {
    emit(ArchivedLettersLoadingCreateLetter());
    String token = Preference.prefs.getString("sessionToken").toString();

    selectedTags();
    prepareMentions();

    Map <String, dynamic> letterData = {
      'confidentialityId' : securityLevel,
      'necessaryId' : necessaryLevel,
      'LetterAbout' : letterAboutController.text.toString(),
      'LetterNumber' : letterNumberController.text.toString(),
      'LetterContent' : controller.text.toString(),
      'LetterDate' : oldArchiveDate.toString(),
      'tagsId' : uploadTagsList,
      'letterMentions' : uploadMentionsList
    };

    final result = await createForMeLetterUseCase(CreateLetterParameters(letterData,token));
    result.fold(
            (l) => emit(ArchivedLettersErrorCreateLetter(l.errMessage)),
            (r) {
          if(pickedFiles.isNotEmpty){
            uploadLetterFiles(r, token);
          }else{
            print("RETURN : $r");
            clearData();
            emit(ArchivedLettersSuccessCreateLetter());
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
            (l) => emit(ArchivedLettersErrorCreateLetter(l.errMessage)),
            (r) {
          print("RETURN File List : $r");
          clearData();
          emit(ArchivedLettersSuccessCreateLetter());
        });
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
  void selectedTags(){
    uploadTagsList = [];
    for(var tag in selectedTagsList){
      uploadTagsList.add(tag.tagId);
    }
  }
  void clearData(){
    letterAboutController.clear();
    letterNumberController.clear();
    letterContentController.clear();
    controller.clear();
    pickedFiles.clear();
    selectedTagsList.clear();
    selectedDirection = null;
    isOldArchivedLetter = false;
    securityLevel = 1;
    necessaryLevel = 1;
    selectedKnowDepartmentsList.clear();
    selectedActionDepartmentsList.clear();
  }
  void searchLetters(String value){
    filteredLettersList = lettersList.where((element) => element.letterNumber.contains(value) || element.letterAbout.contains(value) || element.letterContent.contains(value)).toList();
    emit(ArchivedLettersSearchLetters());
  }
  Future<void> addLetterToCache(LetterModel letter)async{
    var lettersBox = Hive.box(isOldArchivedLetter ? 'ArchivedLetters' : 'ForMeLetters');
    var list = List<LetterModel>.from((lettersBox.get("lettersList", defaultValue: []) as List<dynamic>).map((e) => LetterModel.fromJson((e as LetterModel).toJson())));
    list.add(letter);
    lettersBox.put('lettersList', list);
  }
  Future<void> getLetterById(int letterId) async {
    emit(ArchivedLettersLoadingGetLetter());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getLetterByIdUseCase(GetLetterByIdParameters(letterId ,sessionToken));
    result.fold(
            (l) => emit(ArchivedLettersErrorGetLetter(l.errMessage)),
            (r) {
          addLetterToCache(r!);
          emit(ArchivedLettersSuccessfulGetLetter());
        });
  }
}