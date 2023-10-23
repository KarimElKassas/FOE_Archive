import 'package:dio/dio.dart';
import 'package:foe_archive/core/error/failure.dart';
import 'package:foe_archive/data/models/department_model.dart';
import 'package:foe_archive/data/models/direction_model.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/data/models/sector_model.dart';
import 'package:foe_archive/data/models/tag_model.dart';
import 'package:foe_archive/domain/usecase/create_letter_use_case.dart';
import 'package:foe_archive/domain/usecase/get_all_departments_use_case.dart';
import 'package:foe_archive/domain/usecase/get_archived_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_departments_use_case.dart';
import 'package:foe_archive/domain/usecase/get_directions_use_case.dart';
import 'package:foe_archive/domain/usecase/get_for_me_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_incoming_internal_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_letter_by_id_use_case.dart';
import 'package:foe_archive/domain/usecase/get_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_sectors_use_case.dart';
import 'package:foe_archive/domain/usecase/get_tags_use_case.dart';
import 'package:foe_archive/domain/usecase/update_letter_use_case.dart';
import 'package:foe_archive/domain/usecase/upload_letter_files_use_case.dart';

import '../../../domain/usecase/delete_letter_use_case.dart';
import '../../../domain/usecase/get_outgoing_internal_letters_use_case.dart';
import '../../../domain/usecase/get_user_use_case.dart';
import '../../../domain/usecase/login_user_use_case.dart';
import '../../../resources/endpoints.dart';
import '../../../utils/dio_helper.dart';
import '../../models/user_model.dart';

abstract class BaseArchiveRemoteDataSource{
  Future<String> loginUser(LoginUserParameters parameters);
  Future<UserModel> getUser(GetUserParameters parameters);
  Future<List<LetterModel>> getLetters(GetLettersParameters parameters);
  Future<List<LetterModel>> getIncomingInternalLetters(GetIncomingLettersParameters parameters);
  Future<List<LetterModel>> getIncomingExternalLetters(GetIncomingLettersParameters parameters);
  Future<List<LetterModel>> getOutgoingInternalLetters(GetOutgoingLettersParameters parameters);
  Future<List<LetterModel>> getOutgoingExternalLetters(GetOutgoingLettersParameters parameters);
  Future<List<LetterModel>> getArchivedLetters(GetArchivedLettersParameters parameters);
  Future<List<LetterModel>> getForMeLetters(GetForMeLettersParameters parameters);
  Future<LetterModel?> getLetterById(GetLetterByIdParameters parameters);
  Future<int> createLetter(CreateLetterParameters parameters);
  Future<int> createArchivedLetter(CreateLetterParameters parameters);
  Future<int> createForMeLetter(CreateLetterParameters parameters);
  Future<String> updateLetter(UpdateLetterParameters parameters);
  Future<String> deleteLetter(DeleteLetterParameters parameters);
  Future<int> uploadLetterFiles(UploadLetterFilesParameters parameters);
  Future<List<DirectionModel>> getDirections(GetDirectionsParameters parameters);
  Future<List<TagModel>> getTags(GetTagsParameters parameters);
  Future<List<SectorModel>> getSectors(GetSectorsParameters parameters);
  Future<List<DepartmentModel>> getDepartments(GetDepartmentsParameters parameters);
  Future<List<DepartmentModel>> getAllDepartments(GetAllDepartmentsParameters parameters);
}

