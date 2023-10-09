import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/data/models/department_model.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/data/models/user_model.dart';
import 'package:foe_archive/domain/usecase/get_all_departments_use_case.dart';
import 'package:foe_archive/domain/usecase/get_letter_by_id_use_case.dart';
import 'package:foe_archive/presentation/letter_details/bloc/letter_details_states.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/sector_model.dart';
import '../../../data/models/selected_department_model.dart';
import '../../../domain/usecase/get_departments_use_case.dart';
import '../../../domain/usecase/get_sectors_use_case.dart';
import '../../../resources/strings_manager.dart';
import '../../../utils/prefs_helper.dart';

class LetterDetailsCubit extends Cubit<LetterDetailsStates>{
  LetterDetailsCubit(this.getSectorsUseCase,this.getAllDepartmentsUseCase,this.getLetterByIdUseCase) : super(LetterDetailsInitial());

  static LetterDetailsCubit get(context) => BlocProvider.of(context);
  GetSectorsUseCase getSectorsUseCase;
  GetLetterByIdUseCase getLetterByIdUseCase;
  GetAllDepartmentsUseCase getAllDepartmentsUseCase;

  List<SelectedDepartmentModel?> selectedActionDepartmentsList = [];
  List<SelectedDepartmentModel?> selectedKnowDepartmentsList = [];
  List<SectorModel> sectorsList = [];
  List<DepartmentModel> departmentsList = [];
  LetterModel? letterModel;

  String formatDate(DateTime date) {
    var format2 = DateFormat("EEE , d MMM , yyyy" ,"ar");
    var dateString = format2.format(date);
    return dateString;
  }

  String letterAttachmentsToString(LetterModel model){
    final list = model.filesList;
    if(list == null || list.isEmpty){
      return AppStrings.notFound.tr();
    }else if(list.length == 1){
      return AppStrings.oneFile.tr();
    }else if(list.length == 2){
      return AppStrings.twoFiles.tr();
    }else{
      return "${list.length} ${AppStrings.files.tr()}";
    }
  }
  void openFileInBrowser(String filePath) async {
    String url = 'file://';
    print("URL : $url");
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void prepareDepartmentsList(LetterModel? model){
    if(model != null){
      for (var letterDepartment in model.departmentLetters) {
        var department = departmentsList.where((element) => element.departmentId == letterDepartment.departmentId).first;
        var sector = sectorsList.where((element) => element.sectorId == department.sectorId).first;
        if(letterDepartment.requiredAction){
          selectedActionDepartmentsList.add(SelectedDepartmentModel(letterDepartment.departmentId, department.departmentName, sector.sectorId, sector.sectorName, AppStrings.action.tr()));
        }else{
          print("HERE ITEM : ${letterDepartment.departmentId}");
          selectedKnowDepartmentsList.add(SelectedDepartmentModel(letterDepartment.departmentId, department.departmentName, sector.sectorId, sector.sectorName, AppStrings.know.tr()));
        }
      }
    }
  }
  Future<void> getSectors() async {
    emit(LetterDetailsLoadingSectors());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getSectorsUseCase(GetSectorsParameters(sessionToken));
    result.fold(
            (l) => emit(LetterDetailsErrorGetSectors(l.errMessage)),
            (r) {
          sectorsList = [];
          sectorsList = r;
          emit(LetterDetailsSuccessfulGetSectors());
        });
  }
  Future<void> getLetter(int letterId) async {
    emit(LetterDetailsLoadingLetter());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getLetterByIdUseCase(GetLetterByIdParameters(letterId ,sessionToken));
    result.fold(
            (l) => emit(LetterDetailsErrorGetLetter(l.errMessage)),
            (r) {
              print("RRR $r");
          letterModel = r;
          emit(LetterDetailsSuccessfulGetLetter());
        });
  }

  Future<void> getAllDepartments() async {
    emit(LetterDetailsLoadingDepartments());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getAllDepartmentsUseCase(GetAllDepartmentsParameters(sessionToken));
    result.fold(
            (l) => emit(LetterDetailsErrorGetDepartments(l.errMessage)),
            (r) {
          departmentsList = [];
          departmentsList = r;
          emit(LetterDetailsSuccessfulGetDepartments());
        });
  }
  void getData(int letterId)async{
    await getLetter(letterId);
    await getSectors();
    await getAllDepartments();
    print("IS NULL : ${letterModel?.departmentLetters}");
    prepareDepartmentsList(letterModel);
  }
  
  bool canReply(LetterModel model){
    var userMap = jsonDecode(Preference.getString("User").toString());
    UserModel myUserModel = UserModel.fromJson(userMap);
    if(model.departmentLetters.isNotEmpty){
      if(model.departmentLetters.where((element) => element.departmentId == myUserModel.departmentId).isNotEmpty){
        var departmentRole = model.departmentLetters.where((element) => element.departmentId == myUserModel.departmentId).first;
        return departmentRole.requiredAction;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }
}