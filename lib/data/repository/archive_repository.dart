import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:foe_archive/data/datasource/remote_data_source.dart';
import 'package:foe_archive/data/models/department_model.dart';
import 'package:foe_archive/data/models/direction_model.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/data/models/sector_model.dart';
import 'package:foe_archive/data/models/tag_model.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';
import 'package:foe_archive/domain/usecase/create_letter_use_case.dart';
import 'package:foe_archive/domain/usecase/get_all_departments_use_case.dart';
import 'package:foe_archive/domain/usecase/get_archived_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_departments_use_case.dart';
import 'package:foe_archive/domain/usecase/get_directions_use_case.dart';
import 'package:foe_archive/domain/usecase/get_for_me_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_incoming_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_letter_by_id_use_case.dart';
import 'package:foe_archive/domain/usecase/get_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_outgoing_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_sectors_use_case.dart';
import 'package:foe_archive/domain/usecase/get_tags_use_case.dart';
import 'package:foe_archive/domain/usecase/upload_letter_files_use_case.dart';

import '../../core/error/failure.dart';
import '../../domain/usecase/get_user_use_case.dart';
import '../../domain/usecase/login_user_use_case.dart';
import '../models/user_model.dart';

class ArchiveRepository extends BaseArchiveRepository{
  BaseArchiveRemoteDataSource remoteDataSource;
  ArchiveRepository(this.remoteDataSource);
  @override
  Future<Either<Failure, String>> loginUser(LoginUserParameters parameters)async {
    try{
      final result = await remoteDataSource.loginUser(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUser(GetUserParameters parameters)async {
    try{
      final result = await remoteDataSource.getUser(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, List<LetterModel>>> getLetters(GetLettersParameters parameters)async {
    try{
      final result = await remoteDataSource.getLetters(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      print(e);
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, List<DirectionModel>>> getDirections(GetDirectionsParameters parameters)async {
    try{
      final result = await remoteDataSource.getDirections(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, int>> createLetter(CreateLetterParameters parameters)async {
    try{
      final result = await remoteDataSource.createLetter(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        print("ERROR DIO : $e");
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, int>> uploadLetterFiles(UploadLetterFilesParameters parameters)async {
    try{
      final result = await remoteDataSource.uploadLetterFiles(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        print("ERROR DIO : $e");
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, List<TagModel>>> getTags(GetTagsParameters parameters)async {
    try{
      final result = await remoteDataSource.getTags(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, List<DepartmentModel>>> getDepartments(GetDepartmentsParameters parameters)async {
    try{
      final result = await remoteDataSource.getDepartments(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, List<SectorModel>>> getSectors(GetSectorsParameters parameters)async {
    try{
      final result = await remoteDataSource.getSectors(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, List<DepartmentModel>>> getAllDepartments(GetAllDepartmentsParameters parameters)async {
    try{
      final result = await remoteDataSource.getAllDepartments(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, List<LetterModel>>> getIncomingLetters(GetIncomingLettersParameters parameters)async {
    try{
      final result = await remoteDataSource.getIncomingLetters(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      print(e);
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, List<LetterModel>>> getOutgoingLetters(GetOutgoingLettersParameters parameters)async {
    try{
      final result = await remoteDataSource.getOutgoingLetters(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      print(e);
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, int>> createArchivedLetter(CreateLetterParameters parameters)async {
    try{
      final result = await remoteDataSource.createArchivedLetter(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        print("ERROR DIO : $e");
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, int>> createForMeLetter(CreateLetterParameters parameters)async {
    try{
      final result = await remoteDataSource.createForMeLetter(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        print("ERROR DIO : $e");
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, List<LetterModel>>> getArchivedLetters(GetArchivedLettersParameters parameters)async {
    try{
      final result = await remoteDataSource.getArchivedLetters(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        print("ERROR DIO : $e");
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, List<LetterModel>>> getForMeLetters(GetForMeLettersParameters parameters)async {
    try{
      final result = await remoteDataSource.getForMeLetters(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        print("ERROR DIO : $e");
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, LetterModel?>> getLetterId(GetLetterByIdParameters parameters)async {
    try{
      final result = await remoteDataSource.getLetterById(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        print("ERROR DIO : $e");
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }
}