class ArchiveRemoteDataSource implements BaseArchiveRemoteDataSource{
  @override
  Future<UserModel> getUser(GetUserParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getUser, options: Options(headers: {
      'Authorization': 'Bearer ${parameters.data}',
      'Content-Type': 'application/json; charset=utf-8'
    }));
    Map<String, dynamic> data = response.data["data"];
    print("DATA MAP : $data");
    data['password'] = parameters.password;
    return UserModel.fromJson(data);
  }

  @override
  Future<String> loginUser(LoginUserParameters parameters)async {
    final response = await DioHelper.postData(url: EndPoints.login, data: parameters.data);
    if(response.data['success'] == true){
      return response.data["data"]["jwtToken"];
    }else{
      throw ServerFailure(response.data['errors'][0].toString());
    }
  }

  @override
  Future<List<LetterModel>> getLetters(GetLettersParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getLetters,
        options: Options(headers: {
      'Authorization': 'Bearer ${parameters.data}',
      'Content-Type': 'application/json; charset=utf-8'
    }));
    return List<LetterModel>.from((response.data['data'] as List).map((e) => LetterModel.fromJson(e)));

  }

  @override
  Future<List<DirectionModel>> getDirections(GetDirectionsParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getDirections,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.data}',
          'Content-Type': 'application/json; charset=utf-8'
        }));
    print("DATA MAP : ${response.data}");
    return List<DirectionModel>.from((response.data['data'] as List).map((e) => DirectionModel.fromJson(e)));
  }
  @override
  Future<int> createLetter(CreateLetterParameters parameters)async {
      final response = await DioHelper.postData(
          url: EndPoints.createLetter,
          options: Options(headers: {
            'Authorization': 'Bearer ${parameters.token}',
            'Content-Type': 'application/json; charset=utf-8'
          }),
          data: parameters.data
      );
      print(response);
      return response.data["data"];
  }

  @override
  Future<int> uploadLetterFiles(UploadLetterFilesParameters parameters)async {
    final response = await DioHelper.postData(
        url: EndPoints.uploadLetterFiles,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        data: parameters.data
    );
    print(response);
    return 0;
  }

  @override
  Future<List<TagModel>> getTags(GetTagsParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getTags,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.data}',
          'Content-Type': 'application/json; charset=utf-8'
        }));
    print("DATA MAP : ${response.data}");
    return List<TagModel>.from((response.data as List).map((e) => TagModel.fromJson(e)));

  }

  @override
  Future<List<DepartmentModel>> getDepartments(GetDepartmentsParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getDepartmentsBySector,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'sectorId': parameters.sectorId,
          'Content-Type': 'application/json; charset=utf-8'
        }));
    print("DATA MAP : ${response.data}");
    return List<DepartmentModel>.from((response.data['data'] as List).map((e) => DepartmentModel.fromJson(e)));

  }

  @override
  Future<List<SectorModel>> getSectors(GetSectorsParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getAllSectors,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.data}',
          'Content-Type': 'application/json; charset=utf-8'
        }));
    print("DATA MAP : ${response.data}");
    return List<SectorModel>.from((response.data['data'] as List).map((e) => SectorModel.fromJson(e)));
  }

  @override
  Future<List<DepartmentModel>> getAllDepartments(GetAllDepartmentsParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getAllDepartments,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }));
    print("DATA MAP : ${response.data}");
    return List<DepartmentModel>.from((response.data['data'] as List).map((e) => DepartmentModel.fromJson(e)));
  }

  @override
  Future<List<LetterModel>> getIncomingInternalLetters(GetIncomingLettersParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getIncomingInternalLetters,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.data}',
          'Content-Type': 'application/json; charset=utf-8'
        }));
    if(response.data['data'] != null){
      return List<LetterModel>.from((response.data['data'] as List).map((e) => LetterModel.fromJson(e)));
    }else{
      return [];
    }
  }

  @override
  Future<List<LetterModel>> getOutgoingInternalLetters(parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getOutgoingInternalLetters,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.data}',
          'Content-Type': 'application/json; charset=utf-8'
        }));
    if(response.data['data'] != null){
      return List<LetterModel>.from((response.data['data'] as List).map((e) => LetterModel.fromJson(e)));
    }else{
      return [];
    }
  }

  @override
  Future<int> createArchivedLetter(CreateLetterParameters parameters)async {
    final response = await DioHelper.postData(
        url: EndPoints.createArchivedLetter,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        data: parameters.data
    );
    print(response);
    return response.data["data"];
  }

  @override
  Future<int> createForMeLetter(CreateLetterParameters parameters)async {
    final response = await DioHelper.postData(
        url: EndPoints.createForMeLetter,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        data: parameters.data
    );
    print(response);
    return response.data["data"];

  }

  @override
  Future<List<LetterModel>> getArchivedLetters(GetArchivedLettersParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getArchivedLetters,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.data}',
          'Content-Type': 'application/json; charset=utf-8'
        }));
    if(response.data['data'] != null){
      return List<LetterModel>.from((response.data['data'] as List).map((e) => LetterModel.fromJson(e)));
    }else{
      return [];
    }
  }

  @override
  Future<List<LetterModel>> getForMeLetters(GetForMeLettersParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getForMeLetters,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.data}',
          'Content-Type': 'application/json; charset=utf-8'
        }));
    if(response.data['data'] != null){
      return List<LetterModel>.from((response.data['data'] as List).map((e) => LetterModel.fromJson(e)));
    }else{
      return [];
    }
  }

  @override
  Future<LetterModel?> getLetterById(GetLetterByIdParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getLetterById,
        options: Options(
            headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        },
        ),
      query: {'letterId': parameters.letterId}
    );
    if(response.data['data'] != null){
      return LetterModel.fromJson(response.data['data']);
    }else{
      return null;
    }

  }

  @override
  Future<List<LetterModel>> getOutgoingExternalLetters(GetOutgoingLettersParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getOutgoingExternalLetters,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.data}',
          'Content-Type': 'application/json; charset=utf-8'
        }));
    if(response.data['data'] != null){
      return List<LetterModel>.from((response.data['data'] as List).map((e) => LetterModel.fromJson(e)));
    }else{
      return [];
    }
  }

  @override
  Future<List<LetterModel>> getIncomingExternalLetters(GetIncomingLettersParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getIncomingExternalLetters,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.data}',
          'Content-Type': 'application/json; charset=utf-8'
        }));
    if(response.data['data'] != null){
      return List<LetterModel>.from((response.data['data'] as List).map((e) => LetterModel.fromJson(e)));
    }else{
      return [];
    }
  }

  @override
  Future<String> updateLetter(UpdateLetterParameters parameters)async {
    final response = await DioHelper.postData(
        url: EndPoints.updateLetter,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        data: parameters.data
    );
    print(response);
    return response.data["Message"];
  }

  @override
  Future<String> deleteLetter(DeleteLetterParameters parameters)async {
    final response = await DioHelper.postData(
        url: EndPoints.deleteLetter,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        query: {'letterId': parameters.letterId},
    );
    print(response);
    return response.data["Message"];

  }
}